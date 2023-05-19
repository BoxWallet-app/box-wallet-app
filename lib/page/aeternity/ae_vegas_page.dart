import 'dart:async';
import 'dart:convert';

import 'package:box/manager/cache_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import 'ae_home_page.dart';
import 'ae_vegas_page_detail.dart';
import 'ae_vegas_record_page.dart';

class AeVegasPage extends BaseWidget {
  @override
  _VegasPagePathState createState() => _VegasPagePathState();
}

class _VegasPagePathState extends BaseWidgetState<AeVegasPage> {
  var loadingType = LoadingType.loading;

  var vegasMarkets;

  int currentHeight = 0;

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

  Future<void> aeVegasMarketStart() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }
    //
    var params = {
      "name": "aeVegasMarketStart",
      "params": {"ctAddress": "ct_pDFECPmzPmVR6EXZtwSFMwNaY8QNLKiXQfKPTQzs7jifFaPTL", "address": "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF", "isSelf": false}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      vegasMarkets = jsonResponse["result"];

      setState(() {});
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
      aeVegasMarketStart();
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
          "SuperHero Vegas",
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
            splashRadius: 40,
            icon: Icon(
              Icons.history,
              color: Color(0xFFFFFFFF),
              size: 22,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AeVegasRecordPage()));
            },
          ),
        ],
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
            //   alignment: Alignment.topLeft,
            //   child: Text(
            //     "Welcome Back to AEVegas!",
            //     style: new TextStyle(fontSize: 20, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(left: 18, right: 18, bottom: 12, top: 12),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: CachedNetworkImage(
                imageUrl: "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/images/veags_header.jpg",
                fadeOutDuration: const Duration(seconds: 0),
                fadeInDuration: const Duration(seconds: 0),
                fit: BoxFit.cover,
              ),
            ),
            loadingType == LoadingType.finish && vegasMarkets.length == 0
                ? Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 100,
                        ),
                        child: Text(
                          "There is no game in progress",
                          style: new TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: EasyRefresh(
                      header: BoxHeader(),
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        itemCount: loadingType == LoadingType.finish ? vegasMarkets.length : 0,
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
      margin: const EdgeInsets.only(bottom: 12, left: 18, right: 19),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xff1B1B23),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AeVegasDetailPage(marketId: vegasMarkets[index]["value"]["market_id"], owner: vegasMarkets[index]["value"]["owner"])));
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
                      // padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                        color: Color(0xff315bf7),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.safety_check,
                            color: Colors.white,
                            size: 14,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: Text(
                              "",
                              style: new TextStyle(fontSize: 12, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
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
                          "End Time:" + (Utils.formatHeight(context, currentHeight, int.parse(vegasMarkets[index]["value"]["over_height"].toString()))).toString(),
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
                  vegasMarkets[index]["value"]["content"],
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  "Source:" + vegasMarkets[index]["value"]["source_url"],
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
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        "Total:" + AmountDecimal.parseUnits(vegasMarkets[index]["value"]["total_amount"], 18) + "(AE)",
                        style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xff9D9D9D)),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Color.fromARGB(152, 255, 255, 255), width: 1),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(5)),
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
                              AmountDecimal.parseUnits(vegasMarkets[index]["value"]["min_amount"], 18) + "/AE",
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
