import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AensRegister extends StatefulWidget {
  @override
  _AensRegisterState createState() => _AensRegisterState();
}

class _AensRegisterState extends State<AensRegister> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Color(0xFFE71766),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: Colors.white,
            ),
            tooltip: 'Navigreation',
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        color: Color(0xFFE71766),
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                            Color(0xFFE71766),
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
                          "注册一个你想要的永恒区块链域名2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(20),
                        height: 132,
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
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 18, top: 20),
                              child: Text(
                                "名称",
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 18, top: 5, right: 18),
                              child: Stack(
                                children: <Widget>[
                                  TextField(
                                    controller: _textEditingController,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")), //只允许输入字母
                                    ],
                                    maxLines: 1,
                                    maxLength: 13,
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: new UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                      ),
// and:
                                      focusedBorder: new UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFFE71766)),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                      ),
                                    ),
                                    cursorColor: Color(0xFFE71766),
                                    cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 12,
                                      child: Text(
                                        ".chain",
                                        style: TextStyle(color: Colors.black, fontSize: 19),
                                      )),
                                ],
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
              child: ArgonButton(
                height: 50,
                roundLoadingShape: true,
                width: MediaQuery.of(context).size.width * 0.8,
                onTap: (startLoading, stopLoading, btnState) {
                  netRegister(context, startLoading, stopLoading);
                },
                child: Text(
                  "创 建",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitRing(
                    lineWidth: 4,
                    color: Colors.white,
                    // size: loaderWidth ,
                  ),
                ),
                borderRadius: 30.0,
                color: Color(0xFFE71766),
              ),
            )
          ],
        ));
  }

  void netRegister(BuildContext context, Function startLoading, Function stopLoading) {
    //隐藏键盘
    FocusScope.of(context).requestFocus(FocusNode());
    startLoading();
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
                title: Text("确定"),
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
  }

  void showFlush(BuildContext context) {
    flush = Flushbar<bool>(
      title: "广播成功",
      message: "正在同步节点信息,预计5分钟后同步成功!",
      backgroundGradient: LinearGradient(colors: [Color(0xFFE71766), Color(0xFFE71766)]),
      backgroundColor: Color(0xFFE71766),
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
