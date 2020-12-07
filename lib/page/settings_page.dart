import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/photo_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login_page.dart';
import 'mnemonic_copy_page.dart';
import 'node_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin {
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: MediaQueryData.fromWindow(window).padding.top,
            ),

            Container(
              padding: EdgeInsets.only(left: 30, right: 20, top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    borderRadius: new BorderRadius.all( Radius.circular( 50)), // 也可
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Color(0xFFeeeeee), width: 0.5), // 边色与边宽度
                        color: Color(0xFFFFFFFF), // 底色
                        //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                        borderRadius: new BorderRadius.all( Radius.circular( 50)), // 也可控件一边圆角大小
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https://www.gravatar.com/avatar/" +Utils.generateMD5(HomePage.address) + "?s=100&d=robohash&r=PG",
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoPage(address:HomePage.address)));
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text(Utils.formatAddress(HomePage.address), style: TextStyle(fontSize: 16, fontFamily: "Ubuntu", color: Color(0xFF000000))),
                      ),
                      Container(
                        width: 190,
                        margin: EdgeInsets.only(left: 12, top: 4),
                        child: Text("Name: developing ", overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 14, fontFamily: "Ubuntu", color: Color(0xFF666666))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 30,
            ),
            Container(height: 1.0, margin: EdgeInsets.only(left: 30, right: 30), width: MediaQuery.of(context).size.width - 30, color: Color(0xFFF5F5F5)),
            Container(
              color: Colors.white,
              height: 15,
            ),
            if (mnemonic != "" && mnemonic != null)
              buildItem(context, S.of(context).setting_page_item_save, "images/setting_save.png", () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (context, anim1, anim2) {},
                    barrierColor: Colors.grey.withOpacity(.4),
                    barrierDismissible: true,
                    barrierLabel: "",
                    transitionDuration: Duration(milliseconds: 400),
                    transitionBuilder: (_, anim1, anim2, child) {
                      final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(0.0, 0, 0.0),
                        child: Opacity(
                          opacity: anim1.value,
                          // ignore: missing_return
                          child: PayPasswordWidget(
                            title: S.of(context).password_widget_input_password,
                            dismissCallBackFuture: (String password) {
                              return;
                            },
                            passwordCallBackFuture: (String password) async {
                              var mnemonic = await BoxApp.getMnemonic();
                              if (mnemonic == "") {
                                showPlatformDialog(
                                  context: context,
                                  builder: (_) => BasicDialogAlert(
                                    title: Text(S.of(context).dialog_hint),
                                    content: Text(S.of(context).dialog_login_user_no_save),
                                    actions: <Widget>[
                                      BasicDialogAction(
                                        title: Text(
                                          S.of(context).dialog_conform,
                                          style: TextStyle(color: Color(0xFFFC2365)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context, rootNavigator: true).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                              var address = await BoxApp.getAddress();
                              final key = Utils.generateMd5Int(password + address);
                              var aesDecode = Utils.aesDecode(mnemonic, key);

                              if (aesDecode == "") {
                                showPlatformDialog(
                                  context: context,
                                  builder: (_) => BasicDialogAlert(
                                    title: Text(S.of(context).dialog_hint_check_error),
                                    content: Text(S.of(context).dialog_hint_check_error_content),
                                    actions: <Widget>[
                                      BasicDialogAction(
                                        title: Text(
                                          S.of(context).dialog_conform,
                                          style: TextStyle(color: Color(0xFFFC2365)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context, rootNavigator: true).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MnemonicCopyPage(mnemonic: aesDecode)));
                            },
                          ),
                        ),
                      );
                    });
              }, isLine: false),
            Container(
              color: Colors.white,
              height: 5,
            ),
            buildItem(context, S.of(context).setting_page_node_set, "images/setting_node.png", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NodePage()));
            }, isLine: false),
            Container(
              color: Colors.white,
              height: 5,
            ),
            buildItem(context, S.of(context).setting_page_item_language, "images/setting_lanuage.png", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
            }, isLine: false),
            Container(
              color: Colors.white,
              height: 5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: <Widget>[
                            Image(
                              width: 30,
                              height: 30,
                              image: AssetImage("images/setting_version.png"),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                S.of(context).setting_page_item_version,
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
                        right: 35,
                        child: Text("v" + version),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//            buildItem(context, "关于", "images/profile_info.png", () {
//              print("123");
//            }, isLine: true),

            Expanded(child: Container()),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width * 0.8 - 80,
              margin: EdgeInsets.only(top: 70, bottom: MediaQueryData.fromWindow(window).padding.bottom + 50),
              child: FlatButton(
                onPressed: () {
                  HomePage.tokenABC = "loading...";
                  TokenDefiPage.model = null;
                  BoxApp.setAddress("");
                  BoxApp.setSigningKey("");
                  BoxApp.setMnemonic("");
                  Navigator.of(super.context).pushNamedAndRemoveUntil("/login", ModalRoute.withName("/login"));
                },
                child: Text(
                  S.of(context).setting_page_item_logout,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
                ),
                color: Color(0xFFE61665).withAlpha(16),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
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
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: <Widget>[
                    Image(
                      width: 30,
                      height: 30,
                      image: AssetImage(assetImage),
                    ),
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
                right: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(0xFFe0e0e0),
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
                      width: 30,
                      height: 30,
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
