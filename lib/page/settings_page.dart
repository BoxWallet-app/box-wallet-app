import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mnemonic_copy_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          tooltip: 'Navigreation',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '设置',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,



      ),
        body:Container(
          child: Column(
            children: <Widget>[

              buildItem(context, "备份助记词", "images/profile_display_currency.png", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MnemonicCopyPage()));
              }),
              buildItem(context, "私钥密码", "images/profile_account_permissions.png", () {
                print("123");
              }),
              buildItem(context, S.of(context).language, "images/profile_lanuge.png", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
              }),
              buildItem(context, "关于", "images/profile_info.png", () {
                print("123");
              },isLine: true),

              Container(
                margin: const EdgeInsets.only(top: 80,bottom: 50),
                child: ArgonButton(
                  height: 50,
                  roundLoadingShape: true,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onTap: (startLoading, stopLoading, btnState) {
                    print("123");
                  },
                  child: Text(
                    "退 出",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  loader: Container(
                    padding: EdgeInsets.all(10),
                    child: SpinKitRing(
                      lineWidth: 4,
                      color: Colors.white,
                      // size: loaderWidth ,
                    ),
                  ),
                  borderRadius: 30.0,
                  color: Color(0xFFFC2365),
                ),
              )
            ],
          ),
        ),);
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
                        style: new TextStyle(fontSize: 15, color: Colors.black),
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
                    style: new TextStyle(fontSize: 13, color: Colors.white),
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
