import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/dao/user_register_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/user_model.dart';
import 'package:box/page/account_login_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'mnemonic_copy_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _value = false;

  void netBaseData() {
    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        HomePage.height = model.data.height;
      } else {}
    }).catchError((e) {
    });
  }
  @override
  void initState() {
    super.initState();
    netBaseData();
//    Future.delayed(Duration.zero, () {
//      SharedPreferences.getInstance().then((value) {
//        String isShow = value.getString("is_show_hint");
//        if (isShow == null || isShow == "")
//          showGeneralDialog(
//              context: context,
//              pageBuilder: (context, anim1, anim2) {},
//              barrierColor: Colors.grey.withOpacity(.4),
//              barrierDismissible: true,
//              barrierLabel: "",
//              transitionDuration: Duration(milliseconds: 0),
//              transitionBuilder: (context, anim1, anim2, child) {
//                final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
//                return Transform(
//                    transform: Matrix4.translationValues(0.0, 0, 0.0),
//                    child: Opacity(
//                        opacity: anim1.value,
//                        // ignore: missing_return
//                        child: Material(
//                          type: MaterialType.transparency, //透明类型
//                          child: Center(
//                            child: Container(
//                              height: 470,
//                              width: MediaQuery.of(context).size.width - 40,
//                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                              decoration: ShapeDecoration(
//                                color: Color(0xffffffff),
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.all(
//                                    Radius.circular(8.0),
//                                  ),
//                                ),
//                              ),
//                              child: Column(
//                                children: <Widget>[
//                                  Container(
//                                    width: MediaQuery.of(context).size.width - 40,
//                                    alignment: Alignment.topLeft,
//                                    child: Material(
//                                      color: Colors.transparent,
//                                      child: InkWell(
//                                        borderRadius: BorderRadius.all(Radius.circular(60)),
//                                        onTap: () {
//                                          Navigator.pop(context); //关闭对话框
//                                          exit(0);
//                                          // ignore: unnecessary_statements
////                                  widget.dismissCallBackFuture("");
//                                        },
//                                        child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
//                                      ),
//                                    ),
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(left: 20, right: 20),
//                                    child: Text(
//                                      S.of(context).dialog_statement_title,
//                                      style: TextStyle(
//                                        fontSize: 18,
//                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                                      ),
//                                    ),
//                                  ),
//                                  Container(
//                                    height: 270,
//                                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
//                                    child: SingleChildScrollView(
//                                      child: Container(
//                                        child: Text(
//                                          S.of(context).dialog_statement_content,
//                                          style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", letterSpacing: 2, height: 2),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//
//                                  Container(
//                                    margin: const EdgeInsets.only(top: 30, bottom: 20),
//                                    child: ArgonButton(
//                                      height: 40,
//                                      roundLoadingShape: true,
//                                      width: 120,
//                                      onTap: (startLoading, stopLoading, btnState) async {
//                                        var prefs = await SharedPreferences.getInstance();
//                                        prefs.setString('is_show_hint', "true");
//                                        Navigator.pop(context); //关闭对话框
//                                      },
//                                      child: Text(
//                                        S.of(context).dialog_statement_btn,
//                                        style: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: 16,
//                                          fontWeight: FontWeight.w700,
//                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                                        ),
//                                      ),
//                                      loader: Container(
//                                        padding: EdgeInsets.all(10),
//                                        child: SpinKitRing(
//                                          lineWidth: 4,
//                                          color: Colors.white,
//                                          // size: loaderWidth ,
//                                        ),
//                                      ),
//                                      borderRadius: 30.0,
//                                      color: Color(0xFFFC2365),
//                                    ),
//                                  ),
//
////          Text(text),
//                                ],
//                              ),
//                            ),
//                          ),
//                        )));
//              });
//      });
//    });
  }
  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        // 点击返回键的操作
        // ignore: missing_return, missing_return
        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(msg: "再按一次退出", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
        }else{
          lastPopTime = DateTime.now();
          // 退出app
          exit(0);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF242A37),
        body: Container(
          child: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Positioned(
                  top: 55,
                  child: Image(
                    width: 315,
                    height: 314,
                    image: AssetImage('images/v_logo.png'),
                  ),
                ),
                Positioned(
                  bottom: 125,
                    child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                          Color(0xFFE51363),
                          Color(0xFFFF428F),
                        ]),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLoginPage()));
                        },
                        child: Text(
                          S.of(context).login_page_login,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFFFFFFFF)),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),


