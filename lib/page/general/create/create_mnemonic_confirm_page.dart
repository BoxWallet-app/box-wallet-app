import 'dart:convert';
import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_tab_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/general/set_password_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'create_mnemonic_copy_page.dart';

class CreateMnemonicConfirmPage extends BaseWidget {
  final String? mnemonic;
  final int? type;

  CreateMnemonicConfirmPage({Key? key, this.mnemonic, this.type});

  @override
  _AccountRegisterPageState createState() => _AccountRegisterPageState();
}

class _AccountRegisterPageState extends BaseWidgetState<CreateMnemonicConfirmPage> {
  var mnemonicWord = Map<String?, bool>();
  var childrenFalse = <Widget>[];
  var childrenTrue = <Widget>[];
  var childrenWordTrue = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List mnemonicList = widget.mnemonic!.split(" ");
    if (!BoxApp.isDev()) {
      mnemonicList.shuffle();
    }

    for (var i = 0; i < mnemonicList.length; i++) {
      mnemonicWord[mnemonicList[i] + "_" + i.toString()] = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFfafbfc),
        appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          centerTitle: true,
          elevation: 0,
          title: Text(
            S.of(context).mnemonic_confirm_title,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 18,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            ),
          ),
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(
                    S.of(context).mnemonic_confirm_content,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(color: Color(0xFFedf3f7), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10, //主轴上子控件的间距
                        runSpacing: 10, //交叉轴上子控件之间的间距
                        children: childrenTrue,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 28, right: 28, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    spacing: 10, //主轴上子控件的间距
                    runSpacing: 10, //交叉轴上子控件之间的间距
                    children: childrenFalse,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextButton(
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                      onPressed: () {
                        if (childrenWordTrue.toString() == widget.mnemonic!.split(" ").toString()) {
                          if (widget.type == CreateMnemonicCopyPage.login) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetPasswordPage(
                                          mnemonic: widget.mnemonic,
                                          setPasswordPageCallBackFuture: (password) async {
                                            aeRestoreAccountMnemonic(widget.mnemonic, password);
                                            return;
                                          },
                                        )));
                          } else {
                            eventBus.fire(AddNewAccount());
                            Navigator.pop(context);
                          }
                          return;
                        }

                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return new AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              title: Text(S.of(context).dialog_save_error),
                              content: Text(S.of(context).dialog_save_error_hint),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text(
                                    S.of(context).dialog_conform,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((val) {});

                        return;
                      },
                      child: Text(
                        S.of(context).dialog_conform,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void aeRestoreAccountMnemonic(mnemonic, password) {
    EasyLoading.show();
    var params = {
      "name": "aeRestoreAccountMnemonic",
      "params": {"mnemonic": mnemonic}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) async {
      EasyLoading.dismiss(animation: true);
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      logger.info(jsonResponse["result"]["mnemonic"]);
      logger.info(jsonResponse["result"]["publicKey"]);
      logger.info(jsonResponse["result"]["secretKey"]);

      var address = jsonResponse["result"]["publicKey"];
      var secretKey = jsonResponse["result"]["secretKey"];
      final key = Utils.generateMd5Int(password! + address);
      var signingKeyAesEncode = Utils.aesEncode(secretKey, key);
      var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic!, key);
      await WalletCoinsManager.instance.addChain("AE", "Aeternity");
      await WalletCoinsManager.instance.addAccount("AE", "Aeternity", address, mnemonicAesEncode, signingKeyAesEncode, AccountType.MNEMONIC, false);

      Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
      return;
    }, channelJson);
  }

  updateData() {
    childrenFalse.clear();

    mnemonicWord.forEach((k, v) {
      if (!v) childrenFalse.add(getItemContainer(k!, false));
    });

    childrenTrue.clear();
    childrenWordTrue.forEach((v) {
      childrenTrue.add(getItemContainer(v, true));
    });
    setState(() {});
  }

  Widget getItemContainer(String item, bool isSelect) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 26,
      child: Material(
        color: Color(0x00000000),
        child: Ink(
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Color(0xFFCCCCCC)), borderRadius: BorderRadius.all(Radius.circular(8))),
          child: InkWell(
            onTap: () {
              if (!isSelect) {
                childrenWordTrue.add(item.split("_")[0]);
              } else {
                childrenWordTrue.remove(item.split("_")[0]);
              }
              mnemonicWord[item] = !isSelect;
              updateData();
            },
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: Text(
                  item.split("_")[0],
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
