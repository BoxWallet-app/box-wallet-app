import 'dart:collection';
import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

typedef CfxTransferConfirmPageCallBackFuture = Future Function(String);

class CfxTransferConfirmPage extends StatefulWidget {
  final CfxTransferConfirmPageCallBackFuture cfxTransferConfirmPageCallBackFuture;

  final LinkedHashMap<String, dynamic> data;

  const CfxTransferConfirmPage({Key key, this.cfxTransferConfirmPageCallBackFuture, this.data}) : super(key: key);

  @override
  _CfxTransferConfirmPageState createState() => _CfxTransferConfirmPageState();
}

class _CfxTransferConfirmPageState extends State<CfxTransferConfirmPage> {
  List<Widget> baseItems = []; //先建一个数组用于存放循环生成的widget
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.data['value'] == null) {
      setData("0.0");
      setState(() {});
    } else {
      BoxApp.toFormatCfx((amount) {
        print(amount);
        setData(amount);

        setState(() {});
        return;
      }, widget.data['value']);
    }
  }

  void setData(String amount) {
    if (widget.data['from'] != null) {
      var from = buildItem("发送方", (widget.data['from']).toString());
      baseItems.add(from);
    }

    if (widget.data['to'] != null) {
      var to = buildItem("接收方", (widget.data['to']).toString());
      baseItems.add(to);
    }

    var text = Text(
      "- " + (double.parse(amount.toString()).toStringAsFixed(4) + " CFX"),
      style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    );
    var cfx = buildItem2("数量", text);
    baseItems.add(cfx);
    var decimal = Decimal.parse('1000000000000000000');
    var decimal2 = Decimal.parse((int.parse(widget.data['gas']).toString()));
        var decimal3 = decimal2/decimal;
    if (widget.data['gas'] != null) {
      var gas = buildItem("手续费", (int.parse(widget.data['gas']).toString() + " drip\n ≈ -" +
          decimal3.toString() + " CFX"));
      baseItems.add(gas);
    }

    if (widget.data['data'] != null) {
      var data = buildItem("输入数据", (widget.data['data']).toString());
      baseItems.add(data);
    }
  }

  void updateData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(0),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
                highlightColor: Colors.transparent,
                radius: 0.0,
                onTap: () {
                  if (widget.cfxTransferConfirmPageCallBackFuture != null) {
                    widget.cfxTransferConfirmPageCallBackFuture("");
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                )),
            Material(
              color: Colors.transparent.withAlpha(0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: ShapeDecoration(
                  // color: Color(0xffffffff),
                  // color: Color(0xFFfafafa),
                  color: Color(0xFFfafbfc),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 52,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  if (widget.cfxTransferConfirmPageCallBackFuture != null) {
                                    widget.cfxTransferConfirmPageCallBackFuture("");
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 52,
                                  width: 52,
                                  padding: EdgeInsets.all(15),
                                  child: Icon(
                                    Icons.close,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              height: 52,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(
                                getTitleText(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        // child: Column(children: items),
                        child: Column(
                          children: [
                            Container(
                              decoration: new BoxDecoration(
                                color: Color(0xFF000000),
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              margin: EdgeInsets.only(left: 18, right: 18),
                              child: Material(
                                child: Column(
                                  children: baseItems,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FlatButton(
                          onPressed: () {
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

                                          if (widget.cfxTransferConfirmPageCallBackFuture != null) {
                                            widget.cfxTransferConfirmPageCallBackFuture(aesDecode);
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            "确 认",
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                          ),
                          color: Color(0xFFFC2365),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                    //
//          Text(text),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Material(
        color: Color(0xFFffffff),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));

            Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      value,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitleText() {
    return "交易详情";
  }

  void createAe() {
    BoxApp.getGenerateSecretKey((address, signingKey, mnemonic) {
      showGeneralDialog(
          context: context,
          pageBuilder: (context, anim1, anim2) {},
          barrierColor: Colors.grey.withOpacity(.4),
          barrierDismissible: true,
          barrierLabel: "",
          transitionDuration: Duration(milliseconds: 400),
          transitionBuilder: (context, anim1, anim2, child) {
            final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
            return Transform(
                transform: Matrix4.translationValues(0.0, 0, 0.0),
                child: Opacity(
                  opacity: anim1.value,
                  // ignore: missing_return
                  child: PayPasswordWidget(
                      title: S.of(context).password_widget_set_password,
                      passwordCallBackFuture: (String password) async {
                        WalletCoinsManager.instance.getCoins().then((walletCoinModel) {
                          final key = Utils.generateMd5Int(password + address);
                          var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
                          var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);

                          // walletCoinModel.ae.add(account);
                          WalletCoinsManager.instance.addAccount("AE", "Aeternity", address, mnemonicAesEncode, signingKeyAesEncode, true).then((value) {
                            BoxApp.setSigningKey(signingKeyAesEncode);
                            BoxApp.setMnemonic(mnemonicAesEncode);
                            BoxApp.setAddress(address);
                            Navigator.of(super.context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
                          });
                          return;
                        });
                        return;
                      }),
                ));
          });
      return;
    });
  }

  void createCFX() {
    BoxApp.getGenerateSecretKeyCFX((address, signingKey, mnemonic) {
      showGeneralDialog(
          context: context,
          pageBuilder: (context, anim1, anim2) {},
          barrierColor: Colors.grey.withOpacity(.4),
          barrierDismissible: true,
          barrierLabel: "",
          transitionDuration: Duration(milliseconds: 400),
          transitionBuilder: (context, anim1, anim2, child) {
            final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
            return Transform(
                transform: Matrix4.translationValues(0.0, 0, 0.0),
                child: Opacity(
                  opacity: anim1.value,
                  // ignore: missing_return
                  child: PayPasswordWidget(
                      title: S.of(context).password_widget_set_password,
                      passwordCallBackFuture: (String password) async {
                        WalletCoinsManager.instance.getCoins().then((walletCoinModel) {
                          final key = Utils.generateMd5Int(password + address);
                          var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
                          var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);

                          // walletCoinModel.ae.add(account);
                          WalletCoinsManager.instance.addAccount("CFX", "conflux", address, mnemonicAesEncode, signingKeyAesEncode, true).then((value) {
                            BoxApp.setSigningKey(signingKeyAesEncode);
                            BoxApp.setMnemonic(mnemonicAesEncode);
                            BoxApp.setAddress(address);
                            Navigator.of(super.context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
                          });
                          return;
                        });
                        return;
                      }),
                ));
          });
      return;
    });
  }

  Widget buildItem2(String key, Widget text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Material(
        color: Color(0xFFffffff),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          child: Container(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(
                  child: Container(alignment: Alignment.centerRight, child: text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
