import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/aeternity/ae_token_send_two_page.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  var contentText = "";
  var address = "";

  @override
  void initState() {

    super.initState();

    getAddress();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 70,
                              color: Color(0xFFFC2365),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                  Color(0xFFFC2365),
                                  Color(0xFFEEEEEE),
                                ]),
                              ),
                              height: 400,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 20, top: 10,right: 20),
                              child: Text(
                                S.of(context).token_receive_page_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: const EdgeInsets.all(20),
                              //边框设置
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: [
//                                    BoxShadow(
//                                        color: Colors.black12,
//                                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                        blurRadius: 15.0, //阴影模糊程度
//                                        spreadRadius: 1.0 //阴影扩散程度
//                                        )
                                  ]
                                //设置四周边框
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: QrImage(
                                      data: address,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 18, left: 22, right: 22),
                                    child: Text(
                                      address,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15,
                                          color: Colors.black.withAlpha(200),
                                          height: 1.3,
                                          letterSpacing: 1.0,

                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                    ),
                                  ),

                                  Container(
                                    height: 30,
                                    margin: const EdgeInsets.only(top: 20, bottom: 40),
                                    child: FlatButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: address));
                                        setState(() {
                                          contentText =  S.of(context).token_receive_page_copy_sucess;
                                        });
                                        Fluttertoast.showToast(msg:  S.of(context).token_receive_page_copy_sucess,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                      child: Text(
                                        contentText == "" ?S.of(context).token_receive_page_copy:S.of(context).token_receive_page_copy_sucess,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 13, color: Color(0xFFF22B79),fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
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

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address){
      setState(() {
        this.address = address;
      });

    });
  }


}
