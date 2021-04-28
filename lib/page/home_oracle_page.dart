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

class HomeOraclePage extends StatefulWidget {
  @override
  _HomeOraclePageState createState() => _HomeOraclePageState();
}

class _HomeOraclePageState extends State<HomeOraclePage> {
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
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "再按一次退出", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            exit(0);
          }
        },

        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xfffafafa),
              // 隐藏阴影
              elevation: 0,
//              leading: IconButton(
//                icon: Icon(
//                  Icons.arrow_back_ios,
//                  size: 17,
//                ),
//                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageV2())),
//              ),
              title: Container(
                  child: Image(
                height: 40,
                image: AssetImage('images/aeternity-logo-cmyk-white-bg-horizontal01.png'),
              )),
              centerTitle: false,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 25,
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPageV2()))),
              ]),
          backgroundColor: Color(0xfffafafa),
          resizeToAvoidBottomInset: false,
          body: EasyRefresh(
            header: AEHeader(),
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                            Color(0xFFE51363),
                            Color(0xFFFF428F),
                          ]),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: 35,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                            color: Color(0xffd12869),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: 40,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 12, left: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Container()),
                                      priceModel == null
                                          ? Container()
                                          : Container(
                                              margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
                                              child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                getAePrice(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                              ),
                                            ),

                                      Container(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: HomePageV2.address));
                          Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20, right: 50),
                          child: Text(Utils.formatHomeCardAddress(HomePageV2.address), style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xffbd2a67), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 87,
                          height: 58,
                          child: Image(
                            image: AssetImage("images/card_top.png"),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 120,
                          height: 46,
                          child: Image(
                            image: AssetImage("images/card_bottom.png"),
                          ),
                        ),
                      ),

                      Container(
                        height: 130,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 18),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    S.of(context).home_page_my_count + " (AE）",
                                    style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    margin: const EdgeInsets.only(left: 2, right: 20),
                                    child: Text(
                                      namesModel == null ? "" : namesModel[0].name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, color: Colors.white70, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 15),
                              child: Row(
                                children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
//                                          Container(
//                                            width: 36.0,
//                                            height: 36.0,
//                                            decoration: BoxDecoration(
//                                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                                              borderRadius: BorderRadius.circular(36.0),
//                                              image: DecorationImage(
//                                                image: AssetImage("images/apple-touch-icon.png"),
////                                                        image: AssetImage("images/apple-touch-icon.png"),
//                                              ),
//                                            ),
//                                          ),
//                                          Container(
//                                            padding: const EdgeInsets.only(left: 8, right: 18),
//                                            child: Text(
//                                              "AE",
//                                              style: new TextStyle(
//                                                fontSize: 20,
//                                                color: Colors.white,
////                                            fontWeight: FontWeight.w600,
//                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                              ),
//                                            ),
//                                          ),
                                  Expanded(child: Container()),

                                  Row(
                                    children: [
//                                              priceModel == null
//                                                  ? Container()
//                                                  : Container(
//                                                margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
//                                                child: Text(
////                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
//                                                  getAePrice(),
//                                                  overflow: TextOverflow.ellipsis,
//                                                  style: TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                                                ),
//                                              ),

                                      Text(
                                        HomePageV2.token == "loading..."
                                            ? "loading..."
                                            : double.parse(HomePageV2.token) > 1000
                                                ? double.parse(HomePageV2.token).toStringAsFixed(2) + ""
                                                : double.parse(HomePageV2.token).toStringAsFixed(5) + "",
//                                      "9999999.00000",
                                        overflow: TextOverflow.ellipsis,

                                        style: TextStyle(fontSize: 38, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),

//                                    Container(
//                                      alignment: Alignment.topLeft,
//                                      margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
//                                      child: Text(
//                                        HomePageV2.address,
//                                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                                        style: TextStyle(fontSize: 13, letterSpacing: 1.0, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.3),
//                                      ),
//                                    ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).home_send_receive,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu",
                            ),
                          ),
                        ),
                        Container(
                          width: 15,
                        ),
                        Container(
                          height: 30,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                            },
                            child: Text(
                                S.of(context).home_page_transaction,
                              maxLines: 1,
                              style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                            ),
                            color: Color(0xFFE61665).withAlpha(16),
                            textColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 90,
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 0),
                          //边框设置
                          decoration: new BoxDecoration(
                            color: Color(0xE6FFFFFF),
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                              },
                              child: Container(
                                height: 90,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Image(
                                              width: 56,
                                              height: 56,
                                              image: AssetImage("images/home_send_token.png"),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Text(
                                                S.of(context).home_page_function_send,
                                                style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
//                                            Positioned(
//                                              right: 23,
//                                              child: Container(
//                                                width: 25,
//                                                height: 25,
//                                                padding: const EdgeInsets.only(left: 0),
//                                                //边框设置
//                                                decoration: new BoxDecoration(
//                                                  color: Color(0xFFF5F5F5),
//                                                  //设置四周圆角 角度
//                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                                                ),
//                                                child: Icon(
//                                                  Icons.arrow_forward_ios,
//                                                  size: 15,
//                                                  color: Color(0xFFCCCCCC),
//                                                ),
//                                              ),
//                                            ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                          height: 90,
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 0),
                          //边框设置
                          decoration: new BoxDecoration(
                            color: Color(0xE6FFFFFF),
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                              },
                              child: Container(
                                height: 90,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Image(
                                              width: 56,
                                              height: 56,
                                              image: AssetImage("images/home_receive_token.png"),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Text(
                                                S.of(context).home_page_function_receive,
                                                style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
//                                            Positioned(
//                                              right: 23,
//                                              child: Container(
//                                                width: 25,
//                                                height: 25,
//                                                padding: const EdgeInsets.only(left: 0),
//                                                //边框设置
//                                                decoration: new BoxDecoration(
//                                                  color: Color(0xFFF5F5F5),
//                                                  //设置四周圆角 角度
//                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                                                ),
//                                                child: Icon(
//                                                  Icons.arrow_forward_ios,
//                                                  size: 15,
//                                                  color: Color(0xFFCCCCCC),
//                                                ),
//                                              ),
//                                            ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "正在进行的Oracles比赛",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : "Ubuntu",
                            ),
                          ),
                        ),
                        Container(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 0),
                    //边框设置
                    decoration: new BoxDecoration(
                      color: Color(0xE6FFFFFF),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                        },
                        child:Column(
                          children: [

                            Container(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  "#1",
                                  style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "2021年东京奥运会获得金牌最多的国家会是？",
                                    style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
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
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(left:10,right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "总押注:10000AE",
                                    style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "单注:10.00AE/次",
                                    style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              margin: EdgeInsets.only(top: 10),
                              width: (MediaQuery.of(context).size.width-32) * 0.95,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                },
                                child: Text(
                                  "中国",
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                color: Color(0xFFE61665).withAlpha(16),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(top: 10),
                              width: (MediaQuery.of(context).size.width-32) * 0.95,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                },
                                child: Text(
                                  "俄罗斯",
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                color: Color(0xFFE61665).withAlpha(16),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(top: 10),
                              width: (MediaQuery.of(context).size.width-32) * 0.95,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                },
                                child: Text(
                                  "美国",
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                color: Color(0xFFE61665).withAlpha(16),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              child: Row(
                                children: [

                                  Expanded(child: Container()),
                                  Text(
                                    "截止时间:2021年07月23日",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 10,left:10,bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text(
                                    "来源:",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color:Colors.black.withAlpha(200)),
                                  ),
                                  Text(
                                    "https://tokyo2020.org/zh/",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF4299e1)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width-32) ,
                              //边框设置
                              decoration: new BoxDecoration(
                                color:Colors.green,
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Row(
                                children: [

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 0),
                    //边框设置
                    decoration: new BoxDecoration(
                      color: Color(0xE6FFFFFF),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                        },
                        child:Column(
                          children: [

                            Container(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  "#2",
                                  style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "05月01日北京地区的天气是否会下雨？",
                                    style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
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
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(left:10,right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "总押注:10AE",
                                    style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "单注:10.00AE/次",
                                    style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 40,
                              margin: EdgeInsets.only(top: 10),
                              width: (MediaQuery.of(context).size.width-32) * 0.95,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                },
                                child: Text(
                                  "会（已投1次）",
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                color: Color(0xFFE61665).withAlpha(16),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(top: 10),
                              width: (MediaQuery.of(context).size.width-32) * 0.95,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                                },
                                child: Text(
                                  "不会",
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
                                ),
                                color: Color(0xFFE61665).withAlpha(16),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              child: Row(
                                children: [

                                  Expanded(child: Container()),
                                  Text(
                                    "截止时间:2021年04月29日",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 10,left:10,bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text(
                                    "来源:",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color:Colors.black.withAlpha(200)),
                                  ),
                                  Text(
                                    "https://tokyo2020.org/zh/",
                                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF4299e1)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width-32) ,
                              //边框设置
                              decoration: new BoxDecoration(
                                color:Colors.green,
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Row(
                                children: [

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQueryData.fromWindow(window).padding.bottom+20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
