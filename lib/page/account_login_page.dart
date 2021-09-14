import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/a.dart';
import 'package:box/dao/aeternity/user_login_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/user_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/mnemonic_confirm_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/set_password_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class AccountLoginPage extends StatefulWidget {
  @override
  _AccountLoginPageState createState() => _AccountLoginPageState();
}

class _AccountLoginPageState extends State<AccountLoginPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _textEditingController.text = "";
    _textEditingController.text = "memory pool equip lesson limb naive endorse advice lift result track gravity";

    var aesDecode = Utils.aesEncode("memory pool equip lesson limb naive endorse advice lift result track gravity", Utils.generateMd5Int( Utils.generateMD5("123"+a)));
    print("box_" + aesDecode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            S.of(context).account_login_page_input_mnemonic,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 18,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            ),
          ),
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Text(
                          S.of(context).account_login_page_input_hint,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withAlpha(180),
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          ),
                        ),
                      ),
                      Container(
                        height: 170,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
                                padding: EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(color: Color(0xFFedf3f7), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(15))),
                                child: TextField(
                                  controller: _textEditingController,
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                  maxLines: 14,
                                  decoration: InputDecoration(
                                    hintText: 'memory pool equip lesson limb naive endorse advice lift ...',
                                    enabledBorder: new UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0x00000000)),
                                    ),
// and:
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0x00000000)),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 19,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      color: Colors.black.withAlpha(80),
                                    ),
                                  ),
                                  cursorColor: Color(0xFFFC2365),
                                  cursorWidth: 2,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                margin: const EdgeInsets.only(left: 18, right: 25, bottom: 18),
                                child: Material(
                                  color: Color(0x00000000),
                                  child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      onTap: () async {
                                        Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
                                        if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
                                          final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()));
                                          var mnemonic = data.toString().replaceAll("box_", "");

                                          showGeneralDialog(
                                              context: context,
                                              pageBuilder: (context, anim1, anim2) {
                                                return;
                                              },
                                              barrierColor: Colors.grey.withOpacity(.4),
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
                                                      child: PayPasswordWidget(
                                                          title: S.of(context).password_widget_input_password,
                                                          passwordCallBackFuture: (String password) async {
                                                            final key = Utils.generateMd5Int(password);
                                                            var aesDecode = Utils.aesDecode(mnemonic, key);
                                                            _textEditingController.text = aesDecode;
                                                          }),
                                                    ));
                                              });
                                        } else {
                                          EasyLoading.showToast(S.of(context).hint_error_camera_permissions);
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        height: 30,
                                        child: Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.photo_camera,
                                              size: 18,
                                              color: Color(0xFF666666),
                                            ),
                                            Container(
                                              width: 5,
                                            ),
                                            Text(
                                              S.of(context).token_send_one_page_qr,
                                              style: TextStyle(
                                                color: Color(0xFF666666),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 50),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: FlatButton(
                            onPressed: () {
                              clickLogin();
                            },
                            child: Text(
                              S.of(context).account_login_page_conform,
                              maxLines: 1,
                              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
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
          )),
        ));
  }

  clickLogin() {
    if (_textEditingController.text == null || _textEditingController.text == "") {
      return;
    }
    var mnemonic = _textEditingController.text;
    BoxApp.getValidationMnemonic((isSucess) {
      if (isSucess) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SetPasswordPage(mnemonic:mnemonic)));
      } else {
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text("登录错误"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Text("助记词错误"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text(S.of(context).dialog_conform),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ).then((val) {
          print(val);
        });

        // showPlatformDialog(
        //   context: context,
        //   builder: (_) => BasicDialogAlert(
        //     title: Text("Login Error"),
        //     content: Text("mnemonic error"),
        //     actions: <Widget>[
        //       BasicDialogAction(
        //         title: Text(
        //           "Conform",
        //           style: TextStyle(
        //             color: Color(0xFFFC2365),
        //             fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
        //           ),
        //         ),
        //         onPressed: () {
        //           Navigator.of(context, rootNavigator: true).pop();
        //         },
        //       ),
        //     ],
        //   ),
        // );
      }
      return;
    }, mnemonic);
  }

  Future<void> netLogin(BuildContext context, Function startLoading, Function stopLoading) async {
    //隐藏键盘
    startLoading();
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(seconds: 1), () {
      UserLoginDao.fetch(_textEditingController.text).then((UserModel model) {
        if (!mounted) {
          return;
        }
        stopLoading();
        if (model.code == 200) {
          showGeneralDialog(
              context: context,
              pageBuilder: (context, anim1, anim2) {},
              barrierColor: Colors.grey.withOpacity(.4),
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
                      child: PayPasswordWidget(
                          title: S.of(context).password_widget_input_password,
                          passwordCallBackFuture: (String password) async {
                            final key = Utils.generateMd5Int(password + model.data.address);
                            var signingKeyAesEncode = Utils.aesEncode(model.data.signingKey, key);
                            BoxApp.setSigningKey(signingKeyAesEncode);
                            BoxApp.setAddress(model.data.address);
                            Navigator.of(super.context).pushNamedAndRemoveUntil("/home", ModalRoute.withName("/home"));
                          }),
                    ));
              });
        } else {
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('Login Error'),
                actions: <Widget>[
                  TextButton(
                    child: new Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ).then((val) {
            print(val);
          });
        }
      }).catchError((e) {
        stopLoading();
        EasyLoading.showToast('网络错误: ' + e.toString(), duration: Duration(seconds: 2));
      });
    });
  }
}
