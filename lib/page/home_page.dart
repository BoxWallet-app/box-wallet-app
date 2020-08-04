import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';

import '../main.dart';
import 'aens_register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  var _top = 400.00;
  var _top_y = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _top = 380.00;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
//          floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),
          floatingActionButton: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              onTap: () {
                print("123");
              },
              child: Container(
                child: Image(
                  width: 100,
                  height: 100,
                  image: AssetImage('images/home_search.png'),
                ),
              ),
            ),
          ),

          backgroundColor: Color(0xFFFC2764).withAlpha(220),
//            backgroundColor: Color(0xFFEEEEEE),
          body: Container(
            margin: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
            child: EasyRefresh(
              onRefresh: () {},
              bottomBouncing: false,
              header: TaurusHeader(backgroundColor: Color(0xFFFB156E)),
              child: Container(
                height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        image: AssetImage('images/home_bg.png'),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        left: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 18),
                                      alignment: Alignment.topLeft,
                                      child: Image(
                                        width: 153,
                                        height: 36,
                                        image: AssetImage('images/home_logo.png'),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      onTap: () {
                                        print("123");
                                      },
                                      child: Container(
                                        height: 55,
                                        width: 55,
                                        padding: EdgeInsets.all(15),
                                        child: Image(
                                          width: 36,
                                          height: 36,
                                          image: AssetImage('images/home_settings.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 3,
                                  ),
                                ],
                              ),
//                              Container(
////                  width: 414,
//                                  height: 160,
//                                  alignment: Alignment.centerLeft,
//                                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                                  //边框设置
//                                  decoration: new BoxDecoration(
//                                      color: Color(0xFFFFFFFF),
//                                      //设置四周圆角 角度
//                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//                                      boxShadow: [
//                                        BoxShadow(
//                                            color: Colors.black.withAlpha(30),
//                                            offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                            blurRadius: 15.0, //阴影模糊程度
//                                            spreadRadius: 1.0 //阴影扩散程度
//                                            )
//                                      ]
//                                      //设置四周边框
//                                      ),
//                                  child: Container(
//                                    alignment: Alignment.center,
//                                    padding: const EdgeInsets.only(left: 20, right: 20),
//                                    child: Row(
////                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: <Widget>[
////                                        Container(
////                                          height: 76,
////
////                                          width: 76,
////                                          //边框设置
////                                          decoration: new BoxDecoration(
////                                            color: Colors.blue,
////                                            //设置四周圆角 角度
////                                            borderRadius: BorderRadius.all(Radius.circular(100)),
////                                            //设置四周边框
////                                          ),
////                                        ),
//
//                                        Container(
//                                          height: 120,
//                                          alignment: Alignment.centerLeft,
//                                          width: MediaQuery.of(context).size.width - 40 -40,
//                                          child: Column(
//                                            children: <Widget>[
//                                              Container(
//                                                margin: const EdgeInsets.only(left: 10, top: 5),
//                                                child: Row(
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "我的资产 (AE)",
//                                                      style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
//                                                    ),
//                                                    Text("")
//                                                  ],
//                                                ),
//                                              ),
//                                              Container(
//                                                margin: const EdgeInsets.only(left: 10, top: 4),
//                                                child: Row(
////                                              crossAxisAlignment: CrossAxisAlignment.end,
//                                                  children: <Widget>[
////                            buildTypewriterAnimatedTextKit(),
//                                                    Text(
//                                                      "610.92334",
//                                                      style: TextStyle(
//                                                        fontSize: 35,
//                                                        color: Color(0xff414C57),
////                                                        fontWeight: FontWeight.bold,
//                                                        letterSpacing: -1.0,
//                                                      ),
//                                                    ),
////
////                            Text(
////                              token,
////                              style: TextStyle(fontSize: 35, color: Colors.white),
////                            )
//                                                  ],
//                                                ),
//                                              ),
//                                              Container(
//                                                margin: const EdgeInsets.only(left: 10, top: 5),
//                                                child:  Text(
//                                                  "ak_ idk x6m 3bg Rr7 WiK XuB 8EB YBo RqV saS c6q o4d sd2 3HK gj3 qiC F",
//                                                  style: TextStyle(
//                                                    fontSize: 14,
//                                                    color: Color(0xFF999999),
//                                                  ),
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//
////                                      Column(
////                                        children: <Widget>[
////
////                                        ],
////                                      ),
//                                      ],
//                                    ),
//                                  )),
                              Container(
//                  width: 414,
                                height: 150,
                                alignment: Alignment.centerLeft,
//                                padding: const EdgeInsets.only(top: 10, left: 18, right: 18),

                                child: Column(
                                  children: <Widget>[
//                                    Container(
//                                      margin: const EdgeInsets.only(top: 0, left: 18),
//                                      child: Row(
//                                        children: <Widget>[
//                                          Text(
//                                            "",
//                                            style: TextStyle(fontSize: 13, color: Colors.white70),
//                                          ),
//                                          Text("")
//                                        ],
//                                      ),
//                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 35, left: 18),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                          Container(
                                            child: Text(
                                              "619.29349",
                                              style: TextStyle(fontSize: 35, color: Colors.white),
                                            ),
                                            alignment: Alignment.center,
                                          ),

                                          Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              "  AE",
                                              style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: "Ubuntu"),
                                            ),
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
                                      margin: const EdgeInsets.only(top: 18, left: 18, right: 18),
                                      child: Text(
                                        "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF",
                                        style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.3, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 18, top: 20),
                                child: Text(
                                  "Function",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "Ubuntu"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_send.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Send",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_receive.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Receive",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_aens.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Names",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_game.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Games",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                        top: _top,
                        child: GestureDetector(
                          onPanUpdate: (e) {
//                            setState(() {
//                              print("update");
//                              _top = _top + e.delta.dy;
//                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),

                            width: MediaQuery.of(context).size.width,

                            //边框设置
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                              //设置四周边框
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 18, top: 20),
                                  child: Text(
                                    "最新交易",
                                    style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 18, top: 15),
                                  child: Text(
                                    "确认数",
                                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                  ),
                                  height: 23,
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                ),
                                NotificationListener<ScrollNotification>(
                                  // 添加 NotificationListener 作为父容器
                                  // ignore: missing_return
                                  onNotification: (scrollNotification) {
                                    // 注册通知回调
                                    if (scrollNotification is ScrollStartNotification) {
                                      // 滚动开始
                                    } else if (scrollNotification is ScrollUpdateNotification) {
                                      // 滚动位置更新
                                      ScrollMetrics metrics = scrollNotification.metrics;
                                      _top = 380 - metrics.pixels / 3;
                                      if (_top > MediaQueryData.fromWindow(window).padding.top + 150) setState(() {});
                                      return true;
                                    } else if (scrollNotification is ScrollEndNotification) {
                                      // 滚动结束
                                      ScrollMetrics metrics = scrollNotification.metrics;
                                      _top = 380 - metrics.pixels / 3;
                                      if (_top > MediaQueryData.fromWindow(window).padding.top + 150) setState(() {});
                                    }
                                    return true;
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 18, right: 18),
                                      height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 100 - 100,
                                      child: EasyRefresh(
                                        onRefresh: () {},
                                        header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
                                        child: ListView.builder(
                                          itemCount: 30,
                                          shrinkWrap: true,

                                          padding: const EdgeInsets.only(top: 10, bottom: 50),
//                                    physics: new NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            if (index == 0) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      //边框设置
                                                      decoration: new BoxDecoration(
//                                                  color:Colors.green,
                                                          color: Color(0xFFFB156E),
                                                          //设置四周圆角 角度
                                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color(0xFFFB156E).withAlpha(20),
                                                                offset: Offset(0.0, 3.0), //阴影xy轴偏移量
                                                                blurRadius: 5.0, //阴影模糊程度
                                                                spreadRadius: 1.0 //阴影扩散程度
                                                                )
                                                          ]
                                                          //设置四周边框
                                                          ),

                                                      child: Text(
                                                        "18",
                                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                                      ),
                                                      alignment: Alignment.center,
                                                      height: 23,
                                                      width: 65,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 18),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              "Spend",
                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Ubuntu"),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 8),
                                                            child: Text(
                                                              "th_2HX1PAWSWFJ3eF1YxycdvxPfF7ZrKD6rVT4VxiUfnCBgsCpbKr",
                                                              strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                              style: TextStyle(
                                                                color: Colors.black.withAlpha(80),
                                                                letterSpacing: 1.0,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            width: 250,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 6),
                                                            child: Text(
                                                              "2020-08-03 16:15:05",
                                                              style: TextStyle(color: Colors.black.withAlpha(80), fontSize: 13, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                                            ),
                                                          ),
                                                        ],
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(""),
                                                    ),
//                                            Row(
//                                              children: <Widget>[
//                                                Container(
//                                                  child: Text(
//                                                    "+",
//                                                    style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 18,
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  child: Text(
//                                                    "0.00001AE",
//                                                    style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 18,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
                                                  ],
                                                ),
                                              );
                                            }
                                            if (index == 1) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      //边框设置
                                                      decoration: new BoxDecoration(
//                                                  color:Colors.green,
                                                          color: Color(0xFFFB156E),
                                                          //设置四周圆角 角度
                                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color(0xFFFB156E).withAlpha(20),
                                                                offset: Offset(0.0, 3.0), //阴影xy轴偏移量
                                                                blurRadius: 5.0, //阴影模糊程度
                                                                spreadRadius: 1.0 //阴影扩散程度
                                                                )
                                                          ]
                                                          //设置四周边框
                                                          ),

                                                      child: Text(
                                                        "103",
                                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                                      ),
                                                      alignment: Alignment.center,
                                                      height: 23,
                                                      width: 65,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 18),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              "Update name",
                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Ubuntu"),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 8),
                                                            child: Text(
                                                              "th_2HX1PAWSWFJ3eF1YxycdvxPfF7ZrKD6rVT4VxiUfnCBgsCpbKr",
                                                              strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                              style: TextStyle(
                                                                color: Colors.black.withAlpha(80),
                                                                fontSize: 13,
                                                                letterSpacing: 1.0,
                                                              ),
                                                            ),
                                                            width: 250,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 6),
                                                            child: Text(
                                                              "2020-08-03 16:15:05",
                                                              style: TextStyle(color: Colors.black.withAlpha(80), fontSize: 13, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                                            ),
                                                          ),
                                                        ],
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(""),
                                                    ),
