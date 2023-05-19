import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';
import '../main.dart';
import '../manager/wallet_coins_manager.dart';
import '../model/aeternity/wallet_coins_model.dart';
import '../utils/utils.dart';
import '../widget/chain_loading_widget.dart';
import '../widget/pay_password_widget.dart';

typedef ShowPasswordDialogListener = Future Function(String address, String privateKey, String mnemonic, String password);
typedef ShowCopyHashDialogListener = Future Function(bool val);
typedef ShowCommonDialogListener = Future Function(bool val);
typedef ShowSafeDialogListener = Future Function(bool val);

abstract class BaseWidget extends StatefulWidget {}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
  }

  //获取当前用户
  Future<Account> getCurrentAccount() async {
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    return account!;
  }

  //显示确认框
  void showConfirmDialog(String title, String content) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_conform,
                style: TextStyle(
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop(false);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }

  void showHintSafeDialog(String title, String content, ShowSafeDialogListener safeDialogListener) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Material(
          type: MaterialType.transparency, //透明类型
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          onTap: () {
                            Navigator.of(dialogContext, rootNavigator: true).pop(false);
                          },
                          child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: SingleChildScrollView(
                            child: Container(
                              child: Text(
                                content,
                                style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", height: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 120,
                        margin: const EdgeInsets.only(top: 30, bottom: 30),
                        child: TextButton(
                          style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                          child: new Text(
                            S.of(context).dialog_conform,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext, rootNavigator: true).pop(false);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((val) {
      safeDialogListener(val!);
    });
  }

  //显示通用对话框
  void showCommonDialog(BuildContext context, String title, String content, String leftText, String rightText, ShowCommonDialogListener showCommonDialogListener) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
            ),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                leftText,
                style: TextStyle(
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
            ),
            TextButton(
              child: new Text(
                rightText,
                style: TextStyle(
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(false);
              },
            ),
          ],
        );
      },
    ).then((val) {
      showCommonDialogListener(val!);
    });
  }

  //显示复制hash框
  void showCopyHashDialog(BuildContext context, String hash, ShowCopyHashDialogListener showCopyHashDialogListener) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          title: Text(S.current.dialog_hint_hash),
          content: Text(hash),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_copy,
                style: TextStyle(
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
            ),
            TextButton(
              child: new Text(
                S.of(context).dialog_dismiss,
                style: TextStyle(
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(false);
              },
            ),
          ],
        );
      },
    ).then((val) {
      if (val!) {
        if (BoxApp.language == "cn") {
          Clipboard.setData(ClipboardData(text: "https://www.aeknow.org/block/transaction/" + hash + "/380"));
        } else {
          Clipboard.setData(ClipboardData(text: "https://explorer.aeternity.io/transactions/" + hash));
        }
      }
      showCopyHashDialogListener(val);
    });
  }

  //显示广播成功
  void showFlushSucess(BuildContext context, {String title = "", String message = "", bool isDismiss = true}) {
    if (title.isEmpty) {
      title = S.of(context).hint_broadcast_sucess;
    }
    if (message.isEmpty) {
      message = S.of(context).hint_broadcast_sucess_hint;
    }
    Flushbar(
      title: title,
      message: message,
      backgroundGradient: LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
      backgroundColor: Color(0xFFFC2365),
      blockBackgroundInteraction: true,
      icon: Icon(
        Icons.task_alt_outlined,
        size: 28.0,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(5),
      boxShadows: [
        // BoxShadow(
        //   color: Colors.black.withAlpha(80),
        //   offset: Offset(0.0, 2.0),
        //   blurRadius: 30.0,
        // )
      ],
    )..show(context).then((result) {
        if (isDismiss) Navigator.pop(context);
        return result;
      });
  }

  //显示输入密码框
  void showPasswordDialog(BuildContext context, ShowPasswordDialogListener passwordDialogListener) {
    showPasswordAddressDialog(context, false, passwordDialogListener);
  }

  void showPasswordAddressDialog(BuildContext context, isAddressPassword, ShowPasswordDialogListener passwordDialogListener) {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
                isAddressPassword: isAddressPassword,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var mnemonic = await BoxApp.getMnemonic();
                  var signingKey = await BoxApp.getSigningKey();
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  signingKey = Utils.aesDecode(signingKey, key);
                  mnemonic = Utils.aesDecode(mnemonic, key);
                  var account = await WalletCoinsManager.instance.getCurrentAccount();
                  if (account?.accountType == AccountType.ADDRESS) {
                    var isValidation = await WalletCoinsManager.instance.validationAddressPassword(password);
                    if (!isValidation) {
                      showConfirmDialog(S.of(context).dialog_hint_check_error_content, S.of(context).dialog_hint_check_error);
                      return;
                    }
                  } else {
                    if (signingKey == "") {
                      showConfirmDialog(S.of(context).dialog_hint_check_error_content, S.of(context).dialog_hint_check_error);
                      return;
                    }
                  }
                  passwordDialogListener(address, signingKey!, mnemonic!, password);
                  return;
                },
              ),
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Container();
        });
    return;
  }

  //显示链上操作框
  void showToast(msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
  }

  bool isChainShow = false;

  //显示链上操作框
  void showChainLoading(String content) {
    if (!isChainShow) {
      isChainShow = true;
      showGeneralDialog(
          useRootNavigator: true,
          context: context,
          barrierDismissible: true,
          barrierLabel: "",
          transitionDuration: Duration(milliseconds: 0),
          transitionBuilder: (_, anim1, anim2, child) {
            return ChainLoadingWidget(content);
          },
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Container();
          });
    }
  }

  void dismissChainLoading() {
    if (isChainShow) {
      isChainShow = false;
      navigatorKey.currentState!.pop();
    }
  }
}
