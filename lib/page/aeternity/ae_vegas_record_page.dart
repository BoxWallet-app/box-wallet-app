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
import 'ae_vegas_page_detail.dart';

class AeVegasRecordPage extends BaseWidget {
  @override
  _VegasRecordPagePathState createState() => _VegasRecordPagePathState();
}

class _VegasRecordPagePathState extends BaseWidgetState<AeVegasRecordPage> {
  var loadingType = LoadingType.loading;

  var veagsMarkets;

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
      "name": "aeVegasMarkeRecords",
      "params": {"ctAddress": "ct_xt1mtLzwBVMKxMMhgeCD7UCXqYF253LPvsCBrxrZPFnKguAZQ", "address": account.address}
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
      margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xff1B1B23),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AeVegasDetailPage(marketId: veagsMarkets[index]["value"]["market_id"], owner: veagsMarkets[index]["value"]["owner"])));
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
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(
                          "发生时间 : "+  veagsMarkets[index]["put_time"],
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
                margin: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  veagsMarkets[index]["content"],
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 16),
                height: 40,

                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        "投入: "+veagsMarkets[index]["amount"],
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
                              "AE/次",
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
