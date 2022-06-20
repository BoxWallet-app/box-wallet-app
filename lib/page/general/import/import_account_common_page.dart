import 'dart:io';

import 'package:box/config.dart';
import 'package:box/dao/aeternity/user_login_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/user_model.dart';
import 'package:box/page/general/create/create_mnemonic_copy_page.dart';
import 'package:box/page/general/scan_page.dart';
import 'package:box/page/general/set_password_page.dart';
import 'package:box/utils/permission_helper.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../main.dart';

typedef AccountLoginCallBackFuture = Future Function(String data);

class ImportAccountCommonPage extends StatefulWidget {
  final int? type;
  final String? mnemonic;

  final AccountLoginCallBackFuture? accountLoginCallBackFuture;

  const ImportAccountCommonPage({Key? key, this.type, this.accountLoginCallBackFuture, this.mnemonic}) : super(key: key);

  @override
  _ImportAccountCommonPageState createState() => _ImportAccountCommonPageState();
}

class _ImportAccountCommonPageState extends State<ImportAccountCommonPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _textEditingController.text = "";
    if (BoxApp.isDev()) {
      _textEditingController.text = TEST_MNEMONIC;
    }

    if (widget.mnemonic != null) {
      _textEditingController.text = widget.mnemonic!;
    }

    _textEditingController.addListener(() {
      inputPassword(_textEditingController.text.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFfafbfc),
        appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          centerTitle: true,
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
              color: Color(0xFF000000),
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
                            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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

                                    List<Permission> permissions = [
                                      Permission.camera,
                                    ];
                                    PermissionHelper.check(permissions, onSuccess: () async {
                                      var data;
                                      if (Platform.isIOS) {
                                        data = Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()));
                                      } else {
                                        data = await Navigator.push(context, SlideRoute(ScanPage()));
                                      }
                                      inputPassword(data);
                                    }, onFailed: () {
                                      EasyLoading.showToast(S.of(context).hint_error_camera_permissions);
                                    }, onOpenSetting: () {
                                      openAppSettings();
                                    });

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

  inputPassword(String? data) {
    if (data == null || data == "") {
      return;
    }
    if (!data.toString().contains("box_")) {
      return;
    }
    var mnemonic = data.toString().replaceAll("box_", "");
    _textEditingController.text = "";
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return;
        } as Widget Function(BuildContext, Animation<double>, Animation<double>),
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
                child: PayPasswordWidget(
                    title: S.of(context).password_widget_input_password,
                    dismissCallBackFuture: (password) {
                      return;
                    },
                    passwordCallBackFuture: (String password) async {
                      final key = Utils.generateMd5Int(password);
                      var aesDecode = Utils.aesDecode(mnemonic, key);
                      if (aesDecode == "") {
                        showErrorDialog(context, null);
                        return;
                      }
                      _textEditingController.text = aesDecode;
                      clickLogin();
                    }),
              ));
        });
    return;
  }

  void showErrorDialog(BuildContext buildContext, String? content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.of(context).dialog_hint_check_error),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }

  clickLogin() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_textEditingController.text == "") {
      EasyLoading.showToast(S.of(context).account_login_msg, duration: Duration(seconds: 2));
      return;
    }
    var mnemonic = _textEditingController.text;
    EasyLoading.show();
    BoxApp.getValidationMnemonic((isSucess) {
      EasyLoading.dismiss();
      if (isSucess) {
        _textEditingController.text = "";
        if (widget.type == CreateMnemonicCopyPage.LOGIN) {

          if (Platform.isIOS) {
             Navigator.push(context, MaterialPageRoute(builder: (context) => SetPasswordPage(mnemonic: mnemonic)));
          } else {
            Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(SetPasswordPage(mnemonic: mnemonic)));
          }


        } else {
          if (widget.accountLoginCallBackFuture != null) {
            widget.accountLoginCallBackFuture!(mnemonic);
          }
          Navigator.pop(context);
        }
      } else {
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(S.of(context).dialog_hint),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Text(S.of(context).dialog_hint_mnemonic),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text(S.of(context).dialog_conform),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
              ],
            );
          },
        ).then((val) {});

      }
      return;
    }, mnemonic);
  }

}
