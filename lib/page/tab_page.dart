import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:box/dao/node_test_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/aepp_page.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/swap_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../main.dart';
import 'node_page.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  AnimationController _tabController;
  AnimationController _title3Controller;
  AnimationController _title2Controller;
  AnimationController _title1Controller;
  Animation<Offset> _tabOffsetAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  int badge = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 3);
  double gap = 10;
  final StreamController<double> _tabBgController = StreamController<double>();
  final StreamController<int> _streamController = StreamController<int>();
  final StreamController<int> _streamController2 = StreamController<int>();
  final StreamController<int> _streamController3 = StreamController<int>();
  PageController pageController = PageController();

  List<Color> colors = [
    Colors.purple,
    Colors.pink,
  ];
  var isNodeTest = true;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _title2Controller.dispose();
    _title3Controller.dispose();
    _title1Controller.dispose();
    _streamController.close();
    _streamController2.close();
    _streamController3.close();
  }

  @override
  void initState() {
    super.initState();
    _streamController.sink.add(0xFFFC2365);
    _streamController2.sink.add(0xFF666666);
    _streamController3.sink.add(0xFF666666);
    //初始化
    //用来控制动画的开始与结束以及设置动画的监听
    //vsync参数，存在vsync时会防止屏幕外动画（动画的UI不在当前屏幕时）消耗不必要的资源
    //duration 动画的时长，这里设置的 seconds: 2 为2秒，当然也可以设置毫秒 milliseconds：2000.
    _tabController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title1Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title2Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title3Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    _tabController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //AnimationStatus.completed 动画在结束时停止的状态
        //ontroller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //AnimationStatus.dismissed 表示动画在开始时就停止的状态
        //controller.forward();
      }
    });
    //begin: Offset.zero, end: Offset(1, 0) 以左下角为参考点，相对于左下角坐标 x轴方向向右 平移执行动画的view 的1倍 宽度，y轴方向不动，也就是水平向右平移
    //begin: Offset.zero, end: Offset(1, 1) 以左下角为参考点，相对于左下角坐标 x轴方向向右 平移执行动画的view 的1倍 宽度，y轴方向 向下 平衡执行动画view 的1倍的高度，也就是向右下角平移了
    _tabOffsetAnimation = Tween(begin: Offset.zero, end: Offset(0, 0)).animate(_tabController);

