import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../generated/l10n.dart';
import '../main.dart';
import '../manager/wallet_coins_manager.dart';
import '../model/aeternity/wallet_coins_model.dart';
import '../utils/utils.dart';
import '../widget/chain_loading_widget.dart';
import '../widget/pay_password_widget.dart';

typedef ShowPasswordDialogListener = Future Function(String address, String privateKey);
typedef ShowCopyHashDialogListener = Future Function(bool val);

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_conform,
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

  void showCopyHashDialog(BuildContext context, String hash, ShowCopyHashDialogListener showCopyHashDialogListener) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.current.dialog_hint_hash),
          content: Text(hash),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_copy,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
            ),
            TextButton(
              child: new Text(
                S.of(context).dialog_dismiss,
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
        Clipboard.setData(ClipboardData(text: "https://www.aeknow.org/block/transaction/" + hash));
      }
      showCopyHashDialogListener(val);
    });
  }

  //显示广播成功
  void showFlushSucess(BuildContext context) {
    Flushbar(
      title: S.of(context).hint_broadcast_sucess,
      message: S.of(context).hint_broadcast_sucess_hint,
      backgroundGradient: LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
      backgroundColor: Color(0xFFFC2365),
      blockBackgroundInteraction: true,
      icon: Icon(
        Icons.task_alt_outlined,
        size: 28.0,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(80),
          offset: Offset(0.0, 2.0),
          blurRadius: 13.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
        return result;
      });
  }

  void showPasswordDialog(BuildContext context, ShowPasswordDialogListener passwordDialogListener) {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
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
                    showConfirmDialog(S.of(context).dialog_hint_check_error_content, S.of(context).dialog_hint_check_error);
                    return;
                  }
                  passwordDialogListener(address, aesDecode!);

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

  void showChainLoading() {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          return ChainLoadingWidget();
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Container();
        });
  }
}
