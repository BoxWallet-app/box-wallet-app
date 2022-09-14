import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottie/lottie.dart';

class AeSwapPage extends StatefulWidget {
  @override
  _AeSwapPageState createState() => _AeSwapPageState();
}

class _AeSwapPageState extends State<AeSwapPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController controller = EasyRefreshController();
  TextEditingController sellTextControllerNode = TextEditingController();
  final FocusNode sellFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        // 隐藏阴影
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "SuperHero DEX",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: EasyRefresh(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0, left: 18, right: 18),
              child: Container(
                decoration: new BoxDecoration(
                  color: Color.fromARGB(230, 255, 255, 255),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 18, right: 18),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Sell",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            child: Text(
                              "Balance:0.00 ",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xff333333),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "[MAX]",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFC2365),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-ae.png",
                                errorBuilder: (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                  );
                                },
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (wasSynchronouslyLoaded) return child;
                                  return AnimatedOpacity(
                                    child: child,
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.easeOut,
                                  );
                                },
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10, right: 8),
                                child: Text(
                                  "AE",
                                  style: new TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Image(
                            width: 20,
                            height: 20,
                            color: Color(0xFF999999),
                            image: AssetImage("images/ic_swap_down.png"),
                          ),
                          Expanded(child: Container()),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Container(
                              // height: 70,
                              //                      padding: EdgeInsets.only(left: 10, right: 10),
                              //边框设置
                              decoration: new BoxDecoration(
                                color: Color.fromARGB(0, 237, 243, 247),
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                controller: sellTextControllerNode,
                                focusNode: sellFocusNode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
                                ],

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 26,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "0.00",
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
                                    borderSide: BorderSide(color: Color.fromARGB(0, 252, 35, 100)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 26,
                                    color: Color(0xFF666666).withAlpha(85),
                                  ),
                                ),
                                cursorColor: Color(0xFFFC2365),
                                cursorWidth: 2,
                                //                                cursorRadius: Radius.elliptical(20, 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      height: 35,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                              color: Color(0xFFF22B79).withAlpha(16),
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Image(
                              width: 30,
                              height: 30,
                              color: Color(0xFFF22B79),
                              image: AssetImage("images/ic_swap_vert.png"),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, left: 18, right: 18),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Buy",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            child: Text(
                              "Balance: 0.0 ",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xff333333),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-abc.png",
                                errorBuilder: (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                  );
                                },
                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                  if (wasSynchronouslyLoaded) return child;
                                  return AnimatedOpacity(
                                    child: child,
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.easeOut,
                                  );
                                },
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10, right: 5),
                                child: Text(
                                  "ABC",
                                  style: new TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Image(
                            width: 20,
                            height: 20,
                            color: Color(0xFF999999),
                            image: AssetImage("images/ic_swap_down.png"),
                          ),
                          Expanded(child: Container()),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Container(
                              // height: 70,
                              //                      padding: EdgeInsets.only(left: 10, right: 10),
                              //边框设置
                              decoration: new BoxDecoration(
                                color: Color.fromARGB(0, 237, 243, 247),
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                controller: sellTextControllerNode,
                                focusNode: sellFocusNode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
                                ],

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 26,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "0.00",
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
                                    borderSide: BorderSide(color: Color.fromARGB(0, 252, 35, 100)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 26,
                                    color: Color(0xFF666666).withAlpha(85),
                                  ),
                                ),
                                cursorColor: Color(0xFFFC2365),
                                cursorWidth: 2,
                                //                                cursorRadius: Radius.elliptical(20, 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 35,
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (false)
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 18, right: 18),
                                height: 50,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                                      backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFE61665).withAlpha(16),
                                      )),
                                  onPressed: () {},
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      "Loading...",
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color.fromARGB(112, 242, 43, 123)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 18, right: 18),
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                                onPressed: () {},
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    "Confirm",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (true)
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Slippage",
                                      style: new TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff999999),
                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          child: TextButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                                                minimumSize: MaterialStateProperty.all(Size(50, 32)),
                                                visualDensity: VisualDensity.compact,
                                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                backgroundColor: MaterialStateProperty.all(
                                                  Color(0xFFE61665).withAlpha(16),
                                                )),
                                            onPressed: () {},
                                            child: Container(
                                              child: Text(
                                                "5%",
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12, left: 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Price",
                                      style: new TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff999999),
                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "1AE≈1.108231ABC",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12, left: 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Deadline",
                                      style: new TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff999999),
                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "30 Minutes",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      height: 38,
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 246, 247, 249),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Supported by",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(left: 7),
                            child: Image(
                              width: 20,
                              height: 20,
                              color: Color(0xff00ff9d),
                              image: AssetImage("images/ic_swap_superhero.png"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 7),
                            child: Text(
                              "SuperHero",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
