import 'dart:async';
import 'dart:convert';

import 'package:box/config.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/general/set_password_page.dart';
import 'package:box/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ImportAccountAePage extends BaseWidget {
  final String? coinName;
  final String? fullName;
  final String? password;

  ImportAccountAePage({Key? key, this.coinName, this.fullName, this.password});

  @override
  _ImportAccountAePageState createState() => _ImportAccountAePageState();
}

class _ImportAccountAePageState extends BaseWidgetState<ImportAccountAePage> {
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateDevText();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFfafbfc),
        appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          centerTitle: true,
          elevation: 0,
          title: Text(
            S.of(context).ImportAccountPage_title1 + "" + widget.fullName! + S.of(context).ImportAccountPage_title2,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 18,
              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
            ),
          ),
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF000000),
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
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          tabIndex = index;
                        });
                        updateDevText();
                        inputController.value = TextEditingValue(text: inputController.text, selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: inputController.text.length)));
                      },
                      tabs: [
                        Tab(
                          text: S.of(context).ImportAccountPage_group1,
                        ),
                        Tab(
                          text: S.of(context).ImportAccountPage_group3,
                        ),
                      ],
                      labelColor: Colors.black,
                      // add it here
                      indicator: MaterialIndicator(
                        color: Color(0xFFFC2365),
                        height: 3,
                        topLeftRadius: 2,
                        topRightRadius: 2,
                        bottomLeftRadius: 2,
                        bottomRightRadius: 2,
                        horizontalPadding: 80,
                        tabPosition: TabPosition.bottom,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 18),
                    child: Text(
                      getTitleContent(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withAlpha(180),
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      ),
                    ),
                  ),
                  Container(
                    height: getInputHeight(),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: getInputHeight(),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 10),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(color: Color(0xFFedf3f7), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                            child: TextField(
                              controller: inputController,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                              ),
                              maxLines: 14,
                              decoration: InputDecoration(
                                hintText: getInputHintText(),
                                enabledBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000)),
                                ),
