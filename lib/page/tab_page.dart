import 'dart:async';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/swap_page.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  AnimationController _tabController;
  AnimationController _title2Controller;
  AnimationController _title1Controller;
  Animation<Offset> _tabOffsetAnimation;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  int badge = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 3);
  double gap = 10;
  final StreamController<int> _streamController = StreamController<int>();
  final StreamController<int> _streamController2 = StreamController<int>();
  PageController pageController = PageController();

  List<Color> colors = [
    Colors.purple,
    Colors.pink,
  ];

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _title2Controller.dispose();
    _title1Controller.dispose();
    _streamController.close();
    _streamController2.close();
  }

  @override
  void initState() {
    super.initState();
    //初始化
    //用来控制动画的开始与结束以及设置动画的监听
    //vsync参数，存在vsync时会防止屏幕外动画（动画的UI不在当前屏幕时）消耗不必要的资源
    //duration 动画的时长，这里设置的 seconds: 2 为2秒，当然也可以设置毫秒 milliseconds：2000.
    _tabController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title1Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _title2Controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
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
    _tabOffsetAnimation = Tween(begin: Offset.zero, end: Offset(1, 0)).animate(_tabController);


//    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0.0),).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn,));
    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);

    pageController.addListener(() {});
    double gap = 10;
    _tabController.reverse();
    _title2Controller.reverse();
    _title1Controller.forward();
    _streamController.sink.add(0xFFFC2365);
    _streamController2.sink.add(0xFF000000);
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
      body: Container(
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (page) {
                if (page == 1) {
                  _tabController.forward();
                  _title2Controller.forward();
                  _title1Controller.reverse();

                  _streamController.sink.add(0xFF000000);
                  _streamController2.sink.add(0xFFFC2365);
//                  _tabColor2Controller.forward();

                } else {
                  _tabController.reverse();
                  _title2Controller.reverse();
                  _title1Controller.forward();
                  _streamController.sink.add(0xFFFC2365);
                  _streamController2.sink.add(0xFF000000);
//                  _tabColor2Controller.reverse();
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
                return position == 0 ? HomePage() : SwapPage();
              },
              itemCount: 2, // Can be null
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
                              left: 8,
                              child: FadeTransition(
                                opacity: _title1Controller,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    onTap: () {
                                      if(selectedIndex !=0){
                                        return;
                                      }
                                      _scaffoldKey.currentState.openDrawer();
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) => SettingsPage()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          child: SvgPicture.asset(
                                            'images/avatar_1.svg',
                                            width: 36,
                                            height: 36,
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
                                      "Box æpp",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 24,
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
                                opacity: _title2Controller,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 55,
                                  alignment: Alignment.topLeft,
                                  child: Center(
                                    child: Text(
                                      "Swap",
                                      style: TextStyle(

                                        fontSize: 24,
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
      ),
      // backgroundColor: Colors.green,
      // body: Container(color: Colors.red,),
      bottomNavigationBar: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              height: 55,
              width: 252,
//              margin: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
              decoration: BoxDecoration(color: Color(0xFFEEEEEE), borderRadius: BorderRadius.all(Radius.circular(100)), boxShadow: [BoxShadow(spreadRadius: -10, blurRadius: 60, color: Colors.black.withOpacity(.4), offset: Offset(0, 25))]),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SlideTransition(
                      position: _tabOffsetAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 120,
                          height: 49,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: 120,
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
                        child: Container(
//                    color: Colors.amber,
                          width: 126,
                          height: 55,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Image(
                                  width: 34,
                                  height: 34,
                                  image: AssetImage("images/tab_home.png"),
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: _streamController.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Home",
                                      style: TextStyle(
//                                    color: colorsAnimation1.value,
                                        color:Color(snapshot.data),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
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
                          pageController.animateToPage(1, duration: new Duration(milliseconds: 500), curve: new ElasticOutCurve(4));
                        },
                        child: Container(
                          width: 126,
                          height: 55,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Image(
                                  width: 34,
                                  height: 34,
                                  image: AssetImage("images/tab_swap.png"),
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: _streamController2.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Swap",
                                      style: TextStyle(
//                                    color: colorsAnimation2.value,
   color:Color(snapshot.data),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Ubuntu",
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ],
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
//      bottomNavigationBar: SafeArea(
//        child: Material(
//          color: Colors.transparent,
//          child: Container(
//            width: 100,
//            height: 50,
//            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100)), boxShadow: [BoxShadow(spreadRadius: -10, blurRadius: 60, color: Colors.black.withOpacity(.4), offset: Offset(0, 25))]),
//            child: Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
//              child: Text("123"),
////              child: GNav(
////                  duration: Duration(milliseconds: 700),
////
////                  tabs: [
////                    GButton(
////                      gap: gap,
////                      iconActiveColor: Colors.pink,
////                      iconColor: Colors.black,
////                      textColor: Colors.pink,
////                      backgroundColor: Colors.pink.withOpacity(.2),
////                      iconSize: 24,
////                      leading: InkWell(
////                        child: Container(
////                            child:  Image(
////                              width: 24,
////                              height: 24,
////                              image: AssetImage("images/tab_home.png"),
////                            ),),
////                      ),
////                      padding: padding,
////                      onPressed: () {
////                        controller.jumpToPage(0);
////                      },
////                      // textStyle: t.textStyle,
////                      text: 'Home',
////                      textStyle: TextStyle(
////                        color: Color(0xFFFC2365),
////                        fontWeight: FontWeight.w600,
////                        fontFamily: "Ubuntu",
////                      ),
////                    ),
////                    GButton(
////                      gap: gap,
////                      iconActiveColor: Color(0xff3460ee),
////                      textColor: Color(0xff3460ee),
////                      backgroundColor: Color(0xff3460ee).withOpacity(.2),
////                      iconColor: Colors.black,
////                      iconSize: 24,
////                      padding: padding,
////                      textStyle: TextStyle(
////                        color: Color(0xff3460ee),
////                        fontWeight: FontWeight.w600,
////                        fontFamily: "Ubuntu",
////                      ),
////                      leading: InkWell(
////                        child: Container(
////                          child:  Image(
////                            width: 24,
////                            height: 24,
////                            image: AssetImage("images/tab_swap.png"),
////                          ),),
////                      ),
////                      onPressed: () {
////                        controller.jumpToPage(1);
////                      },
////// textStyle: t.textStyle,
////                      text: 'Swap',
////                    ),
//////                  GButton(
//////                    gap: gap,
//////                    iconActiveColor: Color(0xff3460ee),
//////                    textColor: Color(0xff3460ee),
//////                    backgroundColor: Color(0xff3460ee).withOpacity(.2),
//////                    iconColor: Colors.black,
//////                    iconSize: 24,
//////                    padding: padding,
//////                    onPressed: () {
//////                      controller.jumpToPage(1);
//////                    },
//////                    icon: LineIcons.tty,
//////// textStyle: t.textStyle,
//////                    text: 'My',
//////                  )
////                  ],
////                  selectedIndex: selectedIndex,
////                  onTabChange: (index) {
////                    // _debouncer.run(() {
////
////                    print(index);
////                    setState(() {
////                      selectedIndex = index;
////                      // badge = badge + 1;
////                    });
////                    controller.jumpToPage(index);
////                    // });
////                  }),
//            ),
//          ),
//        ),
//      ),
    );
  }
}
