import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../main.dart';
import 'home_page.dart';

class SwapInitiatePage extends StatefulWidget {
  @override
  _SwapInitiatePageState createState() => _SwapInitiatePageState();
}

class _SwapInitiatePageState extends State<SwapInitiatePage> {
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      //请求获取焦点
      FocusScope.of(context).requestFocus(focusNodeNode);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).swap_title_send,
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
          focusNodeCompiler.unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 18, top: 0),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_1,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                child: Stack(
                  children: [
                    Container(
                      height: 40,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                      //边框设置
                      decoration: new BoxDecoration(
                        color: Color(0xFFf5f5f5),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(

                        controller: _textEditingControllerNode,
                        focusNode: focusNodeNode,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
                        ],
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Ubuntu",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFFeeeeee),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: S.of(context).swap_text_hint,
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
                    Positioned(
                      right: 15,
                      child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "ABC",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Ubuntu",
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 26, top: 10, right: 26),
                alignment: Alignment.topRight,
                child: Text(
                  S.of(context).token_send_two_page_balance + " : " + HomePage.tokenABC,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, top: 18),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_2,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                child: Stack(
                  children: [
                    Container(
//                      padding: EdgeInsets.only(left: 10, right: 10),
                      //边框设置
                      height: 40,
                      decoration: new BoxDecoration(
                        color: Color(0xFFf5f5f5),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
//                                          autofocus: true,

                        controller: _textEditingControllerCompiler,
                        focusNode: focusNodeCompiler,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],

                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Ubuntu",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFFeeeeee),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: S.of(context).swap_text_hint,
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
                    Positioned(
                      right: 15,
                      child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "AE",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Ubuntu",
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 25,
                margin: const EdgeInsets.only(top: 28),
                child: FlatButton(
                  onPressed: () {
                    netSell();
                  },
                  child: Text(
                    S.of(context).swap_send_3,
                    maxLines: 1,
                    style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFFFFFFF)),
                  ),
                  color: Color(0xFFE61665),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, top: 18),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_4,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 8),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_5,
                  style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: "Ubuntu", height: 1.5, color: Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void netSell() {
    focusNodeNode.unfocus();
    focusNodeCompiler.unfocus();
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              // ignore: missing_return
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var signingKey = await BoxApp.getSigningKey();
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  var aesDecode = Utils.aesDecode(signingKey, key);

                  if (aesDecode == "") {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(S.of(context).dialog_hint_check_error_content),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  // ignore: missing_return
                  BoxApp.contractSwapSell((tx) {
                    focusNodeNode.unfocus();
                    focusNodeCompiler.unfocus();
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_send_sucess,
                        ),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              focusNodeNode.unfocus();
                              focusNodeCompiler.unfocus();
                              eventBus.fire(SwapEvent());

                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }, (error) {
                    // ignore: missing_return, missing_return
                    showPlatformDialog(
                      context: context,
                      // ignore: missing_return
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            // ignore: missing_return
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }, aesDecode, address, BoxApp.SWAP_CONTRACT, BoxApp.SWAP_CONTRACT_ABC, _textEditingControllerNode.text, _textEditingControllerCompiler.text);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }



  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }
}
