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
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int selectedIndex = 0;
  int badge = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;

  PageController controller = PageController();

  List<Color> colors = [
    Colors.purple,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();

    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    double gap = 10;
  }

  @override
  Widget build(BuildContext context) {
    padding = EdgeInsets.symmetric(horizontal: 18, vertical: 6);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBody: true,

      body: Container(
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (page) {
                selectedIndex = page;
                badge = badge + 1;
                // 延时1s执行返回
                Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {
//
                  });
                });
//
//          setState(() {
//
//          });
              },

              controller: controller,
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
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 18),
                                alignment: Alignment.topLeft,
                                child: Image(
                                  width: 153,
                                  height: 36,
                                  image: AssetImage('images/home_logo_left.png'),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingsPage()));
                                },
                                child: Container(
                                  height: 55,
                                  width: 55,
                                  padding: EdgeInsets.all(15),
                                  child: Image(
                                    width: 36,
                                    height: 36,
                                    color: Colors.black,
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                    spreadRadius: -10,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.4),
                    offset: Offset(0, 25))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
            child: GNav(
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: 300),
                tabs: [
                  GButton(
                    gap: gap,
                    iconActiveColor: Colors.pink,
                    iconColor: Colors.black,
                    textColor: Colors.pink,
                    backgroundColor: Colors.pink.withOpacity(.2),
                    iconSize: 24,
                    padding: padding,
                    onPressed: () {
                      controller.jumpToPage(0);
                    },
                    icon: Icons.home_outlined,
                    // textStyle: t.textStyle,
                    text: 'Home',
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Color(0xff3460ee),
                    textColor: Color(0xff3460ee),
                    backgroundColor: Color(0xff3460ee).withOpacity(.2),
                    iconColor: Colors.black,
                    iconSize: 24,
                    padding: padding,

                    onPressed: () {
                      controller.jumpToPage(1);
                    },
                    icon: Icons.swap_calls_rounded,
// textStyle: t.textStyle,
                    text: 'Swap',
                  ),
//                  GButton(
//                    gap: gap,
//                    iconActiveColor: Color(0xff3460ee),
//                    textColor: Color(0xff3460ee),
//                    backgroundColor: Color(0xff3460ee).withOpacity(.2),
//                    iconColor: Colors.black,
//                    iconSize: 24,
//                    padding: padding,
//                    onPressed: () {
//                      controller.jumpToPage(1);
//                    },
//                    icon: LineIcons.tty,
//// textStyle: t.textStyle,
//                    text: 'My',
//                  )
                ],
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  // _debouncer.run(() {

                  print(index);
                  setState(() {
                    selectedIndex = index;
                    // badge = badge + 1;
                  });
                  controller.jumpToPage(index);
                  // });
                }),
          ),
        ),
      ),
    );
  }
}
