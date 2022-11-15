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

  var vegasMarket;
  var vegasResult;

  int currentHeight = 0;

  List<Widget> results = [];
  List<Widget> oracleUser = [];

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

  Future<void> aeVegasMarketDetail() async {
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
      "params": {"ctAddress": "ct_87pHYB8XbNT7yQGy3G4b7F6FKD4cSPhkuM6MWqCiYaam3FY7z", "address": account.address, "owner": widget.owner, "marketId": widget.marketId}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      vegasMarket = jsonResponse["result"]["market"];
      vegasResult = jsonResponse["result"];
      results.clear();
      for (var i = 0; i < vegasMarket["answers"].length; i++) {
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
                // Container(
                //   height: 40,
                //   margin: EdgeInsets.only(left: 10),
                //   width: (MediaQuery.of(context).size.width - 32) * 0.85,
                //   child: FlatButton(
                //     onPressed: () {
                //       aeVegasSubmitAnswer(i);
                //     },
                //     child: Text(
                //       getItemContent(i),
                //       maxLines: 1,
                //       style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                //     ),
                //     color: getItemColor(i),
                //     textColor: Colors.black,
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //   ),
                // )
                InkWell(
                  onTap: (){
                    showCommonDialog(context, "Confirm", "Whether to select "+vegasMarket["answers"][i]["content"] , S.of(context).dialog_conform, S.of(context).dialog_cancel, (val) async{
                      if(val) aeVegasSubmitAnswer(i);
                    });
                  },
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 10),
                    width: (MediaQuery.of(context).size.width - 32) * 0.85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Stack(
                        children: [
                          new LinearProgressIndicator(
                            backgroundColor: Color(0xff315bf7).withAlpha(60),
                            value: getItemPercentage(i),
                            minHeight: 40,
                            valueColor: new AlwaysStoppedAnimation<Color>(getItemColor(i)),
                          ),
                          Align(
                            child: Text(
                              getItemContent(i),
                              maxLines: 1,
                              style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      oracleUser.clear();

      if (vegasResult["get_oracle_market_record"].length > 0) {
        oracleUser.add(Container(
          padding: EdgeInsets.only(bottom: 7, top: 7),
          child: Text(
            "Provider:",
            style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
          ),
        ));
        for (var i = 0; i < vegasResult["get_oracle_market_record"].length; i++) {
          var answer = vegasMarket["answers"][int.parse(vegasResult["get_oracle_market_record"][i]["value"])]["content"];
          var name = "";
          for (var j = 0; j < vegasResult["get_aggregator_user"].length; j++) {
            if (vegasResult["get_aggregator_user"][j]["key"] == vegasResult["get_oracle_market_record"][i]["key"]) {
              name = vegasResult["get_aggregator_user"][j]["value"];
            }
          }

          oracleUser.add(
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 7, top: 7, right: 10),
              decoration: new BoxDecoration(
                color: Colors.grey.withAlpha(100),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Text(
                name + " > " + answer,
                style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
              ),
            ),
          );
        }
      }

      setState(() {});
      return;
    }, channelJson);
  }

  String getItemContent(int index) {
    if (vegasResult["is_user_markets_record"]) {
      if (int.parse(vegasResult["get_user_markets_record_result"].toString()) == index) {
        return vegasMarket["answers"][index]["content"] + " " + (double.parse(vegasMarket["answers"][index]["count"]) / double.parse(vegasMarket["put_count"]) * 100).toStringAsFixed(2) + "%" + " (My)";
      }
      return vegasMarket["answers"][index]["content"] + " " + (double.parse(vegasMarket["answers"][index]["count"]) / double.parse(vegasMarket["put_count"]) * 100).toStringAsFixed(2) + "%";
    }
    return vegasMarket["answers"][index]["content"];
  }
  double getItemPercentage(int index) {

    if (vegasResult["is_user_markets_record"]) {
      if (int.parse(vegasResult["get_user_markets_record_result"].toString()) == index) {
        return double.parse(vegasMarket["answers"][index]["count"]) / double.parse(vegasMarket["put_count"]);
      }
       return double.parse(vegasMarket["answers"][index]["count"]) / double.parse(vegasMarket["put_count"]);
    }
    return 1;
  }


  Color getItemColor(int index) {
    if (vegasResult["is_user_markets_record"]) {
      if (int.parse(vegasResult["get_user_markets_record_result"].toString()) == index) {
        return Color(0xff315bf7).withAlpha(999);
      }
      return Color(0xff315bf7).withAlpha(100);
    }
    return Color(0xff315bf7).withAlpha(999);
  }

  Future<void> aeVegasSubmitAnswer(int index) async {
    if (!mounted) return;
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      var params = {
        "name": "aeVegasSubmitAnswer",
        "params": {"secretKey": privateKey, "ctAddress": "ct_87pHYB8XbNT7yQGy3G4b7F6FKD4cSPhkuM6MWqCiYaam3FY7z", "owner": vegasMarket["owner"], "marketId": vegasMarket["market_id"], "selectIndex": index, "amount": vegasMarket["min_amount"]}
      };
      var channelJson = json.encode(params);
      showChainLoading("Submit...");
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

  Future<void> aeVegasReceiveReward() async {
    if (!mounted) return;
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      var params = {
        "name": "aeVegasReceiveReward",
        "params": {"secretKey": privateKey, "ctAddress": "ct_87pHYB8XbNT7yQGy3G4b7F6FKD4cSPhkuM6MWqCiYaam3FY7z", "owner": vegasMarket["owner"], "marketId": vegasMarket["market_id"]}
      };
      var channelJson = json.encode(params);
      showChainLoading("Receive...");
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
      aeVegasMarketDetail();
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
          "Content Detail",
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
                      margin: const EdgeInsets.only(bottom: 12, left: 19, right: 18),
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
                                        size: 17,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          "Safe",
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
                                      (Utils.formatHeight(context, currentHeight, int.parse(vegasMarket["over_height"].toString()))).toString() == "-" ? "End Time:" + (Utils.formatHeightTime(context, currentHeight, int.parse(vegasMarket["over_height"].toString()))).toString() : "End Over:" + (Utils.formatHeight(context, currentHeight, int.parse(vegasMarket["over_height"].toString()))).toString(),
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
                              vegasMarket["content"],
                              textAlign: TextAlign.left,
                              style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(
                              "Source :  " + vegasMarket["source_url"],
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
                                    "Total: " + AmountDecimal.parseUnits(vegasMarket["total_amount"], 18) + " (AE)",
                                    style: new TextStyle(fontSize: 12, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xff9D9D9D)),
                                  ),
                                ),
                                Expanded(child: Container()),
                                if (isMarketOver())
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(2),
                                          padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                          decoration: new BoxDecoration(
                                            // border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: getResultColor(),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                padding: EdgeInsets.all(2),
                                                child: Image(
                                                  image: getResultIcon(),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: Text(
                                                  getResultContent(),
                                                  style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!isMarketOver())
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(color: Color.fromARGB(152, 255, 255, 255), width: 1),
                                      //设置四周圆角 角度
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(1),
                                          padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                          decoration: new BoxDecoration(
                                            // border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: getResultColor(),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                padding: EdgeInsets.all(2),
                                                child: Image(
                                                  image: getResultIcon(),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5),
                                                padding: EdgeInsets.only(right: 5),
                                                child: Text(
                                                  getResultContent(),
                                                  style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 5, right: 5),
                                          child: Text(
                                            AmountDecimal.parseUnits(vegasMarket["min_amount"], 18) + "/AE",
                                            style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
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
                      margin: const EdgeInsets.only(bottom: 12, left: 18, right: 18),
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
                                    "Select a result",
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
                      margin: const EdgeInsets.only(bottom: 12, left: 18, right: 18),
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
                                    "Result Detail",
                                    style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 12),
                              child: Text(
                                "The end result is this: " + formatMarketResult(),
                                style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            if (oracleUser.length > 0)
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 12),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: oracleUser,
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 10, top: 20, bottom: 14, right: 10),
                                  child: FlatButton(
                                    onPressed: () {
                                      if (getIsReceive()) aeVegasReceiveReward();
                                    },
                                    child: Text(
                                      getReceiveBtnContent(),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                    ),
                                    color: getReceiveBtnColor(),
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

  Color getReceiveBtnColor() {
    if (vegasMarket["result"] == "-1") {
      return Colors.grey.withAlpha(100);
    }
    if (vegasResult["is_user_markets_receive_record"]) {
      return Colors.grey.withAlpha(100);
    }
    if (vegasResult["get_user_markets_record_result"] != vegasMarket["result"]) {
      return Colors.grey.withAlpha(100);
    }
    return Color(0xff315bf7);
  }

  bool getIsReceive() {
    if (vegasMarket["result"] == "-1") {
      return false;
    }
    if (vegasResult["is_user_markets_receive_record"]) {
      return false;
    }
    if (vegasResult["get_user_markets_record_result"] != vegasMarket["result"]) {
      return false;
    }
    return true;
  }

  String getReceiveBtnContent() {
    if (vegasMarket["result"] == "-1") {
      return "There is no over";
    }
    if (vegasResult["is_user_markets_receive_record"]) {
      return "Successful receive";
    }
    if (vegasResult["get_user_markets_record_result"] != vegasMarket["result"]) {
      return "Not Winner";
    }

    var totalAmount = double.parse(vegasMarket["total_amount"]);
    var winAmount = double.parse(vegasMarket["answers"][int.parse(vegasMarket["result"])]["count"]);

    var receiveAmount = AmountDecimal.parseUnits((totalAmount / winAmount).toString(), 18);
    return "Receive ≈(" + receiveAmount + "AE)";
  }

  formatMarketResult() {
    if (vegasMarket["result"] == "-1") {
      if (vegasResult["get_oracle_market_record"].length > 0) {
        return "It need more data";
      }
      return getReceiveBtnContent();
    } else {
      return vegasMarket["answers"][int.parse(vegasMarket["result"].toString())]["content"];
    }
  }

  bool isMarketOver() {
    if (currentHeight > int.parse(vegasMarket["over_height"])) {
      return true;
    }
    return false;
  }

  String getResultContent() {
    //已经结束
    if (currentHeight > int.parse(vegasMarket["over_height"])) {
      //已经结束但是进度还是0 就表示等待结果中
      if ("0" == vegasMarket["progress"]) {
        return "Status: Waiting for results";
      }
      //已中奖
      if (vegasResult["get_user_markets_record_result"] == vegasMarket["result"]) {
        //已领取
        if (vegasResult["is_user_markets_receive_record"]) {
          return "Status: Obtained";
        }
        return "Status: Waiting for receive";
      }
      //未中奖
      return "Status: Not winning";
    }
    return "Status: In progress";
  }

  AssetImage getResultIcon() {
    //已经结束
    if (currentHeight > int.parse(vegasMarket["over_height"])) {
      //已经结束但是进度还是0 就表示等待结果中
      if ("0" == vegasMarket["progress"]) {
        return AssetImage("images/vegas_type_progress.png");
      }
      // //已经有结果了,确认是否中奖
      //   //选择的第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"]);
      //   //结果是第几个
      //   print(veagsMarket["result"]);
      //已中奖
      if (vegasResult["get_user_markets_record_result"] == vegasMarket["result"]) {
        //已领取
        if (vegasResult["is_user_markets_receive_record"]) {
          return AssetImage("images/vegas_type_success_ok.png");
        }
        return AssetImage("images/vegas_type_success_no.png");
      }
      //未中奖
      return AssetImage("images/vegas_type_failure.png");
    }
    return AssetImage("images/vegas_type_dice.png");
  }

  Color getResultColor() {
    //已经结束
    if (currentHeight > int.parse(vegasMarket["over_height"])) {
      //已经结束但是进度还是0 就表示等待结果中
      if ("0" == vegasMarket["progress"]) {
        return Color(0xff6200C3);
      }
      // //已经有结果了,确认是否中奖
      //   //选择的第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"]);
      //   //结果是第几个
      //   print(veagsMarket["result"]);
      //已中奖
      if (vegasResult["get_user_markets_record_result"] == vegasMarket["result"]) {
        //已领取
        if (vegasResult["is_user_markets_receive_record"]) {
          return Color(0xff58A000);
        }
        return Color(0xff315BF7);
      }
      //未中奖
      return Color(0xffA0A4B3);
    }
    return Color(0xff315bf7);
  }
}
