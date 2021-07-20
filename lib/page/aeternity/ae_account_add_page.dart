import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/user_login_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/user_model.dart';
import 'package:box/model/wallet_coins_model.dart';
import 'package:box/page/mnemonic_confirm_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../main.dart';

typedef AddAccountCallBackFuture = Future Function();

class AeAccountAddPage extends StatefulWidget {
  final AddAccountCallBackFuture accountCallBackFuture;

  const AeAccountAddPage({Key key, this.accountCallBackFuture}) : super(key: key);

  @override
  _AeAccountAddPageState createState() => _AeAccountAddPageState();
}

class _AeAccountAddPageState extends State<AeAccountAddPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "";
//    _textEditingController.text = "memory pool equip lesson limb naive endorse advice lift result track gravity";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
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
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                    S.of(context).account_login_page_input_mnemonic,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(
                    S.of(context).account_login_page_input_hint,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextField(
                      controller: _textEditingController,

                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      maxLines: 10,

                      decoration: InputDecoration(
                        hintText: 'memory pool equip lesson limb naive endorse advice lift ...',
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000)),
                        ),
// and:
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000)),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 19,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black.withAlpha(80),
                        ),
                      ),
                      cursorColor: Color(0xFFFC2365),
                      cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 50),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      onPressed: () {
                        clickLogin();
                      },
                      child: Text(
                        S.of(context).account_login_page_conform,
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
          )),
        ));
  }

  clickLogin() {
    if (_textEditingController.text == null || _textEditingController.text == "") {
      return;
    }
    var mnemonic = _textEditingController.text;
    // ignore: missing_return
    BoxApp.getValidationMnemonic((isSucess) {
      if (isSucess) {
        // ignore: missing_return
        BoxApp.getSecretKey((address, signingKey) {
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
                              bool isExist = false;
                              for (var i = 0; i < walletCoinModel.coins.length; i++) {
                                for (var j = 0; j < walletCoinModel.coins[i].accounts.length; j++) {
                                  if (walletCoinModel.coins[i].accounts[j].address == address) {
                                    isExist = true;
                                  }
                                }
                              }
                              if (isExist) {
                                showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return new AlertDialog(
                                      title: Text("重复账户"),
                                      content: Text("钱包已存在该账户"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: new Text(S.of(context).dialog_conform),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),

                                      ],
                                    );
                                  },
                                ).then((val) {
                                  print(val);
                                });
                                return;
                              } else {
                                final key = Utils.generateMd5Int(password + address);
                                var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
                                var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);

                                WalletCoinsManager.instance.addAccount("AE", "Aeternity", address, mnemonicAesEncode, signingKeyAesEncode,false).then((value) {
                                  BoxApp.setSigningKey(signingKeyAesEncode);
                                  BoxApp.setAddress(address);
                                  if (widget.accountCallBackFuture != null) {
                                    widget.accountCallBackFuture();
                                  }
                                  Navigator.of(super.context).pop();
                                  return;
                                });
                              }
                            });
                          }),
                    ));
              });
        }, _textEditingController.text);
      } else {
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text("登录错误"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Text("助记词错误"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text(S.of(context).dialog_conform),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),

              ],
            );
          },
        ).then((val) {
          print(val);
        });
      }
    }, _textEditingController.text);
  }

}