//    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0.0),).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn,));
    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);

    pageController.addListener(() {});
    double gap = 10;
    _tabController.reverse();
    _title3Controller.reverse();
    _title1Controller.forward();

    Timer.periodic(Duration(seconds: 15), (timer) {
      netTestNode();
      // 每隔 1 秒钟会调用一次，如果要结束调用
    });

    netTestNode();
  }

  Future<void> getAddress() async {
    HomePage.address = await BoxApp.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      extendBody: true,
      drawer: Drawer(
        child: SettingsPage(),
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<Object>(
          future: getAddress(),
          builder: (context, snapshot) {
            return Container(
              child: Stack(
                children: [
                  PageView.builder(
                    allowImplicitScrolling: true,
                    onPageChanged: (page) {
                      if (page == 0) {
                        _tabOffsetAnimation = Tween(begin: Offset.zero, end: Offset(page.toDouble(), 0)).animate(_tabController);
                        _tabBgController.sink.add(0);
                        _tabController.forward();

                        _title2Controller.reverse();
                        _title3Controller.reverse();
                        _title1Controller.forward();
                        _streamController.sink.add(0xFFFC2365);
                        _streamController2.sink.add(0xFF666666);
                        _streamController3.sink.add(0xFF666666);
                      } else if (page == 1) {
                        _tabOffsetAnimation = Tween(begin: Offset.zero, end: Offset(page.toDouble(), 0)).animate(_tabController);

                        _tabBgController.sink.add(MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3));

                        _tabController.forward();
                        _title2Controller.forward();
                        _title1Controller.reverse();
                        _title3Controller.reverse();

                        _streamController.sink.add(0xFF666666);
                        _streamController2.sink.add(0xFFFC2365);
                        _streamController3.sink.add(0xFF666666);

//                  _tabColor2Controller.reverse();
                      } else {
                        _tabOffsetAnimation = Tween(begin: Offset.zero, end: Offset(page.toDouble(), 0)).animate(_tabController);
                        _tabBgController.sink.add((MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3)) * 2);

                        _tabController.forward();
//                        _tabController.reverse();
                        _title2Controller.reverse();
                        _title3Controller.forward();
                        _title1Controller.reverse();

                        _streamController2.sink.add(0xFF666666);
                        _streamController.sink.add(0xFF666666);
                        _streamController3.sink.add(0xFFFC2365);
                      }
                      selectedIndex = page;
                      badge = badge + 1;
                      // 延时1s执行返回
                      Future.delayed(Duration(milliseconds: 600), () {
//                  setState(() {
//                    selectedIndex = page;
//                  });
                      });
//
//          setState(() {
//
//          });
                    },

                    controller: pageController,
                    itemBuilder: (context, position) {
                      if (position == 0) {
                        return HomePage();
                      } else if (position == 1) {
                        return SwapPage();
                      } else {
                        return AeppPage();
                      }
                    },
                    itemCount: 3, // Can be null
                  ),
                  Positioned(
                    child: Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Color(0xFFF5F5F5),
                              height: MediaQueryData.fromWindow(window).padding.top,
                            ),
                            Container(
                              color: Color(0xFFF5F5F5),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 4.5,
                                    child: FadeTransition(
                                      opacity: _title1Controller,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                          onTap: () {
                                            if (selectedIndex != 0) {
                                              return;
                                            }
                                            _scaffoldKey.currentState.openDrawer();
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) => SettingsPage()));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12.5),
                                            width: 55,
                                            height: 55,
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: new BoxDecoration(
                                                  border: new Border.all(color: Color(0xFFe0e0e0), width: 0.5),
                                                color: Color(0xFFFFFFFF), // 底色
                                                borderRadius: new BorderRadius.all(Radius.circular(50)), // 也可控件一边圆角大小
                                              ),
                                              child: ClipOval(
                                                child: Image.network(
                                                  "https://www.gravatar.com/avatar/" + Utils.generateMD5(HomePage.address) + "?s=100&d=robohash&r=PG",
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: FadeTransition(
                                      opacity: _title1Controller,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 55,
                                        alignment: Alignment.topLeft,
                                        child: Center(
                                          child: Text(
                                            S.of(context).tab_1,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              fontFamily: "Ubuntu",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: FadeTransition(
                                      opacity: _title2Controller,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 55,
                                        alignment: Alignment.topLeft,
                                        child: Center(
                                          child: Text(
                                            S.of(context).swap_title,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Ubuntu",
                                            ),
                                          ),
                                        ),
//                                child: Center(
//                                  child: Image(
//                                    width: 153,
//                                    height: 36,
//                                    image: AssetImage('images/home_logo_left.png'),
//                                  ),
//                                ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: FadeTransition(
                                      opacity: _title3Controller,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 55,
                                        alignment: Alignment.topLeft,
                                        child: Center(
                                          child: Text(
                                            S.of(context).tab_3,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Ubuntu",
                                            ),
                                          ),
                                        ),
                                      ),
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
                ],
              ),
            );
          }),
      // backgroundColor: Colors.green,
      // body: Container(color: Colors.red,),
      bottomNavigationBar: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container()),
            isNodeTest
                ? Container()
                : Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NodePage()));
                      },
                      child: Container(
                        height: 45,
                        width: 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, color: Colors.white),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                S.of(context).tab_node_error,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Ubuntu",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            Container(
              height: 20,
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width / 4 * 3 + (MediaQuery.of(context).size.width / 4 / 3),
              decoration: BoxDecoration(color: Color(0xFFEEEEEE), borderRadius: BorderRadius.all(Radius.circular(100)), boxShadow: [BoxShadow(spreadRadius: -10, blurRadius: 60, color: Colors.black.withOpacity(.4), offset: Offset(0, 25))]),
              child: Stack(
                children: [
                  StreamBuilder<double>(
                      stream: _tabBgController.stream,
                      builder: (context, snapshot) {
                        return Positioned(
                          top: 0,
                          left: snapshot.data == null ? 0 : snapshot.data,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4 - 6 + (MediaQuery.of(context).size.width / 4 / 3 / 3),
                              height: 49,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
                            ),
                          ),
                        );
                      }),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4 - 6 + (MediaQuery.of(context).size.width / 4 / 3 / 3),
                        height: 49,
