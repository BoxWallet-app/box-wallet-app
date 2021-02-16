import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import 'home_page_v2.dart';

class TokenAddPage extends StatefulWidget {
  @override
  _TokenAddPageState createState() => _TokenAddPageState();
}

class _TokenAddPageState extends State<TokenAddPage> {
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "发行代币",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
          focusNodeNode.unfocus();
          focusNodeCompiler.unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
//          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 18, top: 0),
                alignment: Alignment.topLeft,
                child: Text(
                  "代币名称",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                          WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")), //只允许输入字母
                        ],
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                          hintText: "请输入名称 例如：BTC",
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
//                    Positioned(
//                      right: 15,
//                      child: Container(
//                          height: 40,
//                          alignment: Alignment.center,
//                          child: Text(
//                            "ABC",
//                            style: TextStyle(
//                              fontSize: 16,
//                              fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                              color: Colors.black,
//                            ),
//                          )),
//                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 18, top: 18),
                alignment: Alignment.topLeft,
                child: Text(
                  "发行数量",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                        ],

                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
//                    Positioned(
//                      right: 15,
//                      child: Container(
//                          height: 40,
//                          alignment: Alignment.center,
//                          child: Text(
//                            "AE",
//                            style: TextStyle(
//                              fontSize: 16,
//                              fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                              color: Colors.black,
//                            ),
//                          )),
//                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 25,
                margin: const EdgeInsets.only(top: 28),
                child: FlatButton(
                  onPressed: () {
//                    netSell();
                  },
                  child: Text(
                    "创 建",
                    maxLines: 1,
                    style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFFFFFFFF)),
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
                  "创建说明",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 8),
                alignment: Alignment.topLeft,
                child: Text(
                  "通过Box aepp 可以免费创建AEX9协议代币。整个过程全部去中心化，不会保存你的私钥信息。代币列表为了增加用户体验防止代币乱飞",
                  style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", height: 1.5, color: Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
