import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/page/select_chain_create_page.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../main.dart';

class SetPasswordPage extends StatefulWidget {
  final List<ChainsModel> chains;

  final String mnemonic;

  const SetPasswordPage({Key key, this.chains, this.mnemonic}) : super(key: key);

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
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                    "设置安全密码",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                          color: Color(0xFFFFFFFF),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _textEditingControllerNode,
                          focusNode: focusNodeNode,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                          inputFormatters: [
                            // WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                          ],

                          maxLines: 1,
                          style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            color: Colors.black,
                            letterSpacing: 1.0,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10.0),
                            contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                    "重复设置你的密码",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                          color: Color(0xFFFFFFFF),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _textEditingControllerCompiler,
                          focusNode: focusNodeCompiler,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                          inputFormatters: [
                            // WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                          ],

                          maxLines: 1,
                          style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            color: Colors.black,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(left: 10.0),
                            contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
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
                    "提示：密码用来保护私钥授权，请不要使用过于简单的密码；"
                    "BoxWallet不会存储密码，也无法帮您找回密码，请务必牢记密码。",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withAlpha(130),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      onPressed: () {
                        if(BoxApp.inProduct){
                          if(_textEditingControllerNode.text.length<5){
                            EasyLoading.showToast("为了您的资金安全请输入大于6位数密码", duration: Duration(seconds: 2));
                            return;
                          }
                          if(_textEditingControllerNode.text!=_textEditingControllerCompiler.text){
                            EasyLoading.showToast("两次密码不一致", duration: Duration(seconds: 2));
                            return;
                          }
                        }

                        Navigator.push(context, MaterialPageRoute(builder: (context) => SelectChainCreatePage(mnemonic:widget.mnemonic,password: _textEditingControllerNode.text,)));

                        return;
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

            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment:  CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