//                child: MaterialButton(
//                  child: Text(
//                    S.of(context).login_page_login,
//                    style: new TextStyle(
//                      fontSize: 17,
//                      color: Color(0xFFFC2365),
//                      fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                    ),
//                  ),
//                  color: Colors.white,
//                  height: 50,
//                  minWidth: 320,
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
//                  onPressed: () {
////                    Navigator.pushReplacementNamed(context, "home");
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLoginPage()));
//                  },
//                ),
                ),
                Positioned(
                  bottom: 60,
                  child: MaterialButton(
                    child: Text(
                      S.of(context).login_page_create,
                      style: new TextStyle(
                        fontSize: 17,
                        color: Color(0xFFFFFFFF),
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                      ),
                    ),
                    height: 50,
                    minWidth: 120,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    onPressed: () {
//                    netUserRegisterData();
                      // ignore: missing_return
                      BoxApp.getGenerateSecretKey((address,signingKey,mnemonic) {
                        showGeneralDialog(
                            context: context,
                            pageBuilder: (context, anim1, anim2) {},
                            barrierColor: Colors.grey.withOpacity(.4),
                            barrierDismissible: true,
                            barrierLabel: "",
                            transitionDuration: Duration(milliseconds: 400),
                            transitionBuilder: (context, anim1, anim2, child) {
                              final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                              return Transform(
                                  transform: Matrix4.translationValues(0.0, 0, 0.0),
                                  child: Opacity(
                                    opacity: anim1.value,
                                    // ignore: missing_return
                                    child: PayPasswordWidget(
                                        title: S.of(context).password_widget_set_password,
                                        passwordCallBackFuture: (String password) async {
                                          final key = Utils.generateMd5Int(password + address);

                                          var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
                                          var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);

                                          BoxApp.setSigningKey(signingKeyAesEncode);
                                          BoxApp.setMnemonic(mnemonicAesEncode);
                                          BoxApp.setNewAccount(address);
                                          BoxApp.setAddress(address);
                                          Navigator.of(super.context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
                                        }),
                                  ));
                            });
                      });
//                      Navigator.pushReplacementNamed(context, "home");
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void netUserRegisterData() {
    EasyLoading.show();
    UserRegisterDao.fetch().then((UserModel model) {
      EasyLoading.dismiss(animation: true);
      if (model.code == 200) {
        showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) {},
            barrierColor: Colors.grey.withOpacity(.4),
            barrierDismissible: true,
            barrierLabel: "",
            transitionDuration: Duration(milliseconds: 400),
            transitionBuilder: (context, anim1, anim2, child) {
              final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
              return Transform(
                  transform: Matrix4.translationValues(0.0, 0, 0.0),
                  child: Opacity(
                    opacity: anim1.value,
                    // ignore: missing_return
                    child: PayPasswordWidget(
                        title: S.of(context).password_widget_set_password,
                        passwordCallBackFuture: (String password) async {
                          final key = Utils.generateMd5Int(password + model.data.address);

                          var signingKeyAesEncode = Utils.aesEncode(model.data.signingKey, key);
                          var mnemonicAesEncode = Utils.aesEncode(model.data.mnemonic, key);

                          BoxApp.setSigningKey(signingKeyAesEncode);
                          BoxApp.setMnemonic(mnemonicAesEncode);
                          BoxApp.setAddress(model.data.address);
                          Navigator.of(super.context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
                        }),
                  ));
            });
      } else {}
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showToast('ERROR', duration: Duration(seconds: 2));
    });
  }
}
