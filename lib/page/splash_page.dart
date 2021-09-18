import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/page/aeternity/ae_tab_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'login_page_new.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _value = "";

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

    startService();
  }

  void startService() {
    BoxApp.startAeService(context, () {
      WalletCoinsManager.instance.init().then((value) => {
            // ignore: missing_return
            SharedPreferences.getInstance().then((sp) {
              // ignore: missing_return
              var isLanguage = sp.getString('is_language');
              if (isLanguage == "true") {
                BoxApp.getLanguage().then((String value) {
                  BoxApp.language = value;
                  logger.info("APP LANGUAGE : " + value);
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

                  showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
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
            })
          });
      return;
    });
  }

  void goHome() {
    BoxApp.getNodeUrl().then((nodeUrl) {
      BoxApp.getCompilerUrl().then((compilerUrl) {
        if (nodeUrl != null && nodeUrl != "" && compilerUrl != null && compilerUrl != "") {
          BoxApp.setNodeCompilerUrl(nodeUrl, compilerUrl);
        }

        BoxApp.getAddress().then((value) {
          SharedPreferences.getInstance().then((sp) {
            sp.setString('is_language', "true");
            if (value.length > 10) {
              Navigator.pushReplacement(context, CustomRoute(AeTabPage()));
            } else {
              Navigator.pushReplacement(context, CustomRoute(LoginPageNew()));
            }
//            Navigator.pushReplacement(context, CustomRoute(ForumPage(url: "http://localhost:8080",)));
//            Navigator.pushReplacement(context, CustomRoute(ForumPage(title:"123",signingKey:"",address:"ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF",url: "https://governance.aeternity.com/#/",)));
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

