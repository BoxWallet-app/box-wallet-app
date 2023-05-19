import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'general/create/create_mnemonic_copy_page.dart';
import 'general/import/import_account_ae_page.dart';

class LoginPageNew extends BaseWidget {
  @override
  _LoginPageNewState createState() => _LoginPageNewState();
}

class _LoginPageNewState extends BaseWidgetState<LoginPageNew> {
  @override
  void initState() {
    super.initState();
    initSafeDialogHint();
  }

  Future<void> initSafeDialogHint() async {
    var sp = await SharedPreferences.getInstance();
    bool? isShow;
    try {
      isShow = sp.getBool("is_safe_hint");
    } catch (e) {}
    if (isShow == null) isShow = false;
    if (!isShow) {
      showHintSafeDialog(S.of(context).dialog_statement_title, S.of(context).dialog_statement_content, (val) async {});
    }
  }

  DateTime? lastPopTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (lastPopTime == null || DateTime.now().difference(lastPopTime!) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(msg: "再按一次退出程序/Press exit again", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
        } else {
          lastPopTime = DateTime.now();
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFFC2365),
        body: Container(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Positioned(
                  top: MediaQueryData.fromWindow(window).padding.top,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Container(
                          height: 50,
                          child: TextButton(
                            onPressed: () {
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
                                setState(() {});
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "中文/English",
                                maxLines: 1,
                                style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                  top: MediaQuery.of(context).size.height / 4,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Aeternity Box",
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                          )),
                      Container(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w500,
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                S.of(context).login_sg1,
                                speed: const Duration(milliseconds: 80),
                                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                              ),
                              TypewriterAnimatedText(
                                S.of(context).login_sg2,
                                speed: const Duration(milliseconds: 80),
                                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                              ),
                              TypewriterAnimatedText(
                                S.of(context).login_sg3,
                                speed: const Duration(milliseconds: 80),
                                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                              ),
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                bottom: MediaQueryData.fromWindow(window).padding.bottom + 20,
                right: 30,
                left: 30,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            sdkAeGenerateAccount(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              S.of(context).login_btn_create,
                              maxLines: 1,
                              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFC2365)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.black12),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImportAccountAePage(
                                          coinName: "AE",
                                          fullName: "Aeternity",
                                        )));
                            return;
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              S.of(context).login_btn_input,
                              maxLines: 1,
                              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sdkAeGenerateAccount(BuildContext context) {
    EasyLoading.show();
    var params = {
      "name": "aeGenerateAccount",
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      EasyLoading.dismiss(animation: true);
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      logger.info(jsonResponse["result"]["mnemonic"]);
      logger.info(jsonResponse["result"]["publicKey"]);
      logger.info(jsonResponse["result"]["secretKey"]);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateMnemonicCopyPage(
                    mnemonic: jsonResponse["result"]["mnemonic"],
                    type: CreateMnemonicCopyPage.login,
                  )));
      return;
    }, channelJson);
  }
}
