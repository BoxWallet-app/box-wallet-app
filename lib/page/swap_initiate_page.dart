import 'package:box/generated/l10n.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../main.dart';

class SwapInitiatePage extends StatefulWidget {
  @override
  _SwapInitiatePageState createState() => _SwapInitiatePageState();
}

class _SwapInitiatePageState extends State<SwapInitiatePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFeeeeee),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFEEEEEE),
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Ubuntu",
          ),
        ),
        centerTitle: true,

      ),
      body: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 25,
            margin: const EdgeInsets.only(top: 18),
            child: FlatButton(
              onPressed: () {
                // ignore: missing_return
                netSell();
              },
              child: Text(
                "发起",
                maxLines: 1,
                style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
              ),
              color: Color(0xFFE61665).withAlpha(16),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 25,
            margin: const EdgeInsets.only(top: 18),
            child: FlatButton(
              onPressed: () {
                // ignore: missing_return
                netCancel();
              },
              child: Text(
                "取消",
                maxLines: 1,
                style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
              ),
              color: Color(0xFFE61665).withAlpha(16),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),

          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 25,
            margin: const EdgeInsets.only(top: 18),
            child: FlatButton(
              onPressed: () {
                // ignore: missing_return
                netBuy();
              },
              child: Text(
                "兑换",
                maxLines: 1,
                style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
              ),
              color: Color(0xFFE61665).withAlpha(16),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 25,
            margin: const EdgeInsets.only(top: 18),
            child: FlatButton(
              onPressed: () {
                // ignore: missing_return
                netCoins();
              },
              child: Text(
                "查询",
                maxLines: 1,
                style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
              ),
              color: Color(0xFFE61665).withAlpha(16),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 25,
            margin: const EdgeInsets.only(top: 18),
            child: FlatButton(
              onPressed: () {
                // ignore: missing_return
                netCoinsAddress();
              },
              child: Text(
                "查询 address",
                maxLines: 1,
                style: TextStyle(fontSize: 15, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
              ),
              color: Color(0xFFE61665).withAlpha(16),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  void netSell() {
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
                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
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
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_hint,
                        ),
                        content: Text( "SUCESS"),
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
                  }, (error) {
                    print(error);
                    // ignore: missing_return, missing_return
                    showPlatformDialog(
                      context: context,
                      // ignore: missing_return
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            // ignore: missing_return
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
                  }, aesDecode, address,BoxApp.SWAP_CONTRACT , BoxApp.SWAP_CONTRACT_ABC,"1","1");
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void netBuy() {
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
                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
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
                  BoxApp.contractSwapBuy((data) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_hint,
                        ),
                        content: Text( "SUCESS"),
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
                  }, (error) {
                    print(error);
                    // ignore: missing_return, missing_return
                    showPlatformDialog(
                      context: context,
                      // ignore: missing_return
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            // ignore: missing_return
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
                  }, aesDecode, address,BoxApp.SWAP_CONTRACT , BoxApp.SWAP_CONTRACT_ABC,"ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF","1");
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }
  void netCancel() {
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
                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: "Ubuntu",),
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
                  BoxApp.contractSwapCancel((tx) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_hint,
                        ),
                        content: Text( "SUCESS"),
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
                  }, (error) {
                    print(error);
                    // ignore: missing_return, missing_return
                    showPlatformDialog(
                      context: context,
                      // ignore: missing_return
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            // ignore: missing_return
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
                  }, aesDecode, address,BoxApp.SWAP_CONTRACT , BoxApp.SWAP_CONTRACT_ABC);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }


  void netCoins() {
    // ignore: missing_return
    BoxApp.contractSwapGetSwapsIcon((data) {
      print(data);
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text(
            S.of(context).dialog_hint,
          ),
          content: Text( "SUCESS"),
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
    }, (error) {
      print(error);
      // ignore: missing_return, missing_return
      showPlatformDialog(
        context: context,
        // ignore: missing_return
        builder: (_) => BasicDialogAlert(
          title: Text(S.of(context).dialog_hint_check_error),
          content: Text(error),
          actions: <Widget>[
            BasicDialogAction(
              // ignore: missing_return
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
    }, "aec15878c1bf7127ed4435cbe1acbb075042b53fbd4af932d12ad53549cb80106dad60f5449e6bc6e1e4b2711700300f1cf4f68d14fabaa548afc5f8e41358aa", "ak_qJZPXvWPC7G9kFVEqNjj9NAmwMsQcpRu6E3SSCvCQuwfqpMtN",BoxApp.SWAP_CONTRACT ,"ABC");
    showChainLoading();
  }


  void netCoinsAddress() {
    // ignore: missing_return
    BoxApp.contractSwapGetAccountsAddress((data) {
      print(data);
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text(
            S.of(context).dialog_hint,
          ),
          content: Text( "SUCESS"),
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
    }, (error) {
      print(error);
      // ignore: missing_return, missing_return
      showPlatformDialog(
        context: context,
        // ignore: missing_return
        builder: (_) => BasicDialogAlert(
          title: Text(S.of(context).dialog_hint_check_error),
          content: Text(error),
          actions: <Widget>[
            BasicDialogAction(
              // ignore: missing_return
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
    }, "aec15878c1bf7127ed4435cbe1acbb075042b53fbd4af932d12ad53549cb80106dad60f5449e6bc6e1e4b2711700300f1cf4f68d14fabaa548afc5f8e41358aa", "ak_qJZPXvWPC7G9kFVEqNjj9NAmwMsQcpRu6E3SSCvCQuwfqpMtN",BoxApp.SWAP_CONTRACT ,"ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF");
    showChainLoading();
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
