import 'dart:async';
import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_token_record_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import 'ae_home_page.dart';

class AeVegasDetailPage extends BaseWidget {
  final String marketId;
  final String owner;

  AeVegasDetailPage({Key? key, required this.marketId, required this.owner});
  @override
  _VegasDetailPagePathState createState() => _VegasDetailPagePathState();
}

class _VegasDetailPagePathState extends BaseWidgetState<AeVegasDetailPage> {
  var loadingType = LoadingType.loading;

  var veagsMarket;
  var veagsResult;

  int currentHeight = 0;

  List<Widget> results = [];

  Future<void> _onRefresh() async {
    netNodeHeight();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _onRefresh();
    });
  }

  Future<void> aeVegasMarkeStart() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }
    //
    var params = {
      "name": "aeVegasMarketDetail",
      "params": {"ctAddress": "ct_xt1mtLzwBVMKxMMhgeCD7UCXqYF253LPvsCBrxrZPFnKguAZQ", "address": account.address, "owner": widget.owner, "marketId": widget.marketId}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      veagsMarket = jsonResponse["result"]["market"];
      veagsResult = jsonResponse["result"];
      results.clear();
      for (var i = 0; i < veagsMarket["answers"].length; i++) {
        results.add(
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    (i + 1).toString(),
                    style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                  ),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 10),
                  width: (MediaQuery.of(context).size.width - 32) * 0.85,
                  child: FlatButton(
                    onPressed: () {
                      aeVegasSubmitAnswer(i);
                    },
                    child: Text(
                      getItemContent(i),
                      maxLines: 1,
                      style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                    ),
                    color: getItemColor(i),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
          ),
        );
      }

      setState(() {});
      return;
    }, channelJson);
  }

  String getItemContent(int index) {
    if (veagsResult["is_user_markets_record"]) {
      if (int.parse(veagsResult["get_user_markets_record_result"].toString()) == index) {
        return veagsMarket["answers"][index]["content"] + " " + (double.parse(veagsMarket["answers"][index]["count"]) / double.parse(veagsMarket["put_count"]) * 100).toStringAsFixed(2) + "%" + " (我的)";
      }
      return veagsMarket["answers"][index]["content"] + " " + (double.parse(veagsMarket["answers"][index]["count"]) / double.parse(veagsMarket["put_count"]) * 100).toStringAsFixed(2) + "%";
    }
    return veagsMarket["answers"][index]["content"];
  }

  Color getItemColor(int index) {
    if (veagsResult["is_user_markets_record"]) {
      if (int.parse(veagsResult["get_user_markets_record_result"].toString()) == index) {
        return Color(0xff315bf7).withAlpha(999);
      }
      return Color(0xff315bf7).withAlpha(30);
    }
    return Color(0xff315bf7).withAlpha(999);
  }

  Future<void> aeVegasSubmitAnswer(int index) async {
    if (!mounted) return;
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      var params = {
        "name": "aeVegasSubmitAnswer",
        "params": {"secretKey": privateKey, "ctAddress": "ct_xt1mtLzwBVMKxMMhgeCD7UCXqYF253LPvsCBrxrZPFnKguAZQ", "owner": "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF", "marketId": veagsMarket["market_id"], "selectIndex": index, "amount": veagsMarket["min_amount"]}
      };
      var channelJson = json.encode(params);
      showChainLoading("提交中...");
      BoxApp.sdkChannelCall((result) {
        if (!mounted) return;
        dismissChainLoading();
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];

        if (code == 200) {
          loadingType = LoadingType.loading;
          setState(() {});
          _onRefresh();
        } else {
          var message = jsonResponse["message"];
          showConfirmDialog(S.of(context).dialog_hint, message);
        }

        setState(() {});
        return;
      }, channelJson);
    });
  }

  void netNodeHeight() {
    var params = {
      "name": "aeGetCurrentHeight",
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;

      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      currentHeight = jsonResponse["result"]["height"];
      aeVegasMarkeStart();
      setState(() {});
      return;
    }, channelJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f0017),
      appBar: AppBar(
        backgroundColor: Color(0xff0f0017),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "Market Detail",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.ios_share_outlined,
              color: Color(0xFFFFFFFF),
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: EasyRefresh(
          header: BoxHeader(),
          onRefresh: _onRefresh,
          child: loadingType == LoadingType.loading
              ? Container()
              : Column(
                  children: [
                    Container(
                      //边框设置
                      decoration: new BoxDecoration(
                        color: Color(0xff1B1B23),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 16,
                                ),
                                Container(
                                  //边框设置
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                  decoration: new BoxDecoration(
                                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                                    color: Color(0xff315bf7),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.safety_check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          "安全",
                                          style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(
                                      "距离结束 : " + (Utils.formatHeight(context, currentHeight, int.parse(veagsMarket["over_height"].toString()))).toString(),
                                      style: new TextStyle(
                                        fontSize: 14,
                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                            color: Color.fromARGB(40, 255, 255, 255),
                            height: 1,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              veagsMarket["content"],
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(
                              "数据源 :  " + veagsMarket["source_url"],
                              style: new TextStyle(
                                fontSize: 14,
                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 16),
                            height: 40,
                            decoration: new BoxDecoration(
                              border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                              color: Color(0xFF000000),
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    "总投入:" + AmountDecimal.parseUnits(veagsMarket["total_amount"], 18) + "(AE)",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xff9D9D9D)),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: new BoxDecoration(
                                    border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(2),
                                        decoration: new BoxDecoration(
                                          // border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                                          //设置四周圆角 角度
                                          borderRadius: BorderRadius.all(Radius.circular(2)),
                                          color: Color(0xff315bf7),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              padding: EdgeInsets.all(2),
                                              child: Image(
                                                image: AssetImage("images/vegas_type_dice.png"),
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              padding: EdgeInsets.only(right: 5),
                                              child: Text(
                                                "进行中",
                                                style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                          AmountDecimal.parseUnits(veagsMarket["min_amount"], 18) + "/AE",
                                          style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width - 32),
                            //边框设置
                            decoration: new BoxDecoration(
                              color: Colors.green,
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      //边框设置
                      decoration: new BoxDecoration(
                        color: Color(0xff1B1B23),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
                      padding: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 20),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 25,
                                  decoration: new BoxDecoration(
                                    color: Color(0xff315bf7),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  child: Text(
                                    "选择一个结果",
                                    style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: results,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      //边框设置
                      decoration: new BoxDecoration(
                        color: Color(0xff1B1B23),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
                      padding: EdgeInsets.all(14),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 25,
                                  decoration: new BoxDecoration(
                                    color: Color(0xff315bf7),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  child: Text(
                                    "结果详情",
                                    style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 12),
                              child: Text(
                                "The end result is : Not over yet",
                                style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10, bottom: 14, right: 10),
                                  child: FlatButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Not over yet",
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                    ),
                                    color: Colors.grey.withAlpha(999),
                                    textColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget itemListView(BuildContext context, int index) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xff1B1B23),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOracleDetailPage(id: problemModel.data[index].index - 1)));
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 16,
                    ),
                    Container(
                      //边框设置
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                        color: Color(0xff315bf7),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.temple_hindu_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              "SAFE",
                              style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(
                          "EndTime : 30 Days",
                          style: new TextStyle(
                            fontSize: 14,
                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                color: Color.fromARGB(40, 255, 255, 255),
                height: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                child: Text(
                  "Qatar World Cup & The first round On November 21 🇸🇳Senegal VS 🇳🇱Holland, Who will win!",
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  "Source : https://www.fifa.com/",
                  style: new TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 16),
                height: 40,
                decoration: new BoxDecoration(
                  border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                  color: Color(0xFF000000),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        "Total:0(AE)",
                        style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xff9D9D9D)),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              // border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                              color: Color(0xff315bf7),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  padding: EdgeInsets.all(2),
                                  child: Image(
                                    image: AssetImage("images/vegas_type_dice.png"),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2),
                                  padding: EdgeInsets.only(right: 2),
                                  child: Text(
                                    "IN PROGRESS",
                                    style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "0.01AE",
                              style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 32),
                //边框设置
                decoration: new BoxDecoration(
                  color: Colors.green,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
