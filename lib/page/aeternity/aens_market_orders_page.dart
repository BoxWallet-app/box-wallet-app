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

class AensMarketOrdersPage extends BaseWidget {
  @override
  _AensMarketOrdersPathState createState() => _AensMarketOrdersPathState();
}

class _AensMarketOrdersPathState extends BaseWidgetState<AensMarketOrdersPage> {
  var loadingType = LoadingType.loading;
  var aensOrders;
  var currentHeight;

  Future<void> _onRefresh() async {
    aeAensMarketGetNamesOrder();
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
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
      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> aeAensMarketGetNamesOrder() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }
    var params = {
      "name": "aeAensMarketGetNamesOrder",
      "params": {
        "ctAddress": "ct_b7BWkFT9FJPLYCCR7d8sNekCAfLrEJqQb93nXwpKSuMNgKFoz",
        "address": account.address,
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
          "AENS市场",
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
                  itemCount: loadingType == LoadingType.finish ? 1 : 0,
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
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOracleDetailPage(id: problemModel.data[index].index - 1)));
          },
          child: Container(

            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(

                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "AENS",
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color:  Colors.black),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: 38,
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.only(left: 15,right: 15),
                        decoration: new BoxDecoration(
                          color: Color(0xFFF22B79),
                          // color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(102.0)),
                        ),
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          "j.chain",
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle (fontSize:16,fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(

                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "价格",
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color:  Colors.black),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: new BoxDecoration(
                          // color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(102.0)),
                        ),
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          "0.02 AE",
                          maxLines: 1,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle (fontSize:18, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 1.5, color: Colors.black),
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
