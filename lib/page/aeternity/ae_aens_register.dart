import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:box/dao/aeternity/aens_info_dao.dart';
import 'package:box/dao/aeternity/name_owner_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/name_owner_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class AeAensRegister extends BaseWidget {
  @override
  _AeAensRegisterState createState() => _AeAensRegisterState();
}

class _AeAensRegisterState extends BaseWidgetState<AeAensRegister> {
  late Flushbar flush;
  int price = 0;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? address;

  int errorCount = 0;

  String textClaim = "";

  getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
    textClaim = S().aens_register_page_create;
    _textEditingController.addListener(() {
      var length = _textEditingController.text.length;

      if (length == 0) {
        price = 0;
      }
      if (length == 1) {
        price = 571;
      }
      if (length == 2) {
        price = 353;
      }
      if (length == 3) {
        price = 218;
      }
      if (length == 4) {
        price = 134;
      }
      if (length == 5) {
        price = 84;
      }
      if (length == 6) {
        price = 52;
      }
      if (length == 7) {
        price = 32;
      }
      if (length == 8) {
        price = 20;
      }
      if (length == 9) {
        price = 13;
      }
      if (length == 10) {
        price = 8;
      }
      if (length == 11) {
        price = 5;
      }
      if (length == 12) {
        price = 4;
      }
      if (length == 13) {
        price = 3;
      }
      if (length == 14) {
        price = 2;
      }
      if (length == 15) {
        price = 1;
      }
      if (length == 16) {
        price = 1;
      }
      if (length == 17) {
        price = 1;
      }
      if (length == 18) {
        price = 1;
      }
      if (length == 19) {
        price = 1;
      }
      if (length == 29) {
        price = 1;
      }
      if (price == 0) {
        textClaim = S.of(context).aens_register_page_create;
        setState(() {});
        return;
      }
      textClaim = S.of(context).aens_register_page_create + "≈" + price.toString() + "AE";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
//
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SingleChildScrollView(
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
                              Color(0xFFEEEEEE),
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
                          margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Text(
                            S.of(context).aens_register_page_title,
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
                          height: 132,
                          //边框设置
                          decoration: new BoxDecoration(
                              color: Color(0xE6FFFFFF),
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                                  S.of(context).aens_register_page_name,
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                      focusNode: focusNode,
                                      inputFormatters: [
                                        //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")), //只允许输入字母
                                      ],
                                      maxLines: 1,
                                      maxLength: 20,
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
                                          borderSide: BorderSide(color: Color(0xFFFC2365)),
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                        ),
                                      ),
                                      cursorColor: Color(0xFFFC2365),
                                      cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 12,
                                        child: Text(
                                          ".chain",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                          ),
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
                margin: EdgeInsets.only(left: 26, top: 10, right: 26),
                alignment: Alignment.topRight,
                child: Text(
                  S.of(context).token_send_two_page_balance + " : " + AeHomePage.token,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    onPressed: () {
                      netPreclaimV2(context);
                    },
                    child: Text(
                      textClaim,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                    ),
                    color: Color(0xFFFC2365),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
//              SingleChildScrollView(
//                child: Column(
//                  children: [
//                    Container(
//                      height: 30,
//                    ),
//                    Container(
//                      child: Text(
//                        "The auction time of invalid domain name registration is as follows:",
//                        style: TextStyle(fontSize: 16),
//                      ),
//                      alignment: Alignment.topLeft,
//                      margin: EdgeInsets.only(left: 18, top: 10),
//                    ),
//
//                    Container(
//                        padding: EdgeInsets.all(16),
//                        width: MediaQuery.of(context).size.width,
//                        child: DataTable(columns: [
//                          DataColumn(label: Text("Name Length")),
//                          DataColumn(label: Text("Out Height")),
//                        ], rows: [
//                          DataRow(cells: [DataCell(Text('13+')), DataCell(Text('0'))]),
//                          DataRow(cells: [DataCell(Text('9-12')), DataCell(Text('480'))]),
//                          DataRow(cells: [DataCell(Text('5-8')), DataCell(Text('14880'))]),
//                          DataRow(cells: [DataCell(Text('1-4')), DataCell(Text('29760'))])
//                        ])),
//
//                    Container(
//                      child: Text(
//                        "The corresponding fee for the length of domain name registration and auction is as follows:",
//                        style: TextStyle(fontSize: 16),
//                      ),
//                      alignment: Alignment.topLeft,
//                      margin: EdgeInsets.only(left: 18, top: 10),
//                    ),
//
//                    Container(
//                        padding: EdgeInsets.all(16),
//                        width: MediaQuery.of(context).size.width,
//                        child: DataTable(columns: [
//                          DataColumn(label: Text("Name Length")),
//                          DataColumn(label: Text("Amount(AE)")),
//                        ], rows: [
//                          DataRow(cells: [
//                            DataCell(Text('1')),
//                            DataCell(Text('570.2887AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('2')),
//                            DataCell(Text('352.4578AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('3')),
//                            DataCell(Text('217.8309AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('4')),
//                            DataCell(Text('134.6269AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('5')),
//                            DataCell(Text('83.204AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('6')),
//                            DataCell(Text('51.4229AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('7')),
//                            DataCell(Text('31.7811AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('8')),
//                            DataCell(Text('19.6418AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('9')),
//                            DataCell(Text('12.1393AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('10')),
//                            DataCell(Text('7.5025AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('11')),
//                            DataCell(Text('4.6368AE')),
//                          ]),
//                          DataRow(cells: [
//                            DataCell(Text('12+')),
//                            DataCell(Text('2.8657AE')),
//                          ]),
//                        ])),
//
//                  ],
//                ),
//              ),
            ],
          ),
        ));
  }

  Future<void> netPreclaimV2(BuildContext context) async {
    focusNode.unfocus();

    if (AeHomePage.token == "loading...") {
      return;
    }
    if (double.parse(AeHomePage.token) < price) {
      Fluttertoast.showToast(msg: "钱包余额不足", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      return;
    }
    if (_textEditingController.text == "") {
      return;
    }
    var name = _textEditingController.text + ".chain";
    EasyLoading.show();
    NameOwnerDao.fetch(name).then((NameOwnerModel model) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: S.of(context).msg_name_already, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    }).catchError((e) {
      EasyLoading.dismiss();
      showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
        if (!mounted) return;
        Account? account = await WalletCoinsManager.instance.getCurrentAccount();
        var params = {
          "name": "aeAensClaim",
          "params": {"secretKey": "$privateKey", "name": "$name"}
        };
        var channelJson = json.encode(params);
        showChainLoading(S.of(context).show_loading_update_register);
        BoxApp.sdkChannelCall((result) {
          dismissChainLoading();
          if (!mounted) return;
          final jsonResponse = json.decode(result);
          if (jsonResponse["name"] != params['name']) {
            return;
          }
          var code = jsonResponse["code"];
          if (code != 200) {
            var message = jsonResponse["message"];
            showConfirmDialog(S.of(context).dialog_hint, message);
            return;
          }
          var hash = jsonResponse["result"]["hash"];
          showCopyHashDialog(context, hash, (val) async {
            showFlushSucess(context);
          });
          setState(() {});
          return;
        }, channelJson);
      });
    });
    return;
  }
}
