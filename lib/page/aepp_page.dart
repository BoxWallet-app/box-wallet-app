import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/know_page.dart';
import 'package:box/page/super_hero_page.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/page/wetrue_page.dart';
import 'package:box/widget/ae_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottie/lottie.dart';

import 'forum_page.dart';

class AeppPage extends StatefulWidget {
  @override
  _AeppPageState createState() => _AeppPageState();
}

class _AeppPageState extends State<AeppPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        child: Column(
          children: [
            Container(
              height: MediaQueryData.fromWindow(window).padding.top + 55,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 55 - MediaQueryData.fromWindow(window).padding.top,
              width: MediaQuery.of(context).size.width,
              child: EasyRefresh(
                header: AEHeader(),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 156,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 156,
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                  Color(0xFF000000),
                                  Color(0xFF000000),
                                ]),
//                      image: DecorationImage(image: AssetImage("images/apps_wetrue.jpeg"), fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'images/37050-get-in-touch-with-us-online-managers.json',
                                      width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                      height: 126,
                                      animate: false,
                                      onLoaded: (composition) {
                                        // Configure the AnimationController with the duration of the
                                        // Lottie file and start the animation.
                                        _controller
                                          ..duration = composition.duration
                                          ..stop();
                                      },
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              S.of(context).aepp_item_1,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 18, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              S.of(context).aepp_item_1_1,
                                              style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF).withAlpha(200)),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDefiPage()));
                                              },
                                              child: Text(
                                                "GO",
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
                                              ),
                                              color: Color(0xFFFFFFFFF),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 156,
                              child: Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForumPage()));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 156,
                      margin: EdgeInsets.only(left: 16, top: 12, right: 16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 156,
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                  Color(0xFF311b58),
                                  Color(0xFF311b58),
                                ]),
//                      image: DecorationImage(image: AssetImage("images/apps_wetrue.jpeg"), fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'images/35049-data-analyst.json',
                                      width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                      height: 126,
                                      animate: false,
                                      onLoaded: (composition) {
                                        // Configure the AnimationController with the duration of the
                                        // Lottie file and start the animation.
                                        _controller
                                          ..duration = composition.duration
                                          ..forward();
                                      },
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                      height: 156,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Aeknow.org",
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 18, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              S.of(context).aepp_item_2_1,
                                              style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF).withAlpha(200)),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => WeTruePage()));
                                              },
                                              child: Text(
                                                "GO",
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF311b58)),
                                              ),
                                              color: Color(0xFFFFFFFFF),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 156,
                              child: Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => KnowPage()));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 156,
                      margin: EdgeInsets.only(left: 16, top: 12, right: 16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 156,
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                  Color(0xFF001227),
                                  Color(0xFF001227),
                                ]),
//                      image: DecorationImage(image: AssetImage("images/apps_wetrue.jpeg"), fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                height: 156,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'images/34625-wallet-card-animation.json',
                                      width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                      height: 126,
                                      animate: false,
                                      onLoaded: (composition) {
                                        // Configure the AnimationController with the duration of the
                                        // Lottie file and start the animation.
                                        _controller
                                          ..duration = composition.duration
                                          ..forward();
                                      },
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                      height: 156,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Base wallet",
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 18, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              S.of(context).aepp_item_3_1,
                                              style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF).withAlpha(200)),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => WeTruePage()));
                                              },
                                              child: Text(
                                                "GO",
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF001227)),
                                              ),
                                              color: Color(0xFFFFFFFFF),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 156,
                              child: Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BasePage()));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoxApp.language == "cn"
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 156,
                            margin: EdgeInsets.only(left: 16, top: 12, right: 16),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 32,
                                    height: 156,
                                    decoration: new BoxDecoration(
                                      gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                        Color(0xFFf7296e),
                                        Color(0xFFf7296e),
                                      ]),
//                      image: DecorationImage(image: AssetImage("images/apps_wetrue.jpeg"), fit: BoxFit.fitWidth),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 30, right: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                            'images/26540-blogging-writing-typing.json',
                                            width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                            height: 126,
                                            animate: false,
                                            onLoaded: (composition) {
                                              // Configure the AnimationController with the duration of the
                                              // Lottie file and start the animation.
                                              _controller
                                                ..duration = composition.duration
                                                ..forward();
                                            },
                                          ),
                                          Expanded(child: Container()),
                                          Container(
                                            width: (MediaQuery.of(context).size.width - 32) / 3 + 10,
                                            height: 156,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "WeTrue.io",
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 18, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 6),
                                                  child: Text(
                                                    S.of(context).aepp_item_4_1,
                                                    style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF).withAlpha(200)),
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  margin: const EdgeInsets.only(top: 10),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => WeTruePage()));
                                                    },
                                                    child: Text(
                                                      "GO",
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFf7296e)),
                                                    ),
                                                    color: Color(0xFFFFFFFFF),
                                                    textColor: Colors.black,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 32,
                                    height: 156,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => WeTruePage()));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      width: 1,
                      height: 100 + MediaQueryData.fromWindow(window).padding.bottom,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  noSuchMethod(Invocation invocation) => true;
}
