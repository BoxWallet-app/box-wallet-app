import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/app_store_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/app_store_model.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/login_page.dart';
import 'package:box/page/tab_page.dart';
import 'package:box/page/tab_page_v2.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _value = "";

  void netConfig() {
    AppStoreDao.fetch().then((AppStoreModel model) {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        var newVersion = 0;
        if (Platform.isIOS) {
          newVersion = int.parse(model.data.version.replaceAll(".", ""));
          var oldVersion = int.parse(packageInfo.version.replaceAll(".", ""));
          if (newVersion == oldVersion) {
            BoxApp.isOpenStore = model.data.isOpen;
          }
        }
      });
    }).catchError((e) {});
  }

  @override
  Future<void> initState() {
    super.initState();

    BoxApp.getNodeUrl().then((nodeUrl) {
      BoxApp.getCompilerUrl().then((compilerUrl) {
        if (nodeUrl == null || compilerUrl == null) {
          BoxApp.setNodeUrl("https://node.aechina.io");
          BoxApp.setCompilerUrl("https://compiler.aeasy.io");
        }
      });
    });

    AppStoreDao.fetch().then((AppStoreModel model) {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        var newVersion = 0;
        if (Platform.isIOS) {
          newVersion = int.parse(model.data.version.replaceAll(".", ""));
          var oldVersion = int.parse(packageInfo.version.replaceAll(".", ""));
          if (newVersion == oldVersion) {
            BoxApp.isOpenStore = model.data.isOpen;
            print(" BoxApp.isOpenStore :"+ BoxApp.isOpenStore.toString());
            startService();
          }
        }
      });
    }).catchError((e) {
      BoxApp.isOpenStore = true;
      print(" BoxApp.isOpenStore :"+ BoxApp.isOpenStore.toString());
      startService();
    });
  }

  void startService(){
    BoxApp.startAeService(context, () {
      SharedPreferences.getInstance().then((sp) {
        // ignore: missing_return
        var isLanguage = sp.getString('is_language');
        if (isLanguage == "true") {
          BoxApp.getLanguage().then((String value) {
            BoxApp.language = value;
            print("getLanguage->" + value);
            S.load(Locale(value, value.toUpperCase()));
            setState(() {
              _value = value;
            });
            Future.delayed(Duration(seconds: 2), () {
              S.load(Locale(value, value.toUpperCase()));
              goHome();
            });
          });
        } else {
          Future.delayed(Duration.zero, () {
            showPlatformDialog(
              context: context,
              builder: (_) => BasicDialogAlert(
                title: Text(
                  "选择语言 / Language",
                ),
                content: Text(
                  "Please choose the language you want to use\n请选择你要使用的语言",
                  style: TextStyle(
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
                actions: <Widget>[
                  BasicDialogAction(
                    title: Text(
                      "中文",
                      style: TextStyle(
                        color: Color(0xFFFC2365),
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                    onPressed: () {
                      BoxApp.language = "cn";
                      BoxApp.setLanguage("cn");
                      //通知将第一页背景色变成红色
                      S.load(Locale("cn", "cn".toUpperCase()));
                      Navigator.of(context, rootNavigator: true).pop();

                      goHome();
                    },
                  ),
                  BasicDialogAction(
                    title: Text(
                      "English",
                      style: TextStyle(
                        color: Color(0xFFFC2365),
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                    onPressed: () {
                      BoxApp.language = "en";
                      BoxApp.setLanguage("en");
                      //通知将第一页背景色变成红色
                      S.load(Locale("en", "en".toUpperCase()));
                      Navigator.of(context, rootNavigator: true).pop();
                      goHome();
                    },
                  ),
                ],
              ),
            );
          });
        }
      });
    });
  }

  void goHome() {
    BoxApp.getNodeUrl().then((nodeUrl) {
      BoxApp.getCompilerUrl().then((compilerUrl) {
        if (nodeUrl != null && nodeUrl != "" && compilerUrl != null && compilerUrl != "") {
          BoxApp.setNodeCompilerUrl(nodeUrl, compilerUrl);
        }

        // ignore: missing_return
        BoxApp.getAddress().then((value) {
          SharedPreferences.getInstance().then((sp) {
            sp.setString('is_language', "true");
            if (value.length > 10) {
              Navigator.pushReplacement(context, CustomRoute(TabPageV2()));
            } else {
              Navigator.pushReplacement(context, CustomRoute(LoginPage()));
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFFF),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                bottom: 100,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Center(
                    child: Image(
                      width: 280,
                      height: 280,
                      image: AssetImage('images/splasn_logo.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQueryData.fromWindow(window).padding.bottom + 50,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "· Infinite possibility ·",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