//                                            Row(
//                                              children: <Widget>[
//                                                Container(
//                                                  child: Text(
//                                                    "+",
//                                                    style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 18,
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  child: Text(
//                                                    "0.00001AE",
//                                                    style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 18,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
                                                  ],
                                                ),
                                              );
                                            }
                                            return Container(
                                              margin: EdgeInsets.only(bottom: 20),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    //边框设置
                                                    decoration: new BoxDecoration(
//                                                  color:Colors.green,
                                                        color: Color(0xFFFB156E),
                                                        //设置四周圆角 角度
                                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Color(0xFFFB156E).withAlpha(20),
                                                              offset: Offset(0.0, 3.0), //阴影xy轴偏移量
                                                              blurRadius: 5.0, //阴影模糊程度
                                                              spreadRadius: 1.0 //阴影扩散程度
                                                              )
                                                        ]
                                                        //设置四周边框
                                                        ),

                                                    child: Text(
                                                      "42332",
                                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                                    ),
                                                    alignment: Alignment.center,
                                                    height: 23,
                                                    padding: EdgeInsets.only(left: 8, right: 8),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 18),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Spend",
                                                            style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Ubuntu"),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 8),
                                                          child: Text(
                                                            "th_2HX1PAWSWFJ3eF1YxycdvxPfF7ZrKD6rVT4VxiUfnCBgsCpbKr",
                                                            strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                            style: TextStyle(
                                                              color: Colors.black.withAlpha(80),
                                                              letterSpacing: 1.0,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          width: 250,
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 6),
                                                          child: Text(
                                                            "2020-08-03 16:06:13",
                                                            style: TextStyle(color: Colors.black.withAlpha(80), fontSize: 14, fontFamily: "Ubuntu"),
                                                          ),
                                                        ),
                                                      ],
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(""),
                                                  ),
//                                            Row(
//                                              children: <Widget>[
//                                                Container(
//                                                  child: Text(
//                                                    "+",
//                                                    style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 18,
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  child: Text(
//                                                    "0.00001AE",
//                                                    style: TextStyle(
//                                                      color: Colors.green,
//                                                      fontSize: 18,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
