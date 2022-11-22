import 'dart:async';
import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/event/language_event.dart';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import 'ae_aens_page.dart';
import 'ae_home_page.dart';
import 'ae_vegas_page_detail.dart';
import 'aens_market_detail_page.dart';
import 'aens_my_sell_list_page.dart';

class AensMarketOrdersPage extends BaseWidget {
  @override
  _AensMarketOrdersPathState createState() => _AensMarketOrdersPathState();
}

class _AensMarketOrdersPathState extends BaseWidgetState<AensMarketOrdersPage> {
  var loadingType = LoadingType.loading;
  List aensOrders = [];
  var currentHeight;
  var isAeAensMarketIsTradableAddress = false;

  Future<void> _onRefresh() async {
    netNodeHeight();

  }

  @override
  void initState() {
    super.initState();
    eventBus.on<AensUpdateEvent>().listen((event) {
      if (!mounted) return;
       loadingType = LoadingType.loading;
      setState(() {});
      _onRefresh();
    });
    _onRefresh();
  }

  Future<void> aeAensMarketIsTradableAddress() async {
    EasyLoading.show();
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var params = {
      "name": "aeAensMarketIsTradableAddress",
      "params": {"ctAddress": "ct_vQz54zLcjuiRKLvn2iTakidNVnfJaDV7jDyBrLhVfoziHSWU6", "address": account!.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;

      //{"code":200,"message":"","name":"aeAensMarketIsTradableAddress","result":{"name":"baixin"}}
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      EasyLoading.dismiss();
      var name = jsonResponse["result"]["name"];
      if (name == "") {
        isAeAensMarketIsTradableAddress = false;
        showConfirmDialog(S.of(context).ae_aens_add_error_1,S.of(context).ae_aens_add_error_2);
        return;

      } else {
        isAeAensMarketIsTradableAddress = true;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => MySellAeAensListPage()));
      return;
    }, channelJson);
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
      aeAensMarketGetNamesOrder();
      return;
    }, channelJson);
  }

  Future<void> aeAensMarketGetNamesOrder() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();

    var params = {
      "name": "aeAensMarketGetNamesOrder",
      "params": {
        "ctAddress": "ct_vQz54zLcjuiRKLvn2iTakidNVnfJaDV7jDyBrLhVfoziHSWU6",
        "address": account!.address,
      }
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      aensOrders = jsonResponse["result"];

      if (aensOrders.length == 0) {
        loadingType = LoadingType.no_data;
      }

      setState(() {});

      return;
    }, channelJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "Aens Market",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          aeAensMarketIsTradableAddress();
        },
        child: new Icon(Icons.add),
        elevation: 3.0,
        highlightElevation: 2.0,
        backgroundColor: Color(0xFFFC2365),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: Column(
          children: [
            Expanded(
              child: EasyRefresh(
                header: BoxHeader(),
                onRefresh: _onRefresh,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: loadingType == LoadingType.finish ? aensOrders.length : 0,
                  padding: const EdgeInsets.only(bottom: 50),
                  itemBuilder: (BuildContext context, int index) {
                    return itemListView(context, index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemListView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 18, right: 18),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AensMarketDetailPage(currentHeight: currentHeight, name: aensOrders[index]["value"]["name"])));
          },
          child: Container(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 18),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "AENS",
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                          ),
                        ),
                      ),
                      // Expanded(child: Container(),),
                      Expanded(
                        child: Container(

                          margin: EdgeInsets.only(left: 50),
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          decoration: new BoxDecoration(
                            // color: Color(0xFFF22B79),
                            // color: Colors.white,
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(102.0)),
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(

                            aensOrders[index]["value"]["name"],

                            softWrap: true,
                            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 18),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).ae_aens_item_price,
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          // color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(102.0)),
                        ),
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          AmountDecimal.parseUnits(aensOrders[index]["value"]["current_amount"], 18),
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).ae_aens_item_owner,
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          // color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(102.0)),
                        ),
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          Utils.formatAddress(aensOrders[index]["value"]["old_owner"]),
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).ae_aens_item_new_owner,
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          // color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(102.0)),
                        ),
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          Utils.formatAddress(
                            Utils.formatAddress(aensOrders[index]["value"]["new_owner"]),
                          ),
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18, bottom: 18),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).ae_aens_item_over_time,
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          // color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(102.0)),
                        ),
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          Utils.formatHeight(context, currentHeight, int.parse(aensOrders[index]["value"]["over_height"])),
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.black),
                        ),
                      ),
                    ],
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
