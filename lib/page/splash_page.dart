import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:box/dao/urls.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/page/aeternity/ae_tab_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../main.dart';
import 'aeternity/ae_home_page.dart';
import 'aeternity/new_home_page.dart';
import 'login_page_new.dart';

class SplashPage extends BaseWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends BaseWidgetState<SplashPage> {
  @override
  void initState() {
    super.initState();
    //友盟统计
    UmengCommonSdk.initCommon('603de7826ee47d382b6d2a8b', '603dd6d86ee47d382b6cecb0', '');
    //启动服务
    startService();
  }

  //服务
  Future<void> startService() async {
    //开启SDK 服务
    await BoxApp.startAeService(context, () async {
      //初始化钱包相关代码
      await WalletCoinsManager.instance.init();
      var sharedPreferences = await SharedPreferences.getInstance();
      bool? isLanguage = false;
      try {
        isLanguage = sharedPreferences.getBool('is_language');
      } catch (e) {
        // logger.warning("SPLASH ERROR : " + e.toString());
      }
      if (isLanguage == null) {
        isLanguage = false;
      }
      if (isLanguage) {
        var language = await BoxApp.getLanguage();
        BoxApp.language = language;
        logger.info("APP LANGUAGE : " + language);
        Future.delayed(Duration(seconds: 1), () {
          S.load(Locale(language, language.toUpperCase()));
          goHome();
        });
      } else {
        showCommonDialog(context, "选择语言 / Language", "Please choose the language you want to use\n请选择你要使用的语言", "中文", "English", (val) async {
          if (val) {
            BoxApp.language = "cn";
            BoxApp.setLanguage("cn");
            S.load(Locale("cn", "cn".toUpperCase()));
          } else {
            BoxApp.language = "en";
            BoxApp.setLanguage("en");
            S.load(Locale("en", "en".toUpperCase()));
          }
          Navigator.of(context, rootNavigator: true).pop();
          goHome();
        });
      }
      return;
    });
  }

  Future<void> goHome() async {
    Host.baseHost = await BoxApp.getBaseHost();
    String nodeUrl = await BoxApp.getNodeUrl();
    if (nodeUrl != "") {
      // setSDKBaseUrl("https://node.aeasy.io");
      setSDKBaseUrl("https://mainnet.aeternity.io");
    }
    //获取当前的账号
    var account = await WalletCoinsManager.instance.getCurrentAccount();
    String address = await BoxApp.getAddress();
    var sp = await SharedPreferences.getInstance();
    sp.setBool('is_language', true);
    //获取用户是否登录了
    if (address.length > 10 && account != null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NewHomePage()), (route) => true);
    } else {
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new LoginPageNew()), (route) => true);
    }
  }

  //设置SDK Url
  void setSDKBaseUrl(String nodeUrl) {
    var jsonData = {
      "name": "aeSetNodeUrl",
      "params": {"url": nodeUrl}
    };
    var channelJson = json.encode(jsonData);
    BoxApp.sdkChannelCall((result) {
      return;
    }, channelJson);
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
                      image: AssetImage('images/splash_logo.png'),
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
