import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/contract_transfer_call_dao.dart';
import 'package:box/dao/token_list_dao.dart';
import 'package:box/dao/token_send_dao.dart';
import 'package:box/dao/tx_broadcast_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_call_model.dart';
import 'package:box/model/token_list_model.dart';
import 'package:box/model/token_send_model.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import 'home_page.dart';
import 'home_page_v2.dart';

class TokenSendTwoPage extends StatefulWidget {
  final String address;

  TokenSendTwoPage({Key key, @required this.address}) : super(key: key);

  @override
  _TokenSendTwoPageState createState() => _TokenSendTwoPageState();
}

class _TokenSendTwoPageState extends State<TokenSendTwoPage> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String address = '';
  int currentPosition = -1;
  var loadingType = LoadingType.loading;
  TokenListModel tokenListModel;
  List<Widget> items = List<Widget>();

  @override
  void initState() {
    super.initState();
    netAccountInfo();
    getAddress();
    netTokenList();
  }
  void netContractBalance(int index) {
    ContractBalanceDao.fetch(tokenListModel.data[index].ctAddress).then((ContractBalanceModel model) {
      if (model.code == 200) {
        tokenListModel.data[index].countStr = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netTokenList() {
    EasyLoading.show();
    TokenListDao.fetch(HomePageV2.address,"").then((TokenListModel model) {
      EasyLoading.dismiss(animation: true);
      if (model != null || model.code == 200) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
        if (tokenListModel == null) {
          return;
        }

        items.add(
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentPosition = -1;
                });
              },
              child: Container(
                height: 70,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(36.0),
                              image: DecorationImage(
                                image: AssetImage("images/apple-touch-icon.png"),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 17),
                            child: Text(
                              "AE",
                              style: new TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            HomePageV2.token + " ",
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xFF666666),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        for (var i = 0; i < tokenListModel.data.length; i++) {
          var item = itemListView(context, i);

          items.add(item);
        }

        setState(() {});
      } else {
        tokenListModel = null;
        loadingType = LoadingType.error;
        setState(() {});
      }
    }).catchError((e) {
      print(e);
      EasyLoading.dismiss(animation: true);
      loadingType = LoadingType.error;
      setState(() {});
    });
  }



  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        HomePageV2.token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                              width: MediaQuery.of(context).size.width,
                              height: 130,
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
                                S.of(context).token_send_two_page_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    S.of(context).token_send_two_page_from,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    Utils.formatAddress(address),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    S.of(context).token_send_two_page_to,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    getReceiveAddress(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(20),
                              height: 172,
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
                                            S.of(context).token_send_two_page_number,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              fontSize: 19,
                                            ),
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
//                                          autofocus: true,

                                          controller: _textEditingController,
                                          focusNode: focusNode,
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
                                          ],

                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '',
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 19,
                                              color: Colors.black.withAlpha(80),
                                            ),
                                          ),
                                          cursorColor: Color(0xFFFC2365),
                                          cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 12,
                                          child: Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(top: 0),
                                            child: FlatButton(
                                              onPressed: () {
                                                clickAllCount();
                                              },
                                              child: Text(
                                                S.of(context).token_send_two_page_all,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                                              ),
                                              color: Color(0xFFE61665).withAlpha(16),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        if (tokenListModel == null) {
                                          return;
                                        }
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            backgroundColor: Color(0xFFFFFFFF).withAlpha(0),
                                            builder: (context) => Container(
                                                height: MediaQuery.of(context).size.height / 2,
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                                decoration: new BoxDecoration(color: Color(0xFFFFFFFF),
                                                    //设置四周圆角 角度
//                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                                    boxShadow: []),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 20),
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        S.of(context).token_send_two_page_coin,
                                                        style: TextStyle(
                                                          color: Color(0xFF666666),
                                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                          fontSize: 19,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 20,
                                                    ),
                                                    Expanded(
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: items,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
//
                                            );
                                      },
                                      child: Container(
                                        height: 55,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 18),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 36.0,
                                                    height: 36.0,
                                                    decoration: BoxDecoration(
                                                      border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(36.0),
                                                      image: currentPosition == -1
                                                          ? DecorationImage(
                                                              image: AssetImage("images/apple-touch-icon.png"),
//                                                        image: AssetImage("images/apple-touch-icon.png"),
                                                            )
                                                          : null,
                                                    ),
                                                    child: currentPosition != -1
                                                        ? ClipOval(
                                                            child: Image.network(
                                                              tokenListModel.data[currentPosition].image,
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
                                                          )
                                                        : null,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      currentPosition == -1 ? "AE" : tokenListModel.data[currentPosition].name,
                                                      style: new TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 28,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    currentPosition == -1 ? HomePageV2.token + " " : tokenListModel.data[currentPosition].count,
                                                    style: TextStyle(
                                                      color: Color(0xFF666666),
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15,
                                                    color: Color(0xFF666666),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () {
                          netSendV2(context);
                        },
                        child: Text(
                          S.of(context).token_send_two_page_conform,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                        ),
                        color: Color(0xFFFC2365),
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
//
  }

  void clickAllCount() {
    if (currentPosition == -1) {
      if (HomePageV2.token == "loading...") {
        _textEditingController.text = "0";
      } else {
        if (double.parse(HomePageV2.token) < 1) {
          _textEditingController.text = "0";
        } else {
          _textEditingController.text = (double.parse(HomePageV2.token) - 1).toString();
        }
      }
    } else {
      if (double.parse(tokenListModel.data[currentPosition].count) > 1) {
        _textEditingController.text = (double.parse(tokenListModel.data[currentPosition].count) - 0.1).toString();
      } else {
        _textEditingController.text = tokenListModel.data[currentPosition].count;
      }

      _textEditingController.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length));
    }
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
      });
    });
  }

  String getReceiveAddress() {
    return Utils.formatAddress(widget.address);
  }

  Future<void> netSendV2(BuildContext context) async {
    focusNode.unfocus();
    var senderID = await BoxApp.getAddress();
    if (currentPosition == -1) {
//      startLoading();
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
              transform: Matrix4.translationValues(0.0, 0, 0.0),
              child: Opacity(
                opacity: anim1.value,
                // ignore: missing_return
                child: PayPasswordWidget(
                  title: S.of(context).password_widget_input_password,
                  dismissCallBackFuture: (String password) {
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
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    // ignore: missing_return
                    BoxApp.spend((tx) {
                      showPlatformDialog(
                        androidBarrierDismissible: false,
                        context: context,
                        builder: (_) => WillPopScope(
                          onWillPop: () async => false,
                          child: BasicDialogAlert(
                            content: Text(
                              tx,
                            ),
                            actions: <Widget>[
                              BasicDialogAction(
                                title: Text(
                                  S.of(context).dialog_copy,
                                  style: TextStyle(
                                    color: Color(0xFFFC2365),
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: tx));
                                  Navigator.of(context, rootNavigator: true).pop();
                                  print(tx);
                                  showFlushSucess(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );

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
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }, aesDecode, address, widget.address, _textEditingController.text);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    } else {
//      startLoading();
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
              transform: Matrix4.translationValues(0.0, 0, 0.0),
              child: Opacity(
                opacity: anim1.value,
                // ignore: missing_return
                child: PayPasswordWidget(
                  title: S.of(context).password_widget_input_password,
                  dismissCallBackFuture: (String password) {
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
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    // ignore: missing_return
                    BoxApp.contractTransfer((tx) {
                      showPlatformDialog(
                        androidBarrierDismissible: false,
                        context: context,
                        builder: (_) => WillPopScope(
                          onWillPop: () async => false,
                          child: BasicDialogAlert(
                            content: Text(
                              tx,
                            ),
                            actions: <Widget>[
                              BasicDialogAction(
                                title: Text(
                                  S.of(context).dialog_copy,
                                  style: TextStyle(
                                    color: Color(0xFFFC2365),
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: tx));
                                  Navigator.of(context, rootNavigator: true).pop();
                                  print(tx);
                                  showFlushSucess(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
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
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                          ],
                        ),
                      );
                      // ignore: missing_return
                    }, aesDecode, address, tokenListModel.data[currentPosition].ctAddress, widget.address, _textEditingController.text, tokenListModel.data[currentPosition].type);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    }
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

  void showFlushSucess(BuildContext context) {
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
          color: Colors.black.withAlpha(80),
          offset: Offset(0.0, 2.0),
          blurRadius: 13.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
      });
  }

  Widget itemListView(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            currentPosition = index;
          });
          Navigator.pop(context);
        },
        child: Container(
          height: 70,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          tokenListModel.data[index].image,
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
                    Container(
                      padding: const EdgeInsets.only(left: 17),
                      child: Text(
                        tokenListModel.data[index].name,
                        style: new TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 10,
                child: Row(
                  children: [
                    Text(
                      tokenListModel.data[index].count,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Color(0xFF666666),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
