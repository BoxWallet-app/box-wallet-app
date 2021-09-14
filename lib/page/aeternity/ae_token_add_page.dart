import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/page/aeternity/ae_token_defi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';
import 'ae_home_page.dart';

class AeTokenAddPage extends StatefulWidget {
  @override
  _AeTokenAddPageState createState() => _AeTokenAddPageState();
}

class _AeTokenAddPageState extends State<AeTokenAddPage> {
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
          "发行Tokens",
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
                  "Tokens名称",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                        color: Color(0xFFfafbfc),
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
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                        color: Color(0xFFfafbfc),
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
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                    style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                  ),
                  color: Color(0xFFE61665),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                padding: EdgeInsets.all(10),
                //边框设置
                decoration: new BoxDecoration(
                  color: Color(0xffeeeeee),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "合约地址：ct_2M4mVQCDVxu6mvUrEue1xMafLsoA1bgsfC3uT95F3r1xysaCvE",
                      style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                    )),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 0, left: 18),
                      child: FlatButton(
                        onPressed: () {
//                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDefiPage()));
                        },
                        child: Text(
                          "复制",
                          maxLines: 1,
                          style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                        ),
                        color: Color(0xFFE61665).withAlpha(16),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
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
                  "通过BoxWallet 可以免费创建AEX9协议Tokens。整个过程全部去中心化，不会保存你的私钥信息。Tokens列表为了增加用户体验防止Tokens乱飞所设置的优秀Tokens，优秀Tokens需要进行审核\n上币流程：上币费用为10000AE 及 1000ABC，该费用作为Tokens锁仓费用，Tokens上任何中心化交易所或者退市即可退回质押Tokens\n下架流程：下架Tokens需要回收市场上全部Tokens，Tokens价格按照所采价值进行回收。或者Tokens长时间不进行流动。形成死币\n上币申请资料请准备 合约地址、Tokens名称，Tokenslogo，发送邮件到293122529@qq.com",
                  style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.5, color: Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
