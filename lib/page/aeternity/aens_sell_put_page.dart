import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/aens_info_dao.dart';
import 'package:box/dao/aeternity/name_owner_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/name_owner_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_aens_point_page.dart';
import 'package:box/page/aeternity/ae_aens_transfer_page.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AensMarketDetailPage extends BaseWidget {
  final int currentHeight;
  final Map aensDetail;

  AensMarketDetailPage({
    Key? key,
    required this.aensDetail,
    required this.currentHeight,
  });

  @override
  _AeAensDetailPageState createState() => _AeAensDetailPageState();
}

class _AeAensDetailPageState extends BaseWidgetState<AensMarketDetailPage> {
  LoadingType _loadingType = LoadingType.finish;
  late Flushbar flush;

  String address = '';
  int errorCount = 0;
  String? accountPubkey = "";

  String nextRaisePrice = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
    aeAensMarketGetNameNextRaisePrice();
  }

  Future<void> aeAensMarketGetNameNextRaisePrice() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }
    address = account.address!;
    var params = {
      "name": "aeAensMarketGetNameNextRaisePrice",
      "params": {"ctAddress": "ct_b7BWkFT9FJPLYCCR7d8sNekCAfLrEJqQb93nXwpKSuMNgKFoz", "address": account.address, "leftAmount": widget.aensDetail["value"]["left_amount"]}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      nextRaisePrice = jsonResponse["result"].toString();

      setState(() {});
      return;
    }, channelJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "AENS详情",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: LoadingWidget(
        type: _loadingType,
        onPressedError: () {
          // netAensInfo();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildItem("AENS", widget.aensDetail["value"]["name"]), buildItem("起始价", AmountDecimal.parseUnits(widget.aensDetail["value"]["start_amount"], 18) + " AE"),
              buildItem("当前价", AmountDecimal.parseUnits(widget.aensDetail["value"]["current_amount"], 18) + " AE"),
              buildItem("发起人", Utils.formatAddress(widget.aensDetail["value"]["old_owner"])),
              buildItem("最后加价人", Utils.formatAddress(widget.aensDetail["value"]["new_owner"])),
              buildItem("距离结束", Utils.formatHeight(context, widget.currentHeight,
                  int.parse(widget.aensDetail["value"]["over_height"]))),
              buildItem("加价次数", widget.aensDetail["value"]["premium_count"] + "次"), getTypeButton(context)],
          ),
        ),
      ),
    );
  }

  Container getTypeButton(BuildContext context) {


    if (widget.aensDetail["value"]["new_owner"] == address &&  int.parse(widget.aensDetail["value"]["premium_count"]) == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 40, bottom: 30),
        child: Container(
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.8,
          child: FlatButton(
            onPressed: () {
              aeAensMarketRevokedName(context);
            },
            child: Text(
              "取消交易",
              maxLines: 1,
              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
            ),
            color: Color(0xff6F53A1),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      );
    }
    //已结束
    if (widget.currentHeight > int.parse(widget.aensDetail["value"]["over_height"])) {
      //可取
      if (widget.aensDetail["value"]["new_owner"] == address || widget.aensDetail["value"]["old_owner"] == address) {
        return Container(
          margin: const EdgeInsets.only(top: 40, bottom: 30),
          child: Container(
            height: 50,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            child: FlatButton(
              onPressed: () {
                aeAensMarketDealName(context);
              },
              child: Text(
                "完成交易",
                maxLines: 1,
                style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
              ),
              color: Color(0xFFFC2365),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: FlatButton(
          onPressed: () {
            aeAensMarketDealName(context);
          },
          child: Text(
            S
                .of(context)
                .aens_detail_page_add + " ≈ " + nextRaisePrice + " AE",
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
          ),
          color: Color(0xFFFC2365),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  getAddress() async {
    String address = await BoxApp.getAddress();
    this.address = address;

    setState(() {});
  }

  String getTypeValue() {
    if (widget.currentHeight > widget.aensDetail['endHeight']) {
      return Utils.formatHeight(context, widget.currentHeight, widget.aensDetail['overHeight']);
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return Utils.formatHeight(context, widget.currentHeight, widget.aensDetail['endHeight']);
    }

    return "-";
  }

  String getTypeKey() {
    if (widget.currentHeight > widget.aensDetail['endHeight']) {
      return S
          .of(context)
          .aens_list_page_item_time_end;
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return S
          .of(context)
          .aens_list_page_item_time_over;
    }

    return S
        .of(context)
        .aens_list_page_item_time_over;
  }

  Container buildBtnUpdate(BuildContext context) {
    if (widget.aensDetail['owner'] != address) {
      return Container();
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 20),
      child: Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: FlatButton(
          onPressed: () {
            netUpdateV2(context);
          },
          child: Text(
            S
                .of(context)
                .aens_detail_page_update,
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
          ),
          color: Color(0xff6F53A1),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  bool isPoint() {
    if (widget.aensDetail['owner'] != address) {
      return false;
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return false;
    }
    return true;
  }

  Future<void> netUpdateV2(BuildContext context) async {
    var name = widget.aensDetail['name'];
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      var params = {
        "name": "aeAensUpdate",
        "params": {"secretKey": "$privateKey", "name": "$name", "address": address}
      };
      var channelJson = json.encode(params);
      showChainLoading("正在更新AENS...");
      BoxApp.sdkChannelCall((result) {
        if (!mounted) return;
        dismissChainLoading();
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];
        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S
              .of(context)
              .dialog_hint, message);
          return;
        }
        var hash = jsonResponse["result"]["hash"];
        showCopyHashDialog(context, hash, (val) async {
          showFlushSucess(context);
        });
        setState(() {});
        return;
      }, channelJson);
    });
  }

  Future<void> aeAensMarketDealName(BuildContext context) async {
    var name = widget.aensDetail["value"]['name'];

    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      var params = {
        "name": "aeAensMarketDealName",
        "params": {"secretKey": "$privateKey", "ctAddress": "ct_b7BWkFT9FJPLYCCR7d8sNekCAfLrEJqQb93nXwpKSuMNgKFoz", "name": "$name"}
      };
      var channelJson = json.encode(params);
      showChainLoading("合约调用中...");
      BoxApp.sdkChannelCall((result) {
        if (!mounted) return;
        dismissChainLoading();
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];
        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S
              .of(context)
              .dialog_hint, message);
          return;
        }
        var hash = jsonResponse["result"]["hash"];
        showCopyHashDialog(context, hash, (val) async {
          showFlushSucess(context);
        });
        setState(() {});
        return;
      }, channelJson);
    });
    return;
  }

  Future<void> aeAensMarketRevokedName(BuildContext context) async {
    var name = widget.aensDetail["value"]['name'];

    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      var params = {
        "name": "aeAensMarketRevokedName",
        "params": {"secretKey": "$privateKey", "ctAddress": "ct_b7BWkFT9FJPLYCCR7d8sNekCAfLrEJqQb93nXwpKSuMNgKFoz", "name": "$name"}
      };
      var channelJson = json.encode(params);
      showChainLoading("取回中...");
      BoxApp.sdkChannelCall((result) {
        if (!mounted) return;
        dismissChainLoading();
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];
        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S
              .of(context)
              .dialog_hint, message);
          return;
        }
        var hash = jsonResponse["result"]["hash"];
        showFlushSucess(context,title:"调用成功",message: "成功取回域名"+name);
        setState(() {});
        return;
      }, channelJson);
    });
    return;
  }

  Container buildBtnAdd(BuildContext context) {
    if (widget.currentHeight > widget.aensDetail['endHeight']) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: Container(
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: FlatButton(
          onPressed: () {
            aeAensMarketDealName(context);
          },
          child: Text(
            S.of(context)
                .aens_detail_page_add + " ≈ " + (double.parse(widget.aensDetail['price']) + double.parse(widget.aensDetail['price']) * 0.1).toStringAsFixed(2) + " AE",
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
          ),
          color: Color(0xFFFC2365),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget buildItem(String key, String value) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            Fluttertoast.showToast(msg: S
                .of(context)
                .token_receive_page_copy_sucess,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      value,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
