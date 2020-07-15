import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/aens_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("123->" + MediaQueryData
        .fromWindow(window)
        .padding
        .top
        .toString());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: Container(
//              onRefresh: () {},
//              header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    EasyRefresh(
                      topBouncing: false,
                      bottomBouncing: false,
                      header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 270,
                                  color: Color(0xFFE71766),
                                ),
                                Container(
                                  decoration: new BoxDecoration(
                                    gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                      Color(0xFFE71766),
                                      Color(0xFFFFFFFF),
                                    ]),
                                  ),
                                  height: 120,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Container(
                              margin: EdgeInsets.only(top: MediaQueryData
                                  .fromWindow(window)
                                  .padding
                                  .top),
                              child: Column(
                                children: <Widget>[
                                  //价格-高度
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 40,
                                    margin: const EdgeInsets.only(top: 210, left: 20, right: 20),
                                    height: 100,
                                    //边框设置
                                    decoration: new BoxDecoration(
                                        color: Color(0x88FFFFFF),
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                                              blurRadius: 15.0, //阴影模糊程度
                                              spreadRadius: 1.0 //阴影扩散程度
                                          )
                                        ]
                                      //设置四周边框
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: const EdgeInsets.only(top: 20, left: 20),
                                                child: Text(
                                                  "最新价格(USDT)",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    wordSpacing: 30.0, //词间距
                                                    color: Color(0xFF666666),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: const EdgeInsets.only(top: 5, left: 20),
                                                child: Text(
                                                  "0.2134 ",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    letterSpacing: -1,
                                                    //字体间距
                                                    fontWeight: FontWeight.bold,

                                                    //词间距
                                                    color: Color(0xFF000000),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: const EdgeInsets.only(top: 20, left: 20),
                                                child: Text(
                                                  "最后区块高度",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    wordSpacing: 30.0, //词间距
                                                    color: Color(0xFF666666),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: const EdgeInsets.only(top: 5, left: 20),
                                                child: Text(
                                                  "284236",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    letterSpacing: -1,
                                                    //字体间距
                                                    fontWeight: FontWeight.bold,

                                                    //词间距
                                                    color: Color(0xFF000000),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        //知道
                                        Container(
                                          margin: const EdgeInsets.only(top: 20, left: 20),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width - 20,
                                          child: Text(
                                            "知道",
                                            style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: -1,
                                              //字体间距
                                              fontWeight: FontWeight.bold,
                                              //词间距
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5, left: 15, right: 20),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    onTap: () {
                                                      print("123");
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 6),
                                                          width: 55,
                                                          height: 55,
                                                          child: Image(
                                                            image: AssetImage("images/main_know_icon_1.png"),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 0, left: 5),
                                                                child: Text(
                                                                  "钱包排行榜",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF000000),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 2, left: 5),
                                                                child: Text(
                                                                  "看看谁才是庄家",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    //词间距
                                                                    color: Color(0xFF666666),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    onTap: () {
                                                      print("123");
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 6),
                                                          width: 55,
                                                          height: 55,
                                                          child: Image(
                                                            image: AssetImage("images/main_know_icon_2.png"),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 0, left: 5),
                                                                child: Text(
                                                                  "挖矿曲线",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF000000),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 2, left: 5),
                                                                child: Text(
                                                                  "多劳多得 共同富裕",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    //词间距
                                                                    color: Color(0xFF666666),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5, left: 15, right: 20),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    onTap: () {
                                                      print("123");
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 6),
                                                          width: 55,
                                                          height: 55,
                                                          child: Image(
                                                            image: AssetImage("images/main_know_icon_3.png"),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 0, left: 5),
                                                                child: Text(
                                                                  "实时算力",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF000000),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 2, left: 5),
                                                                child: Text(
                                                                  "哪位大佬在挖矿",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    //词间距
                                                                    color: Color(0xFF666666),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    onTap: () {
                                                      print("123");
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 6),
                                                          width: 55,
                                                          height: 55,
                                                          child: Image(
                                                            image: AssetImage("images/main_know_icon_1.png"),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 0, left: 5),
                                                                child: Text(
                                                                  "链上消息",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF000000),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 2, left: 5),
                                                                child: Text(
                                                                  "查看最新交易信息",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    //词间距
                                                                    color: Color(0xFF666666),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(margin: const EdgeInsets.only(top: 15), height: 1.0, width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 30, color: Color(0xFFF5F5F5)),

                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        //知道
                                        Container(
                                          margin: const EdgeInsets.only(top: 15, left: 20),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width - 20,
                                          child: Text(
                                            "域名",
                                            style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: -1,
                                              //字体间距
                                              fontWeight: FontWeight.bold,
                                              //词间距
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width - 40,
                                          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                                          height: 80,
                                          //边框设置
                                          decoration: new BoxDecoration(
                                            color: Color(0xFFF8F8F8),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                      boxShadow: [
//                                        BoxShadow(
//                                            color: Colors.black12,
//                                            offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                            blurRadius: 15.0, //阴影模糊程度
//                                            spreadRadius: 1.0 //阴影扩散程度
//                                        )
//                                      ]
                                            //设置四周边框
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: const EdgeInsets.only(top: 20, left: 20),
                                                      child: Text(
                                                        "域名数量",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          wordSpacing: 30.0, //词间距
                                                          color: Color(0xFF666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: const EdgeInsets.only(top: 5, left: 20),
                                                      child: Text(
                                                        "1593个",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: -1,
                                                          //字体间距
                                                          fontWeight: FontWeight.bold,

                                                          //词间距
                                                          color: Color(0xFF000000),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: const EdgeInsets.only(top: 20, left: 20),
                                                      child: Text(
                                                        "燃烧(ae)",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          wordSpacing: 30.0, //词间距
                                                          color: Color(0xFF666666),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      margin: const EdgeInsets.only(top: 5, left: 20),
                                                      child: Text(
                                                        "102932",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          letterSpacing: -1,
                                                          //字体间距
                                                          fontWeight: FontWeight.bold,

                                                          //词间距
                                                          color: Color(0xFF000000),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(left: 50, right: 30),
                                                child: ArgonButton(
                                                  height: 30,
                                                  roundLoadingShape: true,
                                                  width: 66,
                                                  onTap: (startLoading, stopLoading, btnState) {},
                                                  child: Text(
                                                    "去注册",
                                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                                                  ),
                                                  loader: Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: SpinKitRing(
                                                      lineWidth: 4,
                                                      color: Colors.white,
                                                      // size: loaderWidth ,
                                                    ),
                                                  ),
                                                  borderRadius: 30.0,
                                                  color: Color(0xFFE71766),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          height: 80,
                                          //边框设置
                                          decoration: new BoxDecoration(
                                            color: Color(0xFFF8F8F8),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                                      boxShadow: [
//                                        BoxShadow(
//                                            color: Colors.black12,
//                                            offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                            blurRadius: 15.0, //阴影模糊程度
//                                            spreadRadius: 1.0 //阴影扩散程度
//                                        )
//                                      ]
                                            //设置四周边框
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.center,
                                                      margin: const EdgeInsets.only(top: 20),
                                                      child: Text(
                                                        "当前节点:http://www.aechina.com",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(0xFFCCCCCC),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      margin: const EdgeInsets.only(top: 5),
                                                      child: Text(
                                                        "该服务由 aeasy.io 提供技术支持",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(0xFFCCCCCC),
                                                        ),
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      child: //搜索
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        height: 40,
                        margin:  EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top+20, left: 20, right: 20),
                        //边框设置
                        decoration: new BoxDecoration(
                            color: Color(0xE6FFFFFF),
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                                  blurRadius: 15.0, //阴影模糊程度
                                  spreadRadius: 1.0 //阴影扩散程度
                              )
                            ]
                          //设置四周边框
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              child: Icon(Icons.search),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(right: 18),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 40 - 40 - 40,
                              child: TextField(
                                controller: _textEditingController,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "搜索地址、区块、记录、哈希...",
                                  focusedBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0x00000000)),
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                cursorColor: Color(0xFFE71766),
                                cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
class AppBarSearch extends StatefulWidget implements PreferredSizeWidget {
  AppBarSearch({@required this.child}) : assert(child != null);
  final Widget child;

  @override
  Size get preferredSize {
    return new Size.fromHeight(56.0);
  }

  @override
  State createState() {
    return _AppBarSearchState();
  }
}

class _AppBarSearchState extends State<AppBarSearch> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: widget.child,
    );
  }
}
