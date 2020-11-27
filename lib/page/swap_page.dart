import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:auro_avatar/auro_avatar.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/token_defi_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login_page.dart';
import 'mnemonic_copy_page.dart';
import 'node_page.dart';

class SwapPage extends StatefulWidget {
  @override
  _SwapPageState createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> with AutomaticKeepAliveClientMixin {
  var mnemonic = "";
  var version = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    getMnemonic();
  }

  Future<String> getMnemonic() {
    BoxApp.getAddress().then((String mnemonic) {
      setState(() {
        this.mnemonic = mnemonic;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top + 55),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: AnimationLimiter(
                child: EasyRefresh(
                  header: TaurusHeader(backgroundColor: Color(0xFFF5F5F5)),
                  onRefresh: () {},
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 200.0,
                          child: getItem(context, index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getItem(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: contractRecordModel.data[index])));
        },
        child: Container(
          color: Color(0xFFF5F5F5),
          child: Container(
            margin: EdgeInsets.only(left: 14, right: 14, bottom: 12, top: 0),
            padding: EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset(
                        'images/avatar_1.svg',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text("ak_***6yKx", style: TextStyle(fontSize: 16, fontFamily: "Ubuntu", color: Color(0xFF000000))),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              "溢价:",
                              style: TextStyle(
                                fontSize: 14,
                                wordSpacing: 30.0, //词间距
                                color: Color(0xFF666666),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              "-100%",
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFFF22B79),
                                  fontFamily: "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 46,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 18, left: 0),
                            child: Text(
                              "卖出数量(ABC)",
                              style: TextStyle(
                                fontSize: 14,
                                wordSpacing: 30.0, //词间距
                                color: Color(0xFF666666),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 5, left: 0),
                            child: Text(
                              "100.00 个",
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFF000000),
                                  fontFamily: "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 46,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 18, left: 0),
                            child: Text(
                              "兑换数量(AE)",
                              style: TextStyle(
                                fontSize: 14,
                                wordSpacing: 30.0, //词间距
                                color: Color(0xFF666666),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 5, left: 0),
                            child: Text(
                              "150.00 个",
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFF000000),
                                  fontFamily: "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 25,
                  margin: const EdgeInsets.only(top: 18),
                  child: FlatButton(
                    onPressed: () {
//                      clickAllCount();
                    },
                    child: Text(
                      "兑 换",
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
                    ),
                    color: Color(0xFFE61665).withAlpha(16),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
          ),
        ),
      ),
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
//                    Image(
//                      width: 40,
//                      height: 40,
//                      image: AssetImage(assetImage),
//                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: "Ubuntu",
                        ),
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
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFF5F5F5)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderItem(String content, String image, GestureTapCallback tapCallback) {
    return Material(
        color: Color(0xFFFC2365),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onTap: tapCallback,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Image(
                      width: 40,
                      height: 40,
                      image: AssetImage(image),
                    ),
                  ),
                  Text(
                    content,
                    style: new TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontFamily: "Ubuntu",
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
