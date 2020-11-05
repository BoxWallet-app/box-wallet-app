import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/contract_transfer_call_dao.dart';
import 'package:box/dao/token_send_dao.dart';
import 'package:box/dao/tx_broadcast_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_call_model.dart';
import 'package:box/model/token_send_model.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import 'home_page.dart';

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
  String currentCoinName = 'AE';

  @override
  void initState() {
    super.initState();
    netAccountInfo();
    netContractBalance();
    getAddress();
  }

  void netContractBalance() {
    ContractBalanceDao.fetch().then((ContractBalanceModel model) {
      if (model.code == 200) {
        HomePage.tokenABC = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        print(model.data.balance);
        HomePage.token = model.data.balance;
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
                              height: 200,
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
                                  fontFamily: "Ubuntu",
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
                                      fontFamily: "Ubuntu",
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
                                      fontFamily: "Ubuntu",
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
                                      fontFamily: "Ubuntu",
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
                                      fontFamily: "Ubuntu",
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
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).token_send_two_page_number,
                                            style: TextStyle(
                                              color: Color(0xFF666666),
                                              fontFamily: "Ubuntu",
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
                                            fontFamily: "Ubuntu",
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
                                            margin: const EdgeInsets.only(left: 10, right: 0),
                                            child: Material(
                                              color: Color(0x00000000),
                                              child: InkWell(
                                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                                  onTap: () {
                                                    _textEditingController.text = currentCoinName == "AE" ? HomePage.token : HomePage.tokenABC;
                                                    _textEditingController.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length));
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                                    height: 30,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          S.of(context).token_send_two_page_all,
                                                          style: TextStyle(
                                                            color: Color(0xFFFC2365),
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
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
                                    child: InkWell(
                                      onTap: () {
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            backgroundColor: Color(0xFFFFFFFF).withAlpha(0),
                                            builder: (context, scrollController) => Container(
                                                  height: 250,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xFFFFFFFF),
                                                      //设置四周圆角 角度
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                                      boxShadow: []),
                                                  child: SingleChildScrollView(
                                                    child: Column(children: [
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
                                                            fontFamily: "Ubuntu",
                                                            fontSize: 19,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                      ),
                                                      Material(
                                                        color: Colors.white,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                            setState(() {
                                                              currentCoinName = "AE";
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
                                                                          border: Border(
                                                                              bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                                              top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                                              left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                                              right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                                          borderRadius: BorderRadius.circular(36.0),
                                                                          image: DecorationImage(
                                                                            image: AssetImage("images/apple-touch-icon.png"),
//                                                        image: AssetImage("images/apple-touch-icon.png"),
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
                                                                            fontFamily: "Ubuntu",
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
                                                                        HomePage.token + " ",
                                                                        style: TextStyle(
                                                                          color: Color(0xFF666666),
                                                                          fontFamily: "Ubuntu",
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
                                                      Container(
                                                        margin: EdgeInsets.only(left: 20),
                                                        height: 1,
                                                        color: Color(0xFFEEEEEE),
                                                        width: MediaQuery.of(context).size.width,
                                                      ),
                                                      Material(
                                                        color: Colors.white,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                            setState(() {
                                                              currentCoinName = "ABC";
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
                                                                          border: Border(
                                                                              bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                                              top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                                              left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                                              right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                                          borderRadius: BorderRadius.circular(36.0),
                                                                          image: DecorationImage(
                                                                            image: AssetImage("images/logo.png"),
//                                                        image: AssetImage("images/apple-touch-icon.png"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets.only(left: 17),
                                                                        child: Text(
                                                                          "ABC",
                                                                          style: new TextStyle(
                                                                            fontSize: 15,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontFamily: "Ubuntu",
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
                                                                        HomePage.tokenABC + " ",
                                                                        style: TextStyle(
                                                                          color: Color(0xFF666666),
                                                                          fontFamily: "Ubuntu",
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
                                                    ]),
                                                  ),
                                                )
//
                                            );
                                      },
                                      child: Container(
                                        height: 60,
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
                                                      image: DecorationImage(
                                                        image: AssetImage(currentCoinName == "AE" ? "images/apple-touch-icon.png" : "images/logo.png"),
//                                                        image: AssetImage("images/apple-touch-icon.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      currentCoinName,
                                                      style: new TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Ubuntu",
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
                                                    currentCoinName == "AE" ? HomePage.token + " " : HomePage.tokenABC + " ",
                                                    style: TextStyle(
                                                      color: Color(0xFF666666),
                                                      fontFamily: "Ubuntu",
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
                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                    child: ArgonButton(
                      height: 50,
                      roundLoadingShape: true,
                      width: MediaQuery.of(context).size.width * 0.8,
                      onTap: (startLoading, stopLoading, btnState) {
                        netSendV2(context, startLoading, stopLoading);
                      },
                      child: Text(
                        S.of(context).token_send_two_page_conform,
                        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Ubuntu", fontWeight: FontWeight.w700),
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
                  )
                ],
              ),
            ),
          ),
        ));
//
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

  Future<void> netSendV2(BuildContext context, Function startLoading, Function stopLoading) async {
    focusNode.unfocus();
    var senderID = await BoxApp.getAddress();
    if (currentCoinName == "AE") {
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
                                style: TextStyle(color: Color(0xFFFC2365)),
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
                    BoxApp.spend((tx) {
                      showFlushSucess(context);
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
                                style: TextStyle(color: Color(0xFFFC2365)),
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
                                style: TextStyle(color: Color(0xFFFC2365)),
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
                    BoxApp.contractTransfer((tx) {
                      showFlushSucess(context);
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
                                style: TextStyle(color: Color(0xFFFC2365)),
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
                    }, aesDecode, address, "ct_ypGRSB6gEy8koLg6a4WRdShTfRsh9HfkMkxsE2SMCBk3JdkNP", widget.address, _textEditingController.text);
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
}
