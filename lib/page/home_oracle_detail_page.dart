import 'dart:io';
import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/name_reverse_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/name_reverse_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/setting_page_v2.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class HomeOracleDetailPage extends StatefulWidget {
  @override
  _HomeOracleDetailPageState createState() => _HomeOracleDetailPageState();
}

class _HomeOracleDetailPageState extends State<HomeOracleDetailPage> with AutomaticKeepAliveClientMixin {
  DateTime lastPopTime;
  PriceModel priceModel;
  List<NameReverseModel> namesModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    netNameReverseData();
    netBaseData();
    netAccountInfo();
    getAddress();
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      HomePageV2.address = address;
      setState(() {});
    });
  }

  void netBaseData() {
    var type = "usd";
//    if (BoxApp.language == "cn") {
//      type = "cny";
//    } else {
//      type = "usd";
//    }
    PriceDao.fetch(type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netNameReverseData() {
    NameReverseDao.fetch().then((List<NameReverseModel> model) {
      if (model.isNotEmpty) {
        if (model.isNotEmpty) {
          model.sort((left, right) => right.expiresAt.compareTo(left.expiresAt));
        }
        namesModel = model;
        setState(() {});
      } else {}
    }).catchError((e) {
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice() {
    if (HomePageV2.token == "loading...") {
      return "";
    }
    if (priceModel.aeternity.usd == null) {
      return "";
    }
    return " \$" + (priceModel.aeternity.usd * double.parse(HomePageV2.token)).toStringAsFixed(2) + " ≈ ";
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        // HomePage.token = "8888.88888";
        HomePageV2.token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xff20242F),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff20242F),
          // 隐藏阴影
          leading: BoxApp.isOpenStore
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 17,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
          title: Text(
            "Oracle Detail",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            EasyRefresh(
              header: AEHeader(),
              child: Container(

                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
//                    Container(
//                      height: 50,
//                      margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
//                      alignment: Alignment.centerLeft,
//                      child: Row(
//                        children: [
//                          Expanded(
//                            child: Text(
//                              "The ongoing Oracles Tournament",
//                              style: TextStyle(
//                                color: Color(0xFFffffff),
//                                fontWeight: FontWeight.w500,
//                                fontSize: 16,
//                                fontFamily: BoxApp.language == "cn"
//                                    ? "Ubuntu"
//                                    : BoxApp.language == "cn"
//                                        ? "Ubuntu"
//                                        : "Ubuntu",
//                              ),
//                            ),
//                          ),
//                          Container(
//                            width: 15,
//                          ),
//                        ],
//                      ),
//                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        color: Color(0xff242A37),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 16,
                              ),
                              Container(
                                child: Text(
                                  "140.00 AE",
                                  style: new TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665), letterSpacing: 1.2, height: 1.4),
                                ),
                              ),
//                            Container(
//                              alignment: Alignment.topRight,
//                              margin: EdgeInsets.only(left: 10, right: 10),
//                              child: Row(
//                                children: [
//                                  Text(
//                                    "总押注:10AE",
//                                    style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
//                                  ),
//                                  Expanded(child: Container()),
//                                  Text(
//                                    "单注:10.00AE/次",
//                                    style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
//                                  ),
//                                ],
//                              ),
//                            ),



                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 16),
                                child: Text(
                                  "The total vote",
                                  style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
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
                                child: Row(
                                  children: [],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        color: Color(0xff242A37),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 16,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 16,
                                  ),
                                  Text(
                                    "#2",
                                    style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665), letterSpacing: 1.2, height: 1.4),
                                  ),
                                  Container(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Liu Shaohong, Liu Shao, Liu Yang, Liu Bo after all is not one person？",
                                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white, letterSpacing: 1.2, height: 1.4),
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                ],
                              ),
                              Container(
                                height: 10,
                              ),


                              Container(
                                height: 40,
                                margin: EdgeInsets.only(top: 10),
                                width: (MediaQuery.of(context).size.width - 32) * 0.85,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                  },
                                  child: Text(
                                    "YES",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                  ),
                                  color: Color(0xFFE61665).withAlpha(46),
                                  textColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              Container(
                                height: 40,
                                margin: EdgeInsets.only(top: 14),
                                width: (MediaQuery.of(context).size.width - 32) * 0.85,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                  },
                                  child: Text(
                                    "NO",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                  ),
                                  color: Color(0xFFE61665).withAlpha(46),
                                  textColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 10),
                                child: Text(
                                  "By the time: 2021-05-30",
                                  style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(right: 10, left: 10, bottom: 16),
                                child: Text(
                                  "https://tokyo2020.org/zh",
                                  style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF4299e1)),
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
                                child: Row(
                                  children: [],
                                ),
                              ),




                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 16),
                      child: Text(
                        "To play a: 10AE",
                        style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                      ),
                    ),
                    Container(
                      height: MediaQueryData.fromWindow(window).padding.bottom + 20,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
