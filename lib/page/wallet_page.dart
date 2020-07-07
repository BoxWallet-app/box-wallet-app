import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:box/dao/account_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/main.dart';
import 'package:box/model/account_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with AutomaticKeepAliveClientMixin  {
  String token = "-";

  @override
  void initState() {
    super.initState();
    netAccountInfo();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {

      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // 隐藏阴影

          title: Text(
            '钱包',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: EasyRefresh(
          onRefresh: _onRefresh,
          header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 414,
                  height: 200,
                  alignment: Alignment.centerLeft,
//                  margin: const EdgeInsets.only(left: 18, right: 18),
                  padding: const EdgeInsets.only(top: 10, left: 18, right: 18),
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/wallet_card.png"),
                      fit: BoxFit.fitWidth,
                    ),
//                    color: Color(0xFFE71766),
                    //设置四周圆角 角度
//                    borderRadius: BorderRadius.all(Radius.circular(8.0)),

                    //设置四周边框
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 28, left: 18),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "我的资产 (AE)",
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                            Text("")
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                            Text(
                              token,
                              style: TextStyle(fontSize: 35, color: Colors.white),
                            ),
//
//                            Text(
//                              token,
//                              style: TextStyle(fontSize: 35, color: Colors.white),
//                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 18, right: 18),
                        child: Text(
                          BoxApp.getAddress(),
                          style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                buildItem(context, "发送币", "images/profile_display_currency.png", () {
                  print("123");
                }),
                buildItem(context, "接收币", "images/profile_account_permissions.png", () {
                  print("123");
                }),
                buildItem(context, "转账记录", "images/profile_lanuge.png", () {
                  print("123");
                }),
                buildItem(context, "扫一扫", "images/profile_info.png", () {
                  print("123");
                }),
              ],
            ),
          ),
        ));
  }

  Widget buildTypewriterAnimatedTextKit() {
    List<String> text = new List();
    text.add(token);
//    if (token == "-") {
//      return Text(
//        token,
//        style: TextStyle(fontSize: 35, color: Colors.white),
//      );
//    } else {
//      return TypewriterAnimatedTextKit(
//          totalRepeatCount: 1,
//          speed: Duration(milliseconds: 300),
//          onTap: () {
//            print("Tap Event22");
//          },
//          text:text,
//          textStyle: TextStyle(fontSize: 35, color: Colors.white),
//          textAlign: TextAlign.start,
//          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
//          );
//    }
    return TypewriterAnimatedTextKit(
        totalRepeatCount: 1,
        speed: Duration(milliseconds: 300),
        onTap: () {
          print("Tap Event22");
        },
        text: text,
        textStyle: TextStyle(fontSize: 35, color: Colors.white),
        textAlign: TextAlign.start,
        alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        );
  }

  Material buildItem(BuildContext context, String content, String assetImage, GestureTapCallback tab, {bool isLine = true}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 13),
                child: Row(
                  children: <Widget>[
                    Image(
                      width: 40,
                      height: 40,
                      image: AssetImage(assetImage),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 28,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              if (isLine)
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      netAccountInfo();
    });
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        print(model.data.balance);
        token = model.data.balance;
        setState(() {

        });
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
