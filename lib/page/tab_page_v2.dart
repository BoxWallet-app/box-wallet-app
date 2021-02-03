import 'dart:async';
import 'dart:ui';

import 'package:box/page/aepps_page_v2.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/setting_page_v2.dart';
import 'package:box/page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class TabPageV2 extends StatefulWidget {
  @override
  _TabPageV2State createState() => _TabPageV2State();
}

class _TabPageV2State extends State<TabPageV2> with TickerProviderStateMixin {
  AnimationController _title1Controller;
  AnimationController _title2Controller;
  AnimationController _title3Controller;

  final StreamController<int> _streamController1 = StreamController<int>();
  final StreamController<int> _streamController2 = StreamController<int>();
  final StreamController<int> _streamController3 = StreamController<int>();
  final StreamController<double> _streamControllerLine = StreamController<double>();

  PageController pageControllerBody = PageController();
  PageController pageControllerTitle = PageController();

  // ignore: close_sinks
  final StreamController<String> _streamControllerTitle = StreamController<String>();

  @override
  void dispose() {
    super.dispose();
    _title1Controller.dispose();
    _title2Controller.dispose();
    _title3Controller.dispose();

    _streamController1.close();
    _streamController2.close();
    _streamController3.close();
    _streamControllerLine.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title1Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title1Controller.forward();

    _title2Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title2Controller.reverse();

    _title3Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title3Controller.reverse();

    _streamControllerTitle.sink.add("One");
    pageControllerBody.addListener(() {
//      var offset = pageControllerBody.offset;
//      print(offset / (MediaQuery.of(context).size.width / 2));

//      pageControllerTitle.jumpTo(offset / 2);
      //  屏幕  / 4 * 3 + 屏幕  / 4 / 3
      //      print(pageController.offset);
      //MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3))

      if (pageControllerBody.offset < 0 || pageControllerBody.offset > MediaQuery.of(context).size.width + MediaQuery.of(context).size.width) {
        return;
      }
      pageControllerTitle.jumpTo(pageControllerBody.offset / 3);

      double zoom = (156) / (MediaQuery.of(context).size.width);
      double offset = (pageControllerBody.offset * zoom);
      _streamControllerLine.sink.add(pageControllerBody.offset / 3);
    if(pageControllerBody.page <0.5){
      _streamController1.sink.add(0xFFFC2365);
      _streamController2.sink.add(-1);
      _streamController3.sink.add(-1);
    }
    if(pageControllerBody.page>0.6&& pageControllerBody.page<1.5){
      _streamController1.sink.add(-1);
      _streamController2.sink.add(0xFFFC2365);
      _streamController3.sink.add(-1);
    }

    if(pageControllerBody.page>1.5){
      _streamController1.sink.add(-1);
      _streamController2.sink.add(-1);
      _streamController3.sink.add(0xFFFC2365);
    }


//      _streamControllerLine.sink.add(offset/156);

//      pageControllerTitle.offset = 10;
//      if (pageControllerBody.page == 0) {
//        _title1Controller.forward();
//        _title2Controller.reverse();
//        _title3Controller.reverse();
//      }
//      if (pageControllerBody.page == 1) {
//        _title1Controller.reverse();
//        _title2Controller.forward();
//        _title3Controller.reverse();
//      }
//      if (pageControllerBody.page == 2) {
//        _title1Controller.reverse();
//        _title2Controller.reverse();
//        _title3Controller.forward();
//      }
    });
    _streamController1.sink.add(0xFFFC2365);
    _streamController2.sink.add(-1);
    _streamController3.sink.add(-1);
    _streamControllerLine.sink.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            children: [
              Container(
                height: MediaQueryData.fromWindow(window).padding.top,
              ),
              Container(
//              color: Colors.blue,
                width: MediaQuery.of(context).size.width,
                height: 52,
                child: Stack(
                  children: [
                    Positioned(
                      height: 52,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Container(
                        child: Container(
                          decoration: new BoxDecoration(
                            //背景
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: PageView.builder(
                            itemCount: 3,
                            controller: pageControllerTitle,
                            physics: NeverScrollableScrollPhysics(),
                            allowImplicitScrolling: true,
                            pageSnapping: false,
                            itemBuilder: (context, position) {
                              if (position == 0) {
                                return Container(
                                  height: 52,
                                  margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Wallet",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      fontFamily: BoxApp.language == "cn"
                                          ? "Ubuntu"
                                          : BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu",
                                    ),
                                  ),
                                );
                              } else if (position == 1) {
                                return Container(
                                  height: 52,
                                  margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Discover",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      fontFamily: BoxApp.language == "cn"
                                          ? "Ubuntu"
                                          : BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu",
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 52,
                                  margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Settings",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      fontFamily: BoxApp.language == "cn"
                                          ? "Ubuntu"
                                          : BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 52,
                        ),
                      ),
                    ),
//                    Positioned(
//                        right: 0,
//                        child: Container(
//                          color: Colors.green,
//                          height: 52,
//                          width: 156,
//                          child: Stack(
//                            children: [
//                              Row(
//                                children: [
//                                  Material(
//                                    child: InkWell(
//                                      onTap: () {
//                                        pageControllerBody.animateToPage(0, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
//                                      },
//                                      borderRadius: BorderRadius.all(Radius.circular(60)),
//                                      child: StreamBuilder<Object>(
//                                          stream: _streamController1.stream,
//                                          builder: (context, snapshot) {
//                                            return Container(
//                                              width: 52,
//                                              padding: EdgeInsets.all(12),
//                                              height: 52,
//                                              child: Image(
//                                                width: 30,
//                                                color: Colors.black,
//                                                height: 30,
//                                                image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_home_p.png") : AssetImage("images/tab_home.png"),
//                                              ),
//                                            );
//                                          }),
//                                    ),
//                                  ),
//                                  Material(
//                                    child: InkWell(
//                                      onTap: () {
//                                        pageControllerBody.animateToPage(1, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
//                                      },
//                                      borderRadius: BorderRadius.all(Radius.circular(60)),
//                                      child: StreamBuilder<Object>(
//                                          stream: _streamController2.stream,
//                                          builder: (context, snapshot) {
//                                            return Container(
//                                              width: 52,
//                                              padding: EdgeInsets.all(12),
//                                              height: 52,
//                                              child: Image(
//                                                width: 30,
//                                                height: 30,
//                                                color: Colors.black,
//                                                image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_swap.png.png") : AssetImage("images/tab_swap.png"),
//                                              ),
//                                            );
//                                          }),
//                                    ),
//                                  ),
//                                  Material(
//                                    child: InkWell(
//                                      onTap: () {
//                                        pageControllerBody.animateToPage(2, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
//                                      },
//                                      borderRadius: BorderRadius.all(Radius.circular(60)),
//                                      child: StreamBuilder<Object>(
//                                          stream: _streamController3.stream,
//                                          builder: (context, snapshot) {
//                                            return Container(
//                                              width: 52,
//                                              padding: EdgeInsets.all(12),
//                                              height: 52,
//                                              child: Image(
//                                                width: 30,
//                                                height: 30,
//                                                color: Colors.black,
//                                                image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_app.png.png") : AssetImage("images/tab_app.png"),
//                                              ),
//                                            );
//                                          }),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              StreamBuilder<double>(
//                                  stream: _streamControllerLine.stream,
//                                  builder: (context, snapshot) {
//                                    return Positioned(
//                                        bottom: 6,
//                                        left: snapshot.data,
//                                        child: Container(
//                                          height: 3,
//                                          margin: EdgeInsets.only(left: 18.5, right: 18.5),
//                                          width: 15,
//                                          //边框设置
//                                          decoration: new BoxDecoration(
//                                            //背景
//                                            color: Color(0xFFf7296e),
//                                            //设置四周圆角 角度
//                                            borderRadius: BorderRadius.all(Radius.circular(25)),
//                                          ),
//                                        ));
//                                  })
//                            ],
//                          ),
//                        ))
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - MediaQueryData.fromWindow(window).padding.bottom - 52 - 52,
                child: PageView.builder(
                  itemCount: 3,
                  controller: pageControllerBody,
                  itemBuilder: (context, position) {
                    if (position == 0) {
                      return HomePageV2();
                    } else if (position == 1) {
                      return AeppsPageV2();
                    } else {
                      return SettingPageV2();
                    }
                  },
                ),
              ),
//              Container(
//                width: MediaQuery.of(context).size.width,
//                height: 1,
//                color: Color(0xffeeeeee),
//              ),
              Container(
                color: Colors.green,
                height: 52,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              pageControllerBody.animateToPage(0, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
                            },
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            child: StreamBuilder<Object>(
                                stream: _streamController1.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.all(12),
                                    height: 52,
                                    child: Image(
                                      width: 30,
                                      height: 30,
                                      image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_home_p.png") : AssetImage("images/tab_home.png"),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              pageControllerBody.animateToPage(1, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
                            },
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            child: StreamBuilder<Object>(
                                stream: _streamController2.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.all(12),
                                    height: 52,
                                    child: Image(
                                      width: 30,
                                      height: 30,
                                      image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_swap_p.png") : AssetImage("images/tab_swap.png"),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              pageControllerBody.animateToPage(2, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
                            },
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            child: StreamBuilder<Object>(
                                stream: _streamController3.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    padding: EdgeInsets.all(12),
                                    height: 52,
                                    child: Image(
                                      width: 30,
                                      height: 30,
                                      image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_app_p.png") : AssetImage("images/tab_app.png"),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<double>(
                        stream: _streamControllerLine.stream,
                        builder: (context, snapshot) {
                          return Positioned(
                              top: 2,
                              left: snapshot.data,
                              child: Container(
                                height: 3,
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3 / 3, right: MediaQuery.of(context).size.width / 3 / 3),
                                width: MediaQuery.of(context).size.width / 3 - MediaQuery.of(context).size.width / 3 / 3 - MediaQuery.of(context).size.width / 3 / 3,
                                //边框设置
                                decoration: new BoxDecoration(
                                  //背景
                                  color: Color(0xFFf7296e),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                ),
                              ));
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
