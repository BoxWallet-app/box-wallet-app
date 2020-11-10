import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_info_dao.dart';
import 'package:box/dao/aens_preclaim_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/th_hash_dao.dart';
import 'package:box/dao/tx_broadcast_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:box/page/aens_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';

import '../main.dart';

class AensRegister extends StatefulWidget {
  @override
  _AensRegisterState createState() => _AensRegisterState();
}

class _AensRegisterState extends State<AensRegister> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String address;

  int errorCount = 0;

  Future<String> getAddress() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                          margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Text(
                            S.of(context).aens_register_page_title,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Ubuntu",
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
                                  S.of(context).aens_register_page_name,
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontFamily: "Ubuntu",
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
                                            fontFamily: "Ubuntu",
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
                margin: const EdgeInsets.only(top: 30),
                child: ArgonButton(
                  height: 50,
                  roundLoadingShape: true,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onTap: (startLoading, stopLoading, btnState) {
                    netPreclaimV2(context, startLoading, stopLoading);
                  },
                  child: Text(
                    S.of(context).aens_register_page_create,
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
                  color: Color(0xFFFC2365),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 30,
                    ),
                    Container(
                      child: Text(
                        "The auction time of invalid domain name registration is as follows:",
                        style: TextStyle(fontSize: 16),
                      ),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 18, top: 10),
                    ),

                    Container(
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(columns: [
                          DataColumn(label: Text("Name Length")),
                          DataColumn(label: Text("Out Height")),
                        ], rows: [
                          DataRow(cells: [DataCell(Text('13+')), DataCell(Text('0'))]),
                          DataRow(cells: [DataCell(Text('9-12')), DataCell(Text('480'))]),
                          DataRow(cells: [DataCell(Text('5-8')), DataCell(Text('14880'))]),
                          DataRow(cells: [DataCell(Text('1-4')), DataCell(Text('29760'))])
                        ])),

                    Container(
                      child: Text(
                        "The corresponding fee for the length of domain name registration and auction is as follows:",
                        style: TextStyle(fontSize: 16),
                      ),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 18, top: 10),
                    ),

                    Container(
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(columns: [
                          DataColumn(label: Text("Name Length")),
                          DataColumn(label: Text("Amount(AE)")),
                        ], rows: [
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('570.2887AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2')),
                            DataCell(Text('352.4578AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3')),
                            DataCell(Text('217.8309AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4')),
                            DataCell(Text('134.6269AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5')),
                            DataCell(Text('83.204AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('6')),
                            DataCell(Text('51.4229AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('7')),
                            DataCell(Text('31.7811AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('8')),
                            DataCell(Text('19.6418AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('9')),
                            DataCell(Text('12.1393AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('10')),
                            DataCell(Text('7.5025AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('11')),
                            DataCell(Text('4.6368AE')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('12+')),
                            DataCell(Text('2.8657AE')),
                          ]),
                        ])),

                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> netPreclaimV2(BuildContext context, Function startLoading, Function stopLoading) async {
    focusNode.unfocus();
    startLoading();
    var name = _textEditingController.text + ".chain";
    AensInfoDao.fetch(name).then((AensInfoModel model) {
      stopLoading();
      print(model.toString());
      if (model.code == 200) {
        Fluttertoast.showToast(msg: "name already register", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      } else if (model.code == 201) {
        showGeneralDialog(
            context: context,
            // ignore: missing_return
            pageBuilder: (context, anim1, anim2) {},
            barrierColor: Colors.grey.withOpacity(.4),
            barrierDismissible: true,
            barrierLabel: "",
            transitionDuration: Duration(milliseconds: 400),
            transitionBuilder: (_, anim1, anim2, child) {
              final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
              return Transform(
                transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                child: Opacity(
                  opacity: anim1.value,
                  // ignore: missing_return
                  child: PayPasswordWidget(
                    title: S.of(context).password_widget_input_password,
                    dismissCallBackFuture: (String password) {
                      stopLoading();
                      return;
                    },
                    passwordCallBackFuture: (String password) async {
                      var signingKey = await BoxApp.getSigningKey();
                      var address = await BoxApp.getAddress();
                      final key = Utils.generateMd5Int(password + address);
                      var aesDecode = Utils.aesDecode(signingKey, key);

                      if (aesDecode == "") {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => BasicDialogAlert(
                            title: Text(S.of(context).dialog_hint_check_error),
                            content: Text(S.of(context).dialog_hint_check_error_content),
                            actions: <Widget>[
                              BasicDialogAction(
                                title: Text(
                                  S.of(context).dialog_conform,
                                  style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
                                ),
                                onPressed: () {
                                  stopLoading();
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      // ignore: missing_return
                      BoxApp.claimName((tx) {
                        print(tx);
                        showFlush(context);
                        stopLoading();
                        // ignore: missing_return
                      }, (error) {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => BasicDialogAlert(
                            title: Text(S.of(context).dialog_hint_check_error),
                            content: Text(error),
                            actions: <Widget>[
                              BasicDialogAction(
                                title: Text(
                                  S.of(context).dialog_conform,
                                  style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
                                ),
                                onPressed: () {
                                  stopLoading();
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                              ),
                            ],
                          ),
                        );
                        stopLoading();
                        // ignore: missing_return
                      }, aesDecode, address, name);
                      showChainLoading();
                    },
                  ),
                ),
              );
            });
      } else {
        Fluttertoast.showToast(msg: model.msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      }
    }).catchError((e) {
      stopLoading();
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }

  Future<void> netClaimV2(BuildContext context, Function startLoading, Function stopLoading, String name, String nameSalt) async {
    AensRegisterDao.fetch(name, this.address, nameSalt).then((MsgSignModel model) {
      EasyLoading.dismiss();
      stopLoading();
      if (model.code == 200) {
        Map<String, dynamic> tx = jsonDecode(EncryptUtil.decodeBase64(model.data.tx));
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext naContext) {
              // ignore: missing_return
              return TxConformWidget(
                  tx: tx,
                  // ignore: missing_return
                  dismissCallBackFuture: () {
                    stopLoading();
                  },
                  // ignore: missing_return
                  conformCallBackFuture: () {
                    // ignore: missing_return
                    showGeneralDialog(
                        context: context,
                        // ignore: missing_return
                        pageBuilder: (context, anim1, anim2) {},
                        barrierColor: Colors.grey.withOpacity(.4),
                        barrierDismissible: true,
                        barrierLabel: "",
                        transitionDuration: Duration(milliseconds: 400),
                        transitionBuilder: (_, anim1, anim2, child) {
                          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                            child: Opacity(
                              opacity: anim1.value,
                              // ignore: missing_return
                              child: PayPasswordWidget(
                                title: S.of(context).password_widget_input_password,
                                dismissCallBackFuture: (String password) {
                                  stopLoading();
                                  return;
                                },
                                passwordCallBackFuture: (String password) async {
                                  var signingKey = await BoxApp.getSigningKey();
                                  var address = await BoxApp.getAddress();
                                  final key = Utils.generateMd5Int(password + address);
                                  var aesDecode = Utils.aesDecode(signingKey, key);

                                  if (aesDecode == "") {
                                    showPlatformDialog(
                                      context: context,
                                      builder: (_) => BasicDialogAlert(
                                        title: Text(S.of(context).dialog_hint_check_error),
                                        content: Text(S.of(context).dialog_hint_check_error_content),
                                        actions: <Widget>[
                                          BasicDialogAction(
                                            title: Text(
                                              S.of(context).dialog_conform,
                                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
                                            ),
                                            onPressed: () {
                                              stopLoading();
                                              Navigator.of(context, rootNavigator: true).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  var signMsg = BoxApp.signMsg(model.data.msg, aesDecode);
                                  TxBroadcastDao.fetch(signMsg, model.data.tx, "NameClaimTx").then((model) {
                                    stopLoading();
                                    if (model.code == 200) {
                                      focusNode.unfocus();
                                      showFlush(context);
                                      print(model.data.hash);
                                    }
                                  }).catchError((e) {
                                    stopLoading();
                                    Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                  });
                                },
                              ),
                            ),
                          );
                        });
                  });
            },
            fullscreenDialog: true));
      } else {
        showPlatformDialog(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: Text(
              S.of(context).dialog_hint_send_error,
            ),
            content: Text(model.msg),
            actions: <Widget>[
              BasicDialogAction(
                title: Text(
                  S.of(context).dialog_conform,
                  style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
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
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netTh(BuildContext context, Function startLoading, Function stopLoading, String name, String nameSalt, String th) {
    errorCount++;
    if (errorCount > 5) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "th error", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      errorCount = 0;
      return;
    }
    EasyLoading.show();
    Future.delayed(Duration(seconds: 2), () {
      ThHashDao.fetch(th).then((model) {
        print(model.data.blockHeight);
        if (model.code == 200) {
          if (model.data.blockHeight == -1) {
            netTh(context, startLoading, stopLoading, name, nameSalt, th);
          } else {
            errorCount = 0;
            netClaimV2(context, startLoading, stopLoading, name, nameSalt);
          }
        } else {
          Fluttertoast.showToast(msg: model.msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
        }
      }).catchError((e) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      });
    });
  }

  void showFlush(BuildContext context) {
    flush = Flushbar<bool>(
      title: S.of(context).hint_broadcast_sucess,
      message: S.of(context).hint_broadcast_sucess_hint,
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
          S.of(context).dialog_conform,
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
