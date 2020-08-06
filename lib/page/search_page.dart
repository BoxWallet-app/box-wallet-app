import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import 'aens_register.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
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

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  var _top = 400.00;
  var _top_y = 0;
  TextEditingController _textEditingController = TextEditingController();
  Animation<RelativeRect> _animation;
  AnimationController _controller;
  Animation _curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    //动画插值器
    _curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    //动画变化范围
    _animation = RelativeRectTween(begin: RelativeRect.fromLTRB(0.0, 380.0, 0.0, -300), end: RelativeRect.fromLTRB(0.0, 210.0, 0.0, -300)).animate(_curve);
    //启动动画
//    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
//    _top = 380.00;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
//          floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),

          backgroundColor: Color(0xFFFC2764).withAlpha(220),
//            backgroundColor: Color(0xFFEEEEEE),

          body: Container(
              margin: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
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

                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            height: 55,
                                            width: 55,
                                            padding: EdgeInsets.all(15),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                    Container(
                                      width: 3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                          top: 100,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Image(
                                  width: 230,
                                  height: 72,
                                  image: AssetImage('images/home_logo.png'),
                                ),
                                Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                            child: TextField(
                                              textAlign: TextAlign.left,

                                              controller: _textEditingController,

                                              style: TextStyle(
                                                textBaseline: TextBaseline.alphabetic,
                                                fontSize: 19,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                hintText: '搜索高度、地址、哈希、域名 ...',
                                                enabledBorder: new UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0x00000000)),
                                                ),
// and:
                                                focusedBorder: new UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0x00000000)),
                                                ),
                                                hintStyle: TextStyle(
                                                  fontSize: 19,
                                                  textBaseline: TextBaseline.alphabetic,
                                                  color: Colors.black.withAlpha(80),
                                                ),
                                              ),
                                              cursorColor: Color(0xFFFC2365),
                                              cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Icon(Icons.clear, color: Colors.black.withAlpha(80)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 70, bottom: 50),
                                  child: ArgonButton(
                                    height: 50,
                                    roundLoadingShape: true,
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    onTap: (startLoading, stopLoading, btnState) {
                                      print("123");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                                    },
                                    child: Text(
                                      "搜 索",
                                      style: TextStyle(color: Color(0xFFFC2365), fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                    loader: Container(
                                      padding: EdgeInsets.all(10),
                                      child: SpinKitRing(
                                        lineWidth: 4,
                                        color: Color(0xFFFC2365),
                                        // size: loaderWidth ,
                                      ),
                                    ),
                                    borderRadius: 30.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
