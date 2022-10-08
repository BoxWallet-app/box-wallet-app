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

class AeVegasPage extends BaseWidget {
  @override
  _VegasPagePathState createState() => _VegasPagePathState();
}

class _VegasPagePathState extends BaseWidgetState<AeVegasPage> {
  var loadingType = LoadingType.finish;
  TokenListModel? tokenListModel;

  Future<void> _onRefresh() async {}

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _onRefresh();
    });
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
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
              Icons.add_circle_outline_outlined,
              color: Color(0xFFFFFFFF),
              size: 22,
            ),
            onPressed: () {
              showHintSafeDialog(S.of(context).tokens_dialog_title, S.of(context).tokens_dialog_content, (val) async {});
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
            //     style: new TextStyle(fontSize: 28, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
              child: Image(
                image: AssetImage("images/vegas_header_market.png"),
              ),
            ),
            Expanded(
              child: EasyRefresh(
                header: BoxHeader(),
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: 1,
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
                              style: new TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
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
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                  style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.5, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  "Source : https://www.fifa.com/",
                  style: new TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                        style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xff9D9D9D)),
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
                                    style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "0.01AE",
                              style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
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