// and:
                                focusedBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000)),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 19,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                  color: Colors.black.withAlpha(80),
                                ),
                              ),
                              cursorColor: Color(0xFFFC2365),
                              cursorWidth: 2,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(left: 18, right: 25, bottom: 18),
                                  child: TextButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(20))),
                                    onPressed: () async {
                                      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                                      inputController.text = data!.text!;
                                      inputController.value = TextEditingValue(text: data.text!, selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: data.text!.length)));
                                    },
                                    child: Text(
                                      S.of(context).ImportAccountPage_copy,
                                      style: TextStyle(fontSize: 12, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFC2365)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 50, left: 30, right: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                        onPressed: () {
                          switchLogin();
                        },
                        child: Text(
                          S.of(context).account_login_page_conform,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
  }

  switchLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (inputController.text == "") {
      EasyLoading.showToast(S.of(context).account_login_msg, duration: Duration(seconds: 2));
      return;
    }
    var data = inputController.text;

    switch (tabIndex) {
      case 0:
        await createTabMnemonic(data);
        break;
      case 1:
        await createTabAddress(data);
        break;
    }
  }

  Future<void> createTabAddress(String address) async {
    EasyLoading.show();

    var params = {
      "name": "aeBalance",
      "params": {"address": address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) async {
      EasyLoading.dismiss();
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      if (balance == "0.0") {
        showConfirmDialog(S.of(context).dialog_hint, S.of(context).ImportAccountPage_address_msg);
        return;
      }
      if (widget.password == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetPasswordPage(
                      setPasswordPageCallBackFuture: (password) async {
                        await createAddressAccount(password, address);
                        return;
                      },
                    )));
      } else {
        createAddressAccount(widget.password!, address);
      }
      setState(() {});
      return;
    }, channelJson);

    // AccountInfoDao.fetch(address: address).then((AccountInfoModel model) {
    //   EasyLoading.dismiss();
    //   if (model.code == 200 && model.data!.balance!.isNotEmpty) {
    //     if (widget.password == null) {
    //       if (Platform.isIOS) {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => SetPasswordPage(
    //                       setPasswordPageCallBackFuture: (password) async {
    //                         await createAddressAccount(password, address);
    //                         return;
    //                       },
    //                     )));
    //       } else {
    //         Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(SetPasswordPage(
    //           setPasswordPageCallBackFuture: (password) async {
    //             await createAddressAccount(password, address);
    //             return;
    //           },
    //         )));
    //       }
    //     } else {
    //       createAddressAccount(widget.password, address);
    //     }
    //   } else {
    //     showDialog<bool>(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (BuildContext dialogContext) {
    //         return new AlertDialog(
    //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    //           title: Text(S.of(context).dialog_hint),
    //           content: new SingleChildScrollView(
    //             child: new ListBody(
    //               children: <Widget>[
    //                 Text(S.of(context).ImportAccountPage_address_msg),
    //               ],
    //             ),
    //           ),
    //           actions: <Widget>[
    //             TextButton(
    //               child: new Text(S.of(context).dialog_conform),
    //               onPressed: () {
    //                 Navigator.of(dialogContext).pop(false);
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     ).then((val) {});
    //   }
    // }).catchError((e) {
    //   EasyLoading.dismiss();
    //   showDialog<bool>(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext dialogContext) {
    //       return new AlertDialog(
    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    //         title: Text(S.of(context).dialog_hint),
    //         content: new SingleChildScrollView(
    //           child: new ListBody(
    //             children: <Widget>[
    //               Text(S.of(context).ImportAccountPage_address_msg),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: new Text(S.of(context).dialog_conform),
    //             onPressed: () {
    //               Navigator.of(dialogContext).pop(false);
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   ).then((val) {});
    // });
  }

  Future<void> createTabMnemonic(String mnemonic) async {
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
      if (jsonResponse["code"] != 200) {
        showConfirmDialog(S.of(context).dialog_hint, S.of(context).dialog_hint_mnemonic);
        return;
      }

      logger.info(jsonResponse["result"]["mnemonic"]);
      logger.info(jsonResponse["result"]["publicKey"]);
      logger.info(jsonResponse["result"]["secretKey"]);
      var address = jsonResponse["result"]["publicKey"];
      var secretKey = jsonResponse["result"]["secretKey"];
      if (widget.password == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetPasswordPage(
                      setPasswordPageCallBackFuture: (password) async {
                        await createAccount(password, address, secretKey, mnemonic);
                        return;
                      },
                    )));
      } else {
        await createAccount(widget.password!, address, secretKey, mnemonic);
      }

      return;
    }, channelJson);

    // BoxApp.getValidationMnemonic((isSucess) {
    //   EasyLoading.dismiss();
    //   if (isSucess) {
    //     if (widget.password == null) {
    //       if (Platform.isIOS) {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => SetPasswordPage(
    //                       setPasswordPageCallBackFuture: (password) async {
    //                         await createMnemonicAccount(password, mnemonic);
    //                         return;
    //                       },
    //                     )));
    //       } else {
    //         Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(SetPasswordPage(
    //           setPasswordPageCallBackFuture: (password) async {
    //             await createMnemonicAccount(password, mnemonic);
    //             return;
    //           },
    //         )));
    //       }
    //     } else {
    //       createMnemonicAccount(widget.password, mnemonic);
    //       return;
    //     }
    //   } else {
    //     showDialog<bool>(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (BuildContext dialogContext) {
    //         return new AlertDialog(
    //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    //           title: Text(S.of(context).dialog_hint),
    //           content: new SingleChildScrollView(
    //             child: new ListBody(
    //               children: <Widget>[
    //                 Text(S.of(context).dialog_hint_mnemonic),
    //               ],
    //             ),
    //           ),
    //           actions: <Widget>[
    //             TextButton(
    //               child: new Text(S.of(context).dialog_conform),
    //               onPressed: () {
    //                 Navigator.of(dialogContext).pop(false);
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     ).then((val) {});
    //   }
    //   return;
    // }, mnemonic);
  }

  Future<void> createAccount(String password, address, secretKey, String mnemonic) async {
    if (!await checkAccount(address)) return;
    final key = Utils.generateMd5Int(password + address);
    var signingKeyAesEncode = Utils.aesEncode(secretKey, key);
    var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);
    await WalletCoinsManager.instance.addChain("AE", "Aeternity");
    await WalletCoinsManager.instance.addAccount("AE", "Aeternity", address, mnemonicAesEncode, signingKeyAesEncode, AccountType.MNEMONIC, false);

    Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
  }

  Future<void> createAddressAccount(String? password, String address) async {
    if (!await checkAccount(address)) return;
    final key = Utils.generateMd5Int(password! + address);
    var addressPassword = Utils.aesEncode(address, key);
    await WalletCoinsManager.instance.addChain(widget.coinName, widget.fullName);
    await WalletCoinsManager.instance.setAddressPassword(address, addressPassword);
    await WalletCoinsManager.instance.addAccount(widget.coinName, widget.fullName, address, "", "", AccountType.ADDRESS, false);
    switchAddType();
  }

  Future<bool> checkAccount(String address) async {
    var walletCoinModel = await WalletCoinsManager.instance.getCoins();
    bool isExist = false;
    if (walletCoinModel.coins == null) {
      return true;
    }
    for (var i = 0; i < walletCoinModel.coins!.length; i++) {
      for (var j = 0; j < walletCoinModel.coins![i].accounts!.length; j++) {
        if (walletCoinModel.coins![i].accounts![j].address == address) {
          isExist = true;
        }
      }
    }
    if (isExist) {
      EasyLoading.dismiss(animation: true);
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            title: Text(S.of(context).ImportAccountPage_account_re_error_title),
            content: Text(S.of(context).ImportAccountPage_account_re_error_content),
            actions: <Widget>[
              TextButton(
                child: new Text(S.of(context).dialog_conform),
                onPressed: () {
                  Navigator.of(buildContext).pop(false);
                },
              ),
            ],
          );
        },
      ).then((val) {});

      return false;
    }
    return true;
  }

  void switchAddType() {
    if (widget.password == null) {
      Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
    } else {
      eventBus.fire(AddImportAccount());
      Navigator.pop(context);
    }
  }

  void updateDevText() {
    if (BoxApp.isDev()) {
      switch (tabIndex) {
        case 0:
          inputController.text = TEST_MNEMONIC;
          return;
        case 1:
          inputController.text = TEST_AE_ADDRESS;
          return;
      }
      inputController.text = "";
    }
  }

  String getInputHintText() {
    switch (tabIndex) {
      case 0:
        return 'memory pool equip lesson limb naive endorse advice lift ...';
      case 1:
        return 'ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6q...';
    }
    return 'memory pool equip lesson limb naive endorse advice lift ...';
  }

  double getInputHeight() {
    switch (tabIndex) {
      case 0:
        return 170;
      case 1:
        return 130;
    }
    return 170;
  }

  String getTitleContent() {
    switch (tabIndex) {
      case 0:
        return S.of(context).ImportAccountPage_group1_content;
      case 1:
        return S.of(context).ImportAccountPage_group3_content;
    }
    return "";
  }
}
