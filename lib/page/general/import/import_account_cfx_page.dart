import 'dart:async';
import 'dart:io';

import 'package:box/config.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/general/scan_page.dart';
import 'package:box/page/general/set_password_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/permission_helper.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ImportAccountCfxPage extends StatefulWidget {
  final String? coinName;
  final String? fullName;
  final String? password;

  const ImportAccountCfxPage({Key? key, this.coinName, this.fullName, this.password = ""}) : super(key: key);

  @override
  _ImportAccountCfxPageState createState() => _ImportAccountCfxPageState();
}

class _ImportAccountCfxPageState extends State<ImportAccountCfxPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      inputPassword(_textEditingController.text.toString(), false);
    });
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
            S.of(context).ImportAccountPage_title1 + " " + widget.fullName! + S.of(context).ImportAccountPage_title2,
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
          actions: <Widget>[
            IconButton(
              splashRadius:40,
              icon: Icon(
                Icons.add_a_photo_outlined,
                color: Color(0xFF000000),
                size: 22,
              ),
              onPressed: () async {


                List<Permission> permissions = [
                  Permission.camera,
                ];
                PermissionHelper.check(permissions, onSuccess: () async {
                  var data;
                  if (Platform.isIOS) {
                    data = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()));
                  } else {
                    data = await Navigator.push(context, SlideRoute(ScanPage()));
                  }
                  if(data == null|| data==""){
                    return;
                  }
                  inputPassword(data, true);
                }, onFailed: () {
                  EasyLoading.showToast(S.of(context).hint_error_camera_permissions);
                }, onOpenSetting: () {
                  openAppSettings();
                });


                // Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
                // if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {

                // } else {
                //   EasyLoading.showToast(S.of(context).hint_error_camera_permissions);
                // }
              },
            ),
          ],

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
                  // Directly use inside yoru [TabBar]
                  DefaultTabController(
                    length: 3,
                    initialIndex: 0,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          tabIndex = index;
                        });

                        updateDevText();
                        _textEditingController.value = TextEditingValue(text: _textEditingController.text, selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length)));
                      },
                      tabs: [
                        Tab(
                          text: S.of(context).ImportAccountPage_group1,
                        ),
                        Tab(
                          text: S.of(context).ImportAccountPage_group2,
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
                        topLeftRadius: 8,
                        topRightRadius: 8,
                        bottomLeftRadius: 8,
                        bottomRightRadius: 8,
                        horizontalPadding: 50,
                        tabPosition: TabPosition.bottom,
                      ),
                    ),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(color: Color(0xFFedf3f7), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: TextField(
                              controller: _textEditingController,
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
                                  height: 30,
                                  margin: const EdgeInsets.only(left: 18, right: 25, bottom: 18),
                                  child: FlatButton(
                                    onPressed: () async {
                                      ClipboardData data = await (Clipboard.getData(Clipboard.kTextPlain) as FutureOr<ClipboardData>);
                                      _textEditingController.text = data.text!;
                                      _textEditingController.value = TextEditingValue(text: data.text!, selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: data.text!.length)));
                                    },
                                    child: Text(
                                      S.of(context).ImportAccountPage_copy,
                                      style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFC2365)),
                                    ),
                                    color: Color(0xFFFC2365).withAlpha(16),
                                    textColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
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
          )),
        ));
  }

  inputPassword(String data, bool isQR) {
    if (data == "") {
      return;
    }
    if (!data.toString().contains("box_")) {
      if (isQR) _textEditingController.text = data.toString();
      return;
    }
    var mnemonic = data.toString().replaceAll("box_", "");
    _textEditingController.text = "";
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return;
        } as Widget Function(BuildContext, Animation<double>, Animation<double>),
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (context, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, 0, 0.0),
              child: Opacity(
                opacity: anim1.value,
                // ignore: missing_return
                child: PayPasswordWidget(
                    title: S.of(context).password_widget_input_password,
                    dismissCallBackFuture: (password) {
                      return;
                    },
                    passwordCallBackFuture: (String password) async {
                      final key = Utils.generateMd5Int(password);
                      var aesDecode = Utils.aesDecode(mnemonic, key);
                      if (aesDecode == "") {
                        showErrorDialog(context, null);
                        return;
                      }
                      _textEditingController.text = aesDecode;
                      clickLogin();
                    }),
              ));
        });
    return;
  }

  void showErrorDialog(BuildContext buildContext, String? content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.of(context).dialog_hint_check_error),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }

  clickLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_textEditingController.text == "") {
      EasyLoading.showToast(S.of(context).account_login_msg, duration: Duration(seconds: 2));
      return;
    }
    var data = _textEditingController.text;

    switch (tabIndex) {
      case 0:
        await createTabMnemonic(data);
        break;
      case 1:
        await createTabPrivateKey(data);
        break;
      case 2:
        await createTabAddress(data);
        break;
    }
  }

  Future<void> createTabPrivateKey(String privateKey) async {
    EasyLoading.show();
    BoxApp.getSecretPrivateCFX((address, signingKey) async {
      EasyLoading.dismiss();
      if (signingKey.isEmpty && address.isEmpty) {
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(S.of(context).dialog_hint),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Text(S.of(context).ImportAccountPage_private_msg),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text(S.of(context).dialog_conform),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
              ],
            );
          },
        ).then((val) {});
      } else {
        if (widget.password!.isEmpty) {
          if (Platform.isIOS) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SetPasswordPage(
                          setPasswordPageCallBackFuture: (password) async {
                            await createPrivateKeyAccount(password, privateKey);
                            return;
                          },
                        )));
          } else {
            Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(SetPasswordPage(
              setPasswordPageCallBackFuture: (password) async {
                await createPrivateKeyAccount(password, privateKey);
                return;
              },
            )));
          }
        } else {
          await createPrivateKeyAccount(widget.password, privateKey);
        }
      }
    }, privateKey);
  }

  Future<void> createTabAddress(String address) async {
    EasyLoading.show();
    BoxApp.getBalanceCFX((balance,decimal) async {
      balance = AmountDecimal.parseUnits(balance, decimal);
      EasyLoading.dismiss();
      if (balance.isEmpty || balance.contains("error")) {
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(S.of(context).dialog_hint),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Text(S.of(context).ImportAccountPage_address_msg),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text(S.of(context).dialog_conform),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
              ],
            );
          },
        ).then((val) {});
      } else {
        if (widget.password!.isEmpty) {
          if (Platform.isIOS) {
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
            Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(SetPasswordPage(
              setPasswordPageCallBackFuture: (password) async {
                await createAddressAccount(password, address);
                return;
              },
            )));
          }
        } else {
          await createAddressAccount(widget.password, address);
        }
      }
    }, address);
  }

  Future<void> createTabMnemonic(String mnemonic) async {
    EasyLoading.show();
    BoxApp.getValidationMnemonic((isSucess) {
      EasyLoading.dismiss();
      if (isSucess) {
        if (widget.password!.isEmpty) {
          if (Platform.isIOS) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SetPasswordPage(
                          setPasswordPageCallBackFuture: (password) async {
                            await createMnemonicAccount(password, mnemonic);
                            return;
                          },
                        )));
          } else {
            Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(SetPasswordPage(
              setPasswordPageCallBackFuture: (password) async {
                await createMnemonicAccount(password, mnemonic);
                return;
              },
            )));
          }
        } else {
          createMnemonicAccount(widget.password, mnemonic);
          return;
        }
      } else {
        showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(S.of(context).dialog_hint),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Text(S.of(context).dialog_hint_mnemonic),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text(S.of(context).dialog_conform),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
              ],
            );
          },
        ).then((val) {});
      }
      return;
    }, mnemonic);
  }

  Future<void> createMnemonicAccount(String? password, String mnemonic) async {
    BoxApp.getSecretKeyCFX((address, signingKey) async {
      if (!await checkAccount(address)) return;
      final key = Utils.generateMd5Int(password! + address);
      var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
      var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);
      await WalletCoinsManager.instance.addChain(widget.coinName, widget.fullName);
      await WalletCoinsManager.instance.addAccount(widget.coinName, widget.fullName, address, mnemonicAesEncode, signingKeyAesEncode, AccountType.MNEMONIC, false);
      switchAddType();
    }, mnemonic);
  }

  Future<void> createPrivateKeyAccount(String? password, String privateKey) async {
    BoxApp.getSecretPrivateCFX((address, signingKey) async {
      if (!await checkAccount(address)) return;
      final key = Utils.generateMd5Int(password! + address);
      var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
      await WalletCoinsManager.instance.addChain(widget.coinName, widget.fullName);
      await WalletCoinsManager.instance.addAccount(widget.coinName, widget.fullName, address, "", signingKeyAesEncode, AccountType.PRIVATE_KEY, false);
      switchAddType();
    }, privateKey);
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
    if (walletCoinModel.coins == null) {
      return true;
    }
    bool isExist = false;
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
    if (widget.password!.isEmpty) {
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
          _textEditingController.text = TEST_MNEMONIC;
          return;
        case 1:
          _textEditingController.text =TEST_CFX_PRIVATE_KEY;
          return;
        case 2:
          _textEditingController.text = TEST_CFX_ADDRESS;
          return;
      }
      _textEditingController.text = "";
    }
  }

  String getInputHintText() {
    switch (tabIndex) {
      case 0:
        return 'memory pool equip lesson limb naive endorse advice lift ...';
      case 1:
        return '0x8c79085c776cce36d9c144...';
      case 2:
        return 'cfx:aamdc4g7d69z916ns7ufcsje58jkr8nx4pkme17dwf';
    }
    return 'memory pool equip lesson limb naive endorse advice lift ...';
  }

  double getInputHeight() {
    switch (tabIndex) {
      case 0:
        return 170;
      case 1:
        return 150;
      case 2:
        return 130;
    }
    return 170;
  }

  String getTitleContent() {
    switch (tabIndex) {
      case 0:
        return S.of(context).ImportAccountPage_group1_content;
      case 1:
        return S.of(context).ImportAccountPage_group2_content;
      case 2:
        return S.of(context).ImportAccountPage_group3_content;
    }
    return "";
  }
}
