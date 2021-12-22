import 'dart:io';
import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/page/aeternity/ae_tab_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../main.dart';
import 'login_page_new.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Future<void> initState() {
    super.initState();
    if (Platform.isIOS) {
      UmengCommonSdk.initCommon('603de7826ee47d382b6d2a8b', '603de7826ee47d382b6d2a8b', 'App Store');
    } else {
      UmengCommonSdk.initCommon('603dd6d86ee47d382b6cecb0', '603dd6d86ee47d382b6cecb0', 'Google');
    }
    startService();
  }

  Future<void> startService() async {
    await BoxApp.startAeService(context,() async {
      await WalletCoinsManager.instance.init();
      var sharedPreferences = await SharedPreferences.getInstance();
      String isLanguage = "false";
      try{
         isLanguage = sharedPreferences.getString('is_language');
      }catch(e){
      }

      if (isLanguage.toString() == "true") {
        var language = await BoxApp.getLanguage();
        BoxApp.language = language;
        logger.info("APP LANGUAGE : " + language);
        Future.delayed(Duration(seconds: 0), () {
          S.load(Locale(language, language.toUpperCase()));
          goHome();
        });

      } else {
        Future.delayed(Duration.zero, () {
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  TextButton(
                    child: new Text(
                      "中文",
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
                  TextButton(
                    child: new Text(
                      "English",
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
              );
            },
          ).then((val) {});
        });
      }
      return;
    });

  }

  Future<void> goHome() async {
    String nodeUrl = await BoxApp.getNodeUrl();
    String compilerUrl = await BoxApp.getCompilerUrl();
    String nodeCfxUrl = await BoxApp.getCfxNodeUrl();
    if (nodeUrl != null && nodeUrl != "" && compilerUrl != null && compilerUrl != "") {
      BoxApp.setNodeCompilerUrl(nodeUrl, compilerUrl);
    }
    if (nodeCfxUrl != null && nodeCfxUrl != "") {
      BoxApp.setCfxNodeCompilerUrl(nodeCfxUrl);
    }

    var account = await WalletCoinsManager.instance.getCurrentAccount();

    String address = await BoxApp.getAddress();
    var sp = await SharedPreferences.getInstance();
    sp.setString('is_language', "true");
    if (address.length > 10 && account!=null) {
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new AeTabPage()), (route) => route == null);
      // Navigator.of(context).pushNamedAndRemoveUntil('/login',ModalRoute.withName('/splash'));
    } else {
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new LoginPageNew()), (route) => route == null);
      // Navigator.of(context).pushNamedAndRemoveUntil('/login',ModalRoute.withName('/splash'));
    }
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
