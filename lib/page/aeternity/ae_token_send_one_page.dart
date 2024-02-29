import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:box/dao/aeternity/name_owner_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/name_owner_model.dart';
import 'package:box/page/aeternity/ae_token_send_two_page.dart';
import 'package:box/page/general/scan_page.dart';
import 'package:box/utils/permission_helper.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

class AeTokenSendOnePage extends StatefulWidget {
  final String? tokenName;
  final String? tokenCount;
  final String? tokenImage;
  final String? tokenContract;

  const AeTokenSendOnePage({Key? key, this.tokenName, this.tokenCount, this.tokenImage, this.tokenContract}) : super(key: key);

  @override
  _AeTokenSendOnePageState createState() => _AeTokenSendOnePageState();
}

class _AeTokenSendOnePageState extends State<AeTokenSendOnePage> {
  Flushbar? flush;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.addListener(() {
      if (_textEditingController.text.contains("\n") || _textEditingController.text.contains(" ")) {
        _textEditingController.text = _textEditingController.text.replaceAll("\n", "");
        _textEditingController.text = _textEditingController.text.replaceAll(" ", "");
        return;
      }
      if (_textEditingController.text.contains("ak_")) {
        return;
      }
//      if(_textEditingController.text.contains(".c")){
//        return;
//      }
//      _textEditingController.text = _textEditingController.text+".chain";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          elevation: 0,
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                              height: 80,
                              color: Color(0xFFFC2365),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                  Color(0xFFFC2365),
                                  Color(0xFFEEEEEE),
                                ]),
                              ),
                              height: 190,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
                              child: Text(
                                S.of(context).token_send_one_page_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(20),
                              height: 170,
                              //边框设置
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).token_send_one_page_address,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Material(
                                            color: Color(0x00000000),
                                            child: InkWell(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                onTap: () async {
                                                  // var status = await Permission.camera.status;
                                                  // if (status.isDenied) {
                                                  //   // We didn't ask for permission yet or the permission has been denied before but not permanently.
                                                  // }

                                                  if (await Permission.location.isRestricted || await Permission.contacts.request().isGranted) {
                                                    // Either the permission was already granted before or the user just granted it.
                                                    final data = await Navigator.push(context, SlideRoute(ScanPage()));
                                                    _textEditingController.text = data;
                                                  } else {
                                                    openAppSettings();
                                                  }
                                                  //
                                                  // List<Permission> permissions = [
                                                  //   Permission.camera,
                                                  // ];
                                                  // PermissionHelper.check(permissions, onSuccess: () async {
                                                  //   final data = await Navigator.push(context, SlideRoute(ScanPage()));
                                                  //   _textEditingController.text = data;
                                                  // }, onFailed: () {
                                                  //   EasyLoading.showToast(S.of(context).hint_error_camera_permissions);
                                                  // }, onOpenSetting: () {
                                                  //   openAppSettings();
                                                  // });
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
                                                          fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 0, right: 18),
                                    child: Stack(
                                      children: <Widget>[
                                        TextField(
                                          controller: _textEditingController,
                                          focusNode: _focus,

                                          maxLines: 3,
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'ak_idkx6m3bgRr7WiKXuB8EBYBoRq ...',
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                            ),
// and:
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 19,
                                              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                              color: Colors.black.withAlpha(80),
                                            ),
                                          ),
                                          cursorColor: Color(0xFFFC2365),
                                          cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                        ),
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
                    margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                        onPressed: () {
                          clickNext();
                        },
                        child: Text(
                          S.of(context).token_send_one_page_next,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  clickNext() {
    if (!_textEditingController.text.contains("ak_")) {
      String address = _textEditingController.text;

      if (!address.contains(".chain")) {
        address = _textEditingController.text + ".chain";
      }
      EasyLoading.show();
      NameOwnerDao.fetch(address).then((NameOwnerModel model) {
        EasyLoading.dismiss(animation: true);
        if (model.owner!.isNotEmpty) {
          String? accountPubkey = "";
          model.pointers!.forEach((element) {
            if (element.key == "account_pubkey") {
              accountPubkey = element.id;
            }
          });
          if (accountPubkey == "") {
            accountPubkey = model.owner;
          }

          _textEditingController.text = accountPubkey!;
          final length = accountPubkey!.length;
          _textEditingController.selection = TextSelection(baseOffset: length, extentOffset: length);
          _focus.unfocus();
        } else {
          Fluttertoast.showToast(msg: S.of(context).hint_error_address, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          EasyLoading.dismiss(animation: true);
        }
      }).catchError((e) {
        EasyLoading.dismiss(animation: true);
      });
      return;
    }

    if (_textEditingController.text.length < 10 && _textEditingController.text.contains("ak_")) {
      Fluttertoast.showToast(msg: S.of(context).hint_error_address, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      return;
    } else {
      if (Platform.isIOS) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AeTokenSendTwoPage(
                      address: _textEditingController.text,
                      tokenName: widget.tokenName,
                      tokenCount: widget.tokenCount,
                      tokenImage: widget.tokenImage,
                      tokenContract: widget.tokenContract,
                    )));
      } else {
        Navigator.pushReplacement(
            context,
            SlideRoute(AeTokenSendTwoPage(
              address: _textEditingController.text,
              tokenName: widget.tokenName,
              tokenCount: widget.tokenCount,
              tokenImage: widget.tokenImage,
              tokenContract: widget.tokenContract,
            )));
      }
    }
  }
}