//                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(100))),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100), topRight: Radius.circular(100), bottomRight: Radius.circular(100)),
                        onTap: () {
                          pageController.animateToPage(0, duration: new Duration(milliseconds: 500), curve: new ElasticOutCurve(4));
                        },
                        child: StreamBuilder<Object>(
                            stream: _streamController.stream,
                            builder: (context, snapshot) {
                              return Container(
                                width: MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3),
                                height: 55,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Image(
                                        width: 30,
                                        height: 30,
                                        image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_home_p.png") : AssetImage("images/tab_home.png"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 6),
                                      child: Text(
                                        S.of(context).tab_1,
                                        style: TextStyle(
//                                    color: colorsAnimation1.value,
                                          color: snapshot != null ? Color(snapshot.data) : Color(0x666666),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Ubuntu",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100), topRight: Radius.circular(100), bottomRight: Radius.circular(100)),
                        onTap: () {
                          pageController.animateToPage(1, duration: new Duration(milliseconds: 500), curve: new ElasticOutCurve(4));
                        },
                        child: StreamBuilder<int>(
                            stream: _streamController2.stream,
                            builder: (context, snapshot) {
                              return Container(
                                width: MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3),
                                height: 55,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Image(
                                        width: 30,
                                        height: 30,
                                        image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_swap_p.png") : AssetImage("images/tab_swap.png"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 6),
                                      child: Text(
                                        S.of(context).tab_2,
                                        style: TextStyle(
//                                    color: colorsAnimation2.value,
                                          color: snapshot != null ? Color(snapshot.data) : Color(0x666666),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Ubuntu",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100), topRight: Radius.circular(100), bottomRight: Radius.circular(100)),
                        onTap: () {
                          pageController.animateToPage(2, duration: new Duration(milliseconds: 500), curve: new ElasticOutCurve(4));
                        },
                        child: StreamBuilder<int>(
                            stream: _streamController3.stream,
                            builder: (context, snapshot) {
                              return Container(
                                width: MediaQuery.of(context).size.width / 4 + (MediaQuery.of(context).size.width / 4 / 3 / 3),
                                height: 55,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Image(
                                        width: 30,
                                        height: 30,
                                        image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_app_p.png") : AssetImage("images/tab_app.png"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 6),
                                      child: Text(
                                        S.of(context).tab_3,
                                        style: TextStyle(
//                                    color: colorsAnimation2.value,
                                          color: snapshot != null ? Color(snapshot.data) : Color(0x666666),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Ubuntu",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  netTestNode() {
    BoxApp.getNodeUrl().then((nodeUrl) {
      BoxApp.getCompilerUrl().then((compilerUrl) {
        NodeTestDao.fetch(nodeUrl, compilerUrl).then((isSucess) {
          if (isNodeTest == isSucess) {
            return;
          }
          isNodeTest = isSucess;
          setState(() {});
        }).catchError((e) {
          if (e.toString().contains("SocketException")) {
          } else {
            isNodeTest = false;
            setState(() {});
          }
        });
      });
    });
  }
}
