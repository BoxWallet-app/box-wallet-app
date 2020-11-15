import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/token_defi_page.dart';
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
      appBar: AppBar(
        elevation: 0,
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).setting_page_title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            if (mnemonic != "" && mnemonic != null)
              buildItem(context, S.of(context).setting_page_item_save, "images/profile_display_currency.png", () {









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
              }),
            buildItem(context, S.of(context).setting_page_node_set, "images/profile_lanuge.png", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NodePage()));
            }, isLine: true),
            buildItem(context, S.of(context).setting_page_item_language, "images/profile_lanuge.png", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
            }, isLine: true),
            Material(
              color: Colors.white,
              child: InkWell(
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
                        right: 28,
                        child: Text("v" + version),
                      ),
                      if (true)
                        Positioned(
                          bottom: 0,
                          left: 20,
                          child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFF5F5F5)),
                        )
                    ],
                  ),
                ),
              ),
            ),
//            buildItem(context, "关于", "images/profile_info.png", () {
//              print("123");
//            }, isLine: true),

            Container(
              margin: const EdgeInsets.only(top: 80, bottom: 50),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: FlatButton(
                  onPressed: () {
                    BoxApp.setAddress("");
                    BoxApp.setSigningKey("");
                    BoxApp.setMnemonic("");
                    TokenDefiPage.model = null;
                    Navigator.of(super.context).pushNamedAndRemoveUntil("/login", ModalRoute.withName("/login"));
                  },
                  child: Text(
                    S.of(context).setting_page_item_logout,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontFamily: "Ubuntu", color: Color(0xffffffff)),
                  ),
                  color: Color(0xFFFC2365),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
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
