import 'package:box/dao/user_register_dao.dart';
import 'package:box/main.dart';
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
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFC2365),
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
                  image: AssetImage('images/login_logo.png'),
                ),
              ),
              Positioned(
                bottom: 125,
                child: MaterialButton(
                  child: Text(
                    "登 录",
                    style: new TextStyle(fontSize: 17, color: Color(0xFFFC2365)),
                  ),
                  color: Colors.white,
                  height: 50,
                  minWidth: 320,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                  onPressed: () {
//                    Navigator.pushReplacementNamed(context, "home");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLoginPage()));
                  },
                ),
              ),
//              Positioned(
//                  bottom: 70,
//                  child: Row(
//                    children: <Widget>[
//                      Center(
//                        child: InkWell(
//                          onTap: () {
//                            setState(() {
//                              _value = !_value;
//                            });
//                          },
//                          child: Container(
//                            child: Padding(
//                              padding: const EdgeInsets.all(10.0),
//                              child: _value
//                                  ? Icon(
//                                      Icons.check_circle,
//                                      size: 15.0,
//                                      color: Colors.white,
//                                    )
//                                  : Icon(
//                                      Icons.check_circle_outline,
//                                      size: 15.0,
//                                      color: Colors.white,
//                                    ),
//                            ),
//                          ),
//                        ),
//                      ),
//                      Text(
//                        " 我已同意《服务条款》《隐私政策》内容",
//                        style: new TextStyle(
//                            color: Color(0xEEFFFFFF), fontSize: 15),
//                      )
//                    ],
//                  ))
              Positioned(
                bottom: 60,
                child: MaterialButton(
                  child: Text(
                    "创建新账户",
                    style: new TextStyle(fontSize: 17, color: Color(0xFFFFFFFF)),
                  ),
                  height: 50,
                  minWidth: 120,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                  onPressed: () {
                    netUserRegisterData();

//                      Navigator.pushReplacementNamed(context, "home");
                  },
                ),
              )
            ],
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
                  transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: anim1.value,
                    // ignore: missing_return
                    child: PayPasswordWidget(
                        title: "设置安全密码",
                        passwordCallBackFuture: (String password) async {
                          final key = Utils.generateMd5Int(password + model.data.address);

                          var signingKeyAesEncode = Utils.aesEncode(model.data.signingKey, key);
                          var mnemonicAesEncode = Utils.aesEncode(model.data.mnemonic, key);

                          BoxApp.setSigningKey(signingKeyAesEncode);
                          BoxApp.setMnemonic(mnemonicAesEncode);
                          BoxApp.setAddress(model.data.address);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/home", ModalRoute.withName("/home"));
                        }),
                  ));
            });
      } else {}
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showToast('网络错误', duration: Duration(seconds: 2));
    });
  }
}
