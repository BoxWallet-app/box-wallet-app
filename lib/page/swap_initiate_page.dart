import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/allowance_dao.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/swap_coin_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/allowance_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/swap_coin_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../main.dart';
import 'home_page.dart';
import 'home_page_v2.dart';

class SwapInitiatePage extends StatefulWidget {
  @override
  _SwapInitiatePageState createState() => _SwapInitiatePageState();
}

class _SwapInitiatePageState extends State<SwapInitiatePage> {
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();
  String ctBalance = "loading...";

  SwapCoinModel swapCoinModel;
  SwapCoinModelData dropdownValue;
  List<DropdownMenuItem<SwapCoinModelData>> coins = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      //请求获取焦点
      FocusScope.of(context).requestFocus(focusNodeNode);
    });
    _onRefresh();
  }

  void netContractBalance() {
    ctBalance = "loading...";
    ContractBalanceDao.fetch(dropdownValue.ctAddress).then((ContractBalanceModel model) {
      if (model.code == 200) {
        ctBalance = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Future<void> _onRefresh() async {
    SwapCoinDao.fetch().then((SwapCoinModel model) {
      if (dropdownValue == null) {
        swapCoinModel = model;
        dropdownValue = model.data[0];
        model.data.forEach((element) {
          final DropdownMenuItem<SwapCoinModelData> item = DropdownMenuItem(
            child: Text(element.name),
            value: element,
          );
          coins.add(item);
        });
        netContractBalance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).swap_title_send,
          style: TextStyle(
            fontSize: 18,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
          focusNodeCompiler.unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 18, top: 0),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_1,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                child: Stack(
                  children: [
                    Container(
                      height: 40,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                      //边框设置
                      decoration: new BoxDecoration(
                        color: Color(0xFFf5f5f5),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: _textEditingControllerNode,
                        focusNode: focusNodeNode,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                        ],
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFFeeeeee),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: dropdownValue == null ? S.of(context).swap_text_hint : S.of(context).swap_text_hint + " > " + dropdownValue.lowTokenCount.toString(),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666).withAlpha(85),
                          ),
                        ),
                        cursorColor: Color(0xFFFC2365),
                        cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      child: swapCoinModel == null
                          ? Container()
                          : Container(
                              height: 40,
                              child: DropdownButton<SwapCoinModelData>(
                                underline: Container(),
                                value: dropdownValue,
                                onChanged: (SwapCoinModelData newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                  netContractBalance();
                                },
                                items: coins,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 26, top: 10, right: 26),
                alignment: Alignment.topRight,
                child: Text(
                  S.of(context).token_send_two_page_balance + " : " + ctBalance,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, top: 18),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_2,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 18, right: 18),
                child: Stack(
                  children: [
                    Container(
//                      padding: EdgeInsets.only(left: 10, right: 10),
                      //边框设置
                      height: 40,
                      decoration: new BoxDecoration(
                        color: Color(0xFFf5f5f5),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
//                                          autofocus: true,

                        controller: _textEditingControllerCompiler,
                        focusNode: focusNodeCompiler,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                        ],

                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFFeeeeee),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: dropdownValue == null ? S.of(context).swap_text_hint : S.of(context).swap_text_hint + " > " + dropdownValue.lowAeCount.toString(),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666).withAlpha(85),
                          ),
                        ),
                        cursorColor: Color(0xFFFC2365),
                        cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "AE",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 45,
                margin: const EdgeInsets.only(top: 28),
                child:Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    onPressed: () {

//                      clickNext();
                    netSell();
                    },
                    child: Text(
                      S.of(context).swap_send_3,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                    ),
                    color: Color(0xFFFC2365),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, top: 18),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_4,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 8),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_5,
                  style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.5, color: Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void netSell() {
    focusNodeNode.unfocus();
    focusNodeCompiler.unfocus();

    if (ctBalance == "loading...") {
      return;
    }
    var inputTokenBalanceString = _textEditingControllerNode.text;
    if (double.parse(ctBalance) < double.parse(inputTokenBalanceString)) {
      print("111");
      return;
    }
    print("111");
    EasyLoading.show();
    AllowanceDao.fetch(dropdownValue.ctAddress).then((AllowanceModel model) {
      print(model.data.allowance);
      EasyLoading.dismiss(animation: true);
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
                    BoxApp.contractSwapSell((tx) {
                      focusNodeNode.unfocus();
                      focusNodeCompiler.unfocus();
                      showPlatformDialog(
                        context: context,
                        builder: (_) => BasicDialogAlert(
                          title: Text(
                            S.of(context).dialog_send_sucess,
                          ),
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
                                focusNodeNode.unfocus();
                                focusNodeCompiler.unfocus();
                                eventBus.fire(SwapEvent());

                                Navigator.of(context, rootNavigator: true).pop();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }, (error) {
                      print(error.toString());
                      // ignore: missing_return, missing_return
                      showPlatformDialog(
                        context: context,
                        // ignore: missing_return
                        builder: (_) => BasicDialogAlert(
                          title: Text(S.of(context).dialog_hint_check_error),
                          content: Text(Utils.formatSwapV2Hint(error)),
                          actions: <Widget>[
                            BasicDialogAction(
                              // ignore: missing_return
                              title: Text(
                                S.of(context).dialog_conform,
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                                // ignore: missing_return
                              },
                            ),
                          ],
                        ),
                      );
                    }, aesDecode, address, BoxApp.SWAP_CONTRACT, dropdownValue.ctAddress, _textEditingControllerNode.text, _textEditingControllerCompiler.text,model.data.allowance);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    }).catchError((error){
      EasyLoading.dismiss(animation: true);
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
}
