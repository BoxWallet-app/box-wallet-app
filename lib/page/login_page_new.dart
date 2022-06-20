import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'general/import/import_account_common_page.dart';
import 'general/create/create_mnemonic_copy_page.dart';
import 'general/import/import_chain_select_page.dart';

class LoginPageNew extends StatefulWidget {
  @override
  _LoginPageNewState createState() => _LoginPageNewState();
}

class _LoginPageNewState extends State<LoginPageNew> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      SharedPreferences.getInstance().then((value) {
        String? isShow = value.getString("is_show_hint");
        if (isShow == null || isShow == "")
          showGeneralDialog(
              useRootNavigator: false,
              context: context,
              pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
              //barrierColor: Colors.grey.withOpacity(.4),
              barrierDismissible: true,
              barrierLabel: "",
              transitionDuration: Duration(milliseconds: 0),
              transitionBuilder: (context, anim1, anim2, child) {
                final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                return Transform(
                    transform: Matrix4.translationValues(0.0, 0, 0.0),
                    child: Opacity(
                        opacity: anim1.value,
                        // ignore: missing_return
                        child: Material(
                          type: MaterialType.transparency, //透明类型
                          child: Center(
                            child: Container(
                              height: 470,
                              width: MediaQuery.of(context).size.width - 40,
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              decoration: ShapeDecoration(
                                color: Color(0xffffffff),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width - 40,
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(60)),
                                        onTap: () {
                                          Navigator.pop(context); //关闭对话框
                                          exit(0);
                                          // ignore: unnecessary_statements
//                                  widget.dismissCallBackFuture("");
                                        },
                                        child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      S.of(context).dialog_statement_title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 270,
                                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        child: Text(
                                          S.of(context).dialog_statement_content,
                                          style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(top: 30, bottom: 20),
                                    child: ArgonButton(
                                      height: 40,
                                      roundLoadingShape: true,
                                      width: 120,
                                      onTap: (startLoading, stopLoading, btnState) async {
                                        var prefs = await SharedPreferences.getInstance();
                                        prefs.setString('is_show_hint', "true");
                                        Navigator.pop(context); //关闭对话框
                                      },
                                      child: Text(
                                        S.of(context).dialog_statement_btn,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
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
                                  ),

//          Text(text),
                                ],
                              ),
                            ),
                          ),
                        )));
              });
      });
    });
  }

  DateTime? lastPopTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 点击返回键的操作
        // ignore: missing_return, missing_return
        if (lastPopTime == null || DateTime.now().difference(lastPopTime!) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(msg: "Press exit again", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          exit(0);
        }
        return;
      } as Future<bool> Function()?,
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
                          child: FlatButton(
                            onPressed: () {
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
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ).then((val) {
                                  setState(() {

                                  });
                                });



                              });
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "中文/English",
                                maxLines: 1,
                                style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                            "Box Wallet",
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                          )),
                      Container(
                        height: 30,
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
                                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                              ),
                              TypewriterAnimatedText(
                                S.of(context).login_sg2,
                                speed: const Duration(milliseconds: 80),
                                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                              ),
                              TypewriterAnimatedText(
                                S.of(context).login_sg3,
                                speed: const Duration(milliseconds: 80),
                                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                              ),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                bottom: MediaQueryData.fromWindow(window).padding.bottom + 20,
                right: 20,
                left: 20,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FlatButton(
                          onPressed: () {
                            // showMaterialModalBottomSheet(expand: true, context: context, enableDrag: false, backgroundColor: Colors.transparent, builder: (context) => SelectChainPage(type: 0));
                            EasyLoading.show();
                            BoxApp.getGenerateSecretKey((signingKey, address, mnemonic) {
                              EasyLoading.dismiss(animation: true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateMnemonicCopyPage(
                                            mnemonic: mnemonic,
                                            type: CreateMnemonicCopyPage.LOGIN,
                                          )));
                              return;
                            });

                            // Navigator.push(context, SlideRoute( SelectChainCreatePage()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              S.of(context).login_btn_create,
                              maxLines: 1,
                              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFC2365)),
                            ),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 0),
                      child: Container(
                        height: 50,
                        child: FlatButton(
                          onPressed: () {
                            if (Platform.isIOS) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ImportChainSelectPage()));
                            } else {
                              Navigator.push(context, SlideRoute(ImportChainSelectPage()));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              S.of(context).login_btn_input,
                              maxLines: 1,
                              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                            ),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//                 Positioned(
//                   bottom: 60,
//                   child: MaterialButton(
//                     child: Text(
//                       S.of(context).login_page_create,
//                       style: new TextStyle(
//                         fontSize: 17,
//                         color: Color(0xFFFFFFFF),
//                         fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                       ),
//                     ),
//                     height: 50,
//                     minWidth: 120,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
//                     onPressed: () {
// //                    netUserRegisterData();
//                       // ignore: missing_return
//                       BoxApp.getGenerateSecretKey((address, signingKey, mnemonic) {
//                         showGeneralDialog(useRootNavigator:false,
//                             context: context,
//                             pageBuilder: (context, anim1, anim2) {},
//                             //barrierColor: Colors.grey.withOpacity(.4),
//                             barrierDismissible: true,
//                             barrierLabel: "",
//                             transitionDuration: Duration(milliseconds: 0),
//                             transitionBuilder: (context, anim1, anim2, child) {
//                               final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
//                               return Transform(
//                                   transform: Matrix4.translationValues(0.0, 0, 0.0),
//                                   child: Opacity(
//                                     opacity: anim1.value,
//                                     // ignore: missing_return
//                                     child: PayPasswordWidget(
//                                         title: S.of(context).password_widget_set_password,
//                                         passwordCallBackFuture: (String password) async {
//                                           WalletCoinsManager.instance.getCoins().then((walletCoinModel) {
//                                             final key = Utils.generateMd5Int(password + address);
//                                             var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
//                                             var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);
//
//                                             // walletCoinModel.ae.add(account);
//                                             WalletCoinsManager.instance.addAccount("AE", "Aeternity", address, mnemonicAesEncode, signingKeyAesEncode,true).then((value) {
//                                               BoxApp.setSigningKey(signingKeyAesEncode);
//                                               BoxApp.setMnemonic(mnemonicAesEncode);
//                                               BoxApp.setAddress(address);
//                                               Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
//                                             });
//                                             return;
//                                           });
//                                           return;
//                                         }),
//                                   ));
//                             });
//                         return;
//                       });
// //                      Navigator.pushReplacementNamed(context, "home");
//                     },
//                   ),
//                 )
            ],
          ),
        ),
      ),
    );
  }
}
