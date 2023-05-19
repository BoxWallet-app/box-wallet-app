import 'dart:async';
import 'dart:convert';

import 'package:box/manager/cache_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import 'ae_home_page.dart';
import 'ae_vegas_page_detail.dart';

class AeVegasRecordPage extends BaseWidget {
  @override
  _VegasRecordPagePathState createState() => _VegasRecordPagePathState();
}

class _VegasRecordPagePathState extends BaseWidgetState<AeVegasRecordPage> {
  var loadingType = LoadingType.loading;

  var veagsMarkets;

  Map<String, dynamic> vegasDetails = {};

  int currentHeight = 0;

  Future<void> _onRefresh() async {
    vegasDetails.clear();
    netNodeHeight();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _onRefresh();
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
      aeVegasMarketRecords();
      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> aeVegasMarketRecords() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }
    //
    var params = {
      "name": "aeVegasMarketRecords",
      "params": {"ctAddress": "ct_pDFECPmzPmVR6EXZtwSFMwNaY8QNLKiXQfKPTQzs7jifFaPTL", "address": account.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      veagsMarkets = jsonResponse["result"];

      // if(veagsMarkets.length == 0){
      //   loadingType = LoadingType.no_data;
      // }
      setState(() {});

      for (int i = 0; i < veagsMarkets.length; i++) {
        aeVegasMarketDetail(veagsMarkets[i]['owner'], veagsMarkets[i]['market_id']);
      }



      return;
    }, channelJson);
  }

  Future<void> aeVegasMarketDetail(owner, marketId) async {
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
      "params": {"ctAddress": "ct_pDFECPmzPmVR6EXZtwSFMwNaY8QNLKiXQfKPTQzs7jifFaPTL", "address": account.address, "owner": owner, "marketId": marketId}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      vegasDetails[jsonResponse["result"]["market"]["market_id"]] = jsonResponse["result"];
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
          "My Record",
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
      ),
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
                  itemCount: loadingType == LoadingType.finish ? veagsMarkets.length : 0,
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
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 12, left: 18, right: 18),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xff1B1B23),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AeVegasDetailPage(marketId: veagsMarkets[index]["market_id"], owner: veagsMarkets[index]["owner"])));
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOracleDetailPage(id: problemModel.data[index].index - 1)));
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 12, right: 10, top: 5, bottom: 5),
                        child: Text(
                          "Put Time : " + Utils.formatTime(int.parse(veagsMarkets[index]["put_time"].toString())),
                          style: new TextStyle(
                            fontSize: 12,
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
                margin: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  veagsMarkets[index]["content"],
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only( left: 12, right: 12, bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  "My Answer: "+veagsMarkets[index]["put_result"],
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, left: 12, top: 10, bottom: 16),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "Input: " + AmountDecimal.parseUnits(veagsMarkets[index]["amount"], 18) + "AE",
                        style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xff9D9D9D)),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          if (vegasDetails[veagsMarkets[index]["market_id"]] == null)
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: const SizedBox(
                                width: 15,
                                height: 15,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xffffffff),
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          if (vegasDetails[veagsMarkets[index]["market_id"]] != null)
                            Container(
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                              decoration: new BoxDecoration(
                                // border: new Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: getResultColor(index),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    padding: EdgeInsets.all(2),
                                    child: Image(
                                      image: getResultIcon(index),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      getResultContent(index),
                                      style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                                    ),
                                  ),
                                ],
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getResultContent(int index) {
    //已经结束
    if (currentHeight > int.parse(vegasDetails[veagsMarkets[index]["market_id"]]["market"]["over_height"])) {
      //已经结束但是进度还是0 就表示等待结果中
      if ("0" == vegasDetails[veagsMarkets[index]["market_id"]]["market"]["progress"]) {
        return "Status: Wait Result";
      }
      // //已经有结果了,确认是否中奖
      //   //选择的第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"]);
      //   //结果是第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["market"]["result"]);
      //已中奖
      if(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"] == vegasDetails[veagsMarkets[index]["market_id"]]["market"]["result"]){
        //已领取
        if(vegasDetails[veagsMarkets[index]["market_id"]]["is_user_markets_receive_record"] ){
          return "Status: Winner";
        }
        return "Status: Wait Receive";
      }
      //未中奖
      return "Status: Not Winning";
    }
    return "Status: In Progress";
  }

  AssetImage getResultIcon(index) {
    //已经结束
    if (currentHeight > int.parse(vegasDetails[veagsMarkets[index]["market_id"]]["market"]["over_height"])) {
      //已经结束但是进度还是0 就表示等待结果中
      if ("0" == vegasDetails[veagsMarkets[index]["market_id"]]["market"]["progress"]) {
        return AssetImage("images/vegas_type_progress.png");
      }
      // //已经有结果了,确认是否中奖
      //   //选择的第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"]);
      //   //结果是第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["market"]["result"]);
      //已中奖
      if(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"] == vegasDetails[veagsMarkets[index]["market_id"]]["market"]["result"]){
        //已领取
        if(vegasDetails[veagsMarkets[index]["market_id"]]["is_user_markets_receive_record"] ){
          return AssetImage("images/vegas_type_success_ok.png");
        }
        return AssetImage("images/vegas_type_success_no.png");
      }
      //未中奖
      return AssetImage("images/vegas_type_failure.png");
    }
    return AssetImage("images/vegas_type_dice.png");
  }

  Color getResultColor(index) {
    //已经结束
    if (currentHeight > int.parse(vegasDetails[veagsMarkets[index]["market_id"]]["market"]["over_height"])) {
      //已经结束但是进度还是0 就表示等待结果中
      if ("0" == vegasDetails[veagsMarkets[index]["market_id"]]["market"]["progress"]) {
        return Color(0xff6200C3);
      }
      // //已经有结果了,确认是否中奖
      //   //选择的第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"]);
      //   //结果是第几个
      //   print(vegasDetails[veagsMarkets[index]["market_id"]]["market"]["result"]);
      //已中奖
      if(vegasDetails[veagsMarkets[index]["market_id"]]["get_user_markets_record_result"] == vegasDetails[veagsMarkets[index]["market_id"]]["market"]["result"]){
        //已领取
        if(vegasDetails[veagsMarkets[index]["market_id"]]["is_user_markets_receive_record"] ){
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
