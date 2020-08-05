import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/token_send_two_page.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TokenReceivePage extends StatefulWidget {
  @override
  _TokenReceivePageState createState() => _TokenReceivePageState();
}

class _TokenReceivePageState extends State<TokenReceivePage> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  var contentText =  "复制地址";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Color(0xFFFC2365),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
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
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              color: Color(0xFFFC2365),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                  Color(0xFFFC2365),
                                  Color(0xFFFAFAFA),
                                ]),
                              ),
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                "分享你的地址给接受者",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(20),
                              //边框设置
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                                        blurRadius: 15.0, //阴影模糊程度
                                        spreadRadius: 1.0 //阴影扩散程度
                                        )
                                  ]
                                  //设置四周边框
                                  ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: QrImage(
                                      data: BoxApp.getAddress(),
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 18, left: 22, right: 22),
                                    child: Text(
                                      BoxApp.getAddress(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15, color: Colors.black.withAlpha(200), height: 1.3, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                    ),
                                  ),

                                  Container(
                                    width: 100,
                                    height: 30,
                                    margin: const EdgeInsets.only(top: 20,bottom: 40),
                                    child: FlatButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: BoxApp.getAddress()));
                                        setState(() {
                                          contentText = "复制成功✅️";
                                        });
                                        Fluttertoast.showToast(msg: "复制成功", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                      },
                                      child: Text(
                                        contentText,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 13,color: Color(0xFFF22B79)),
                                      ),
                                      color: Color(0xFFE61665).withAlpha(16),
                                      textColor: Colors.black,
                                      shape: RoundedRectangleBorder(

                                          borderRadius: BorderRadius.circular(30)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> netRegister(BuildContext context, Function startLoading, Function stopLoading) async {
    //隐藏键盘
    startLoading();
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(seconds: 1), () {
      AensRegisterDao.fetch(_textEditingController.text + ".chain").then((AensRegisterModel model) {
        stopLoading();
        if (model.code == 200) {
          showFlush(context);
        } else {
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text("注册失败"),
              content: Text(model.msg),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    "确定",
                    style: TextStyle(color: Color(0xFFFC2365)),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        }
      }).catchError((e) {
        stopLoading();
        Fluttertoast.showToast(msg: "网络错误", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      });
    });
  }

  void showFlush(BuildContext context) {
    flush = Flushbar<bool>(
      title: "广播成功",
      message: "正在同步节点信息,预计5分钟后同步成功!",
      backgroundGradient: LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
      backgroundColor: Color(0xFFFC2365),
      blockBackgroundInteraction: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      //                        flushbarStyle: FlushbarStyle.GROUNDED,

      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true); // result = true
        },
        child: Text(
          "确定",
          style: TextStyle(color: Colors.white),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Color(0x88000000),
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
      });
  }
}
