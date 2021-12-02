import 'dart:io';

import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/general/scan_page.dart';
import 'package:box/utils/permission_helper.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'eth_home_page.dart';
import 'eth_token_send_two_page.dart';

class EthTokenSendOnePage extends StatefulWidget {
  final String tokenName;
  final String tokenCount;
  final String tokenImage;
  final String tokenContract;

  const EthTokenSendOnePage({Key key, this.tokenName, this.tokenCount, this.tokenImage, this.tokenContract}) : super(key: key);

  @override
  _EthTokenSendOnePageState createState() => _EthTokenSendOnePageState();
}

class _EthTokenSendOnePageState extends State<EthTokenSendOnePage> {
  Flushbar flush;
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
      if (_textEditingController.text.contains("cfx:")) {
        return;
      }
//      if(_textEditingController.text.contains(".c")){
//        return;
//      }
//      _textEditingController.text = _textEditingController.text+".chain";
    });
    getAddress();
  }
  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account account) {
      if (!mounted) {
        return;
      }
      EthHomePage.account = account;
      EthHomePage.address = account.address;
      setState(() {});
    });
  }
  Color getAccountCardBottomBg() {
    if(EthHomePage.account == null){
      return Color(0xFFFFFFFF);
    }
    print(EthHomePage.account.coin);
    if(EthHomePage.account.coin == "BNB"){
      return Color(0xFFE6A700);
    }
    if(EthHomePage.account.coin == "OKT"){
      return Color(0xFF1F94FF);
    }
    if(EthHomePage.account.coin == "HT"){
      return Color(0xFF112FD0);
    }
    return Color(0xFFFFFFFF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: getAccountCardBottomBg(),
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
                              color: getAccountCardBottomBg(),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topRight, colors: [
                                  getAccountCardBottomBg(),
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
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).token_send_one_page_address,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                                                  List<Permission> permissions = [
                                                    Permission.camera,
                                                  ];
                                                  PermissionHelper.check(permissions, onSuccess: () async {
                                                    var data;
                                                    if (Platform.isIOS) {
                                                      data = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()));
                                                    } else {
                                                      data = await Navigator.push(context, SlideRoute(ScanPage()));
                                                    }
                                                    _textEditingController.text = data;
                                                  }, onFailed: () {
                                                    EasyLoading.showToast(S.of(context).hint_error_camera_permissions);
                                                  }, onOpenSetting: () {
                                                    openAppSettings();
                                                  });
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
                                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                                            hintText: '0x7B8D5430deA51B3fae5c0f0AEA924106666ce0EE ...',
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                            ),
// and:
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: getAccountCardBottomBg()),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 19,
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              color: Colors.black.withAlpha(80),
                                            ),
                                          ),
                                          cursorColor: getAccountCardBottomBg(),
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
                    margin: const EdgeInsets.only(top: 0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () {
                          clickNext();
                        },
                        child: Text(
                          S.of(context).token_send_one_page_next,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                        ),
                        color: getAccountCardBottomBg(),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
    // if (!_textEditingController.text.contains("cfx:") && !_textEditingController.text.contains("0x")) {
    //   String address = _textEditingController.text;
    //
    //   if (!address.contains(".cfx")) {
    //     address = _textEditingController.text + ".cfx";
    //   }
    //   EasyLoading.show();
    //
    //   BoxApp.getNameToAddressCFX((address) {
    //     EasyLoading.dismiss(animation: true);
    //     if ("ERROR" == address) {
    //       Fluttertoast.showToast(msg: S.of(context).hint_error_address, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    //       return;
    //     }
    //     _textEditingController.text = address;
    //     final length = address.length;
    //     _textEditingController.selection = TextSelection(baseOffset: length, extentOffset: length);
    //     _focus.unfocus();
    //     return;
    //   }, address);
    //   return;
    // }


    if (_textEditingController.text.length != 42 || !_textEditingController.text.contains("0x")) {
      Fluttertoast.showToast(msg: S.of(context).hint_error_address, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      return;
    } else {
      if (Platform.isIOS) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EthTokenSendTwoPage(
                      address: _textEditingController.text,
                      tokenName: widget.tokenName,
                      tokenCount: widget.tokenCount,
                      tokenImage: widget.tokenImage,
                      tokenContract: widget.tokenContract,
                    )));
      } else {
        Navigator.pushReplacement(
            context,
            SlideRoute(EthTokenSendTwoPage(
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
