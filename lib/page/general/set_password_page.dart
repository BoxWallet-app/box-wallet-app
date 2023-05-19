import 'dart:ui';

import 'package:box/config.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../main.dart';

typedef SetPasswordPageCallBackFuture = Future Function(String password);

class SetPasswordPage extends StatefulWidget {
  final String? mnemonic;
  final SetPasswordPageCallBackFuture? setPasswordPageCallBackFuture;

  const SetPasswordPage({Key? key, this.mnemonic, this.setPasswordPageCallBackFuture}) : super(key: key);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  var loadingType = LoadingType.finish;

  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).password_widget_set_password,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: LoadingWidget(
          type: loadingType,
          onPressedError: () {},
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
                  margin: EdgeInsets.only(left: 18, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    S.of(context).SetPasswordPage_set_password,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                  child: Stack(
                    children: [
                      Container(
                        // height: 70,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                        //边框设置
                        decoration: new BoxDecoration(
                          color: Color(0xFFedf3f7),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _textEditingControllerNode,
                          focusNode: focusNodeNode,
//              inputFormatters: [
//                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
//              ],
                          inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp("[0-9]")), //只允许输入字母
                          ],

                          maxLines: 1,
                          style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10.0),
                            contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666).withAlpha(85),
                            ),
                          ),
                          cursorColor: Color(0xFFFC2365),
                          cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 18, top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    S.of(context).SetPasswordPage_set_password_re,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                  child: Stack(
                    children: [
                      Container(
                        // height: 70,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                        //边框设置
                        decoration: new BoxDecoration(
                          color: Color(0xFFedf3f7),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _textEditingControllerCompiler,
                          focusNode: focusNodeCompiler,
//              inputFormatters: [
//                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
//              ],
                          inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp("[0-9]")), //只允许输入字母
                          ],

                          maxLines: 1,
                          style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10.0),
                            contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666).withAlpha(85),
                            ),
                          ),
                          cursorColor: Color(0xFFFC2365),
                          cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 18, top: 12, right: 18),
                  alignment: Alignment.topLeft,
                  child: Text(
                    S.of(context).SetPasswordPage_set_tips,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withAlpha(130),
                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20, left: 30, right: 30),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                      onPressed: () {
                        if (!BoxApp.isDev()) {
                          if (_textEditingControllerNode.text.length < 7) {
                            EasyLoading.showToast(S.of(context).SetPasswordPage_set_error_pas_size, duration: Duration(seconds: 2));
                            return;
                          }
                          if (_textEditingControllerNode.text != _textEditingControllerCompiler.text) {
                            EasyLoading.showToast(S.of(context).SetPasswordPage_set_error_pas_2, duration: Duration(seconds: 2));
                            return;
                          }
                        }

                        //只需要回调,不需要走业务逻辑,往下进行
                        if (widget.setPasswordPageCallBackFuture != null) {
                          widget.setPasswordPageCallBackFuture!(Utils.generateMD5(_textEditingControllerNode.text + PSD_KEY));
                        }
                        Navigator.pop(context);
                        return;
                      },
                      child: Text(
                        S.of(context).account_login_page_conform,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment:  CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
