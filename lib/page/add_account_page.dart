import 'dart:convert';
import 'dart:io';

import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/general/import/import_account_eth_page.dart';
import 'package:box/page/general/select_mnemonic_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'general/create/create_mnemonic_copy_page.dart';
import 'general/import/import_account_ae_page.dart';
import 'general/import/import_account_cfx_page.dart';

typedef AddAccountCallBackFuture = Future? Function();

class AddAccountPage extends BaseWidget {
  final Coin? coin;
  final String? password;
  final AddAccountCallBackFuture? accountCallBackFuture;

   AddAccountPage({Key? key, this.coin, this.password, this.accountCallBackFuture});

  @override
  _SelectChainCreatePathState createState() => _SelectChainCreatePathState();
}

class _SelectChainCreatePathState extends BaseWidgetState<AddAccountPage> {
  var loadingType = LoadingType.finish;
  List<ChainsModel>? chains;
  PriceModel? priceModel;

  bool isOtherAccount = false;

  List<String> mnemonics = [];

  String? mnemonicTemp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chains = WalletCoinsManager.instance.getChains();

    WalletCoinsManager.instance.getCoins().then((walletCoinsModel) async {
      mnemonics.clear();
      for (var i = 0; i < walletCoinsModel.coins!.length; i++) {
        if (widget.coin!.name == walletCoinsModel.coins![i].name) {
          continue;
        }

        for (var j = 0; j < walletCoinsModel.coins![i].accounts!.length; j++) {
          var address = walletCoinsModel.coins![i].accounts![j].address!;
          var prefs = await SharedPreferences.getInstance();
          var mnemonic = prefs.getString((Utils.generateMD5(address + "mnemonic")))!;
          final key = Utils.generateMd5Int(widget.password! + address);

          var mnemonicAesEncode = Utils.aesDecode(mnemonic, key);
          if (mnemonicAesEncode != null && mnemonicAesEncode !=""){
            mnemonics.add(mnemonicAesEncode);
          }
        }
      }
      var prefs = await SharedPreferences.getInstance();

      List<String> result = [];
      result = mnemonics.sublist(0);
      mnemonics.forEach((element) async {
        for (var j = 0; j < widget.coin!.accounts!.length; j++) {
          var address = widget.coin!.accounts![j].address!;
          var mnemonic = prefs.getString((Utils.generateMD5(address + "mnemonic")))!;
          final key = Utils.generateMd5Int(widget.password! + address);

          var mnemonicAesEncode = Utils.aesDecode(mnemonic, key);
          if (mnemonicAesEncode == element) {
            result.remove(element);
          }
        }
      });
      var set = new Set<String>(); //用set进行去重
      set.addAll(result);//把数组塞进set里
      mnemonics = set.toList();
      if (mnemonics.length != 0) {
        isOtherAccount = true;
      }

      setState(() {});
    });

    eventBus.on<AddNewAccount>().listen((event) {
      createChain();
    });

    eventBus.on<AddImportAccount>().listen((event) {
      checkSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).AddAccountPage_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
      ),
      body: CupertinoPageScaffold(
        child: LoadingWidget(
          type: loadingType,
          onPressedError: () {},
          child: Column(
            children: [
              Expanded(
                child: EasyRefresh(
                  header: BoxHeader(),
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
                          margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                          child: Text(
                            S.of(context).AddAccountPage_title_2,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withAlpha(180),
                              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              onTap: () {
                                EasyLoading.show();
                                var params = {
                                  "name": "aeGenerateAccount",
                                };
                                var channelJson = json.encode(params);
                                BoxApp.sdkChannelCall((result) {
                                  EasyLoading.dismiss(animation: true);
                                  final jsonResponse = json.decode(result);
                                  if (jsonResponse["name"] != params['name']) {
                                    return;
                                  }
                                  logger.info(jsonResponse["result"]["mnemonic"]);
                                  logger.info(jsonResponse["result"]["publicKey"]);
                                  logger.info(jsonResponse["result"]["secretKey"]);
                                  mnemonicTemp = jsonResponse["result"]["mnemonic"];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateMnemonicCopyPage(
                                            mnemonic: jsonResponse["result"]["mnemonic"],
                                            type: CreateMnemonicCopyPage.add,
                                          )));
                                  return;
                                }, channelJson);

                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width - 36,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(top: 0, left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  decoration: BoxDecoration(
//                                                      shape: BoxShape.rectangle,
                                                      ),
                                                  child: ClipOval(
                                                    child: Container(
                                                      width: 45.0,
                                                      height: 45.0,
                                                      decoration: BoxDecoration(
//                                                      shape: BoxShape.rectangle,
                                                        image: DecorationImage(
                                                          image: AssetImage("images/account_create.png"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                                  child: Text(
                                                    S.of(context).AddAccountPage_create,
                                                    style: new TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              onTap: () {
                                // setState(() {
                                //   chains[index].isSelect = !chains[index].isSelect;
                                // });
                                if (widget.coin!.name == "AE") {
                                  if (Platform.isIOS) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImportAccountAePage(
                                              coinName: widget.coin!.name,
                                              fullName: widget.coin!.fullName,
                                              password: widget.password,
                                            )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        SlideRoute(ImportAccountAePage(
                                          coinName: widget.coin!.name,
                                          fullName: widget.coin!.fullName,
                                          password: widget.password,
                                        )));
                                  }
                                  return;
                                }
                                if (widget.coin!.name == "CFX") {
                                  if (Platform.isIOS) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImportAccountCfxPage(
                                              coinName: widget.coin!.name,
                                              fullName: widget.coin!.fullName,
                                              password: widget.password,
                                            )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        SlideRoute(ImportAccountCfxPage(
                                          coinName: widget.coin!.name,
                                          fullName: widget.coin!.fullName,
                                          password: widget.password,
                                        )));
                                  }
                                  return;
                                }
                                if (widget.coin!.name == "BNB"||widget.coin!.name == "OKT"||widget.coin!.name == "HT"|| widget.coin!.name == "ETH") {
                                  if (Platform.isIOS) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImportAccountEthPage(
                                              coinName: widget.coin!.name,
                                              fullName: widget.coin!.fullName,
                                              password: widget.password,
                                            )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        SlideRoute(ImportAccountEthPage(
                                          coinName: widget.coin!.name,
                                          fullName: widget.coin!.fullName,
                                          password: widget.password,
                                        )));
                                  }
                                  return;
                                }
                                return;

                                // if (Platform.isIOS) {
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => ImportAccountCommonPage(
                                //    type: CreateMnemonicCopyPage.ADD,
                                //    accountLoginCallBackFuture: (mnemonic) {
                                //      mnemonicTemp = mnemonic;
                                //      createChain();
                                //      return;
                                //    },
                                //  )));
                                // } else {
                                //   Navigator.push(
                                //       context,
                                //       SlideRoute(ImportAccountCommonPage(
                                //         type: CreateMnemonicCopyPage.ADD,
                                //         accountLoginCallBackFuture: (mnemonic) {
                                //           mnemonicTemp = mnemonic;
                                //           createChain();
                                //           return;
                                //         },
                                //       )));
                                // }

                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width - 36,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(top: 0, left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  decoration: BoxDecoration(),
                                                  child: ClipOval(
                                                    child: Container(
                                                      width: 45.0,
                                                      height: 45.0,
                                                      decoration: BoxDecoration(
//                                                      shape: BoxShape.rectangle,
                                                        image: DecorationImage(
                                                          image: AssetImage("images/account_import.png"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                                  child: Text(
                                                    S.of(context).AddAccountPage_import,
                                                    style: new TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isOtherAccount)
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                            child: Text(
                              S.of(context).AddAccountPage_title_3,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withAlpha(180),
                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                              ),
                            ),
                          ),
                        if (isOtherAccount)
                          Container(
                            margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                            child: Material(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                onTap: () {
                                  // setState(() {
                                  //   chains[index].isSelect = !chains[index].isSelect;
                                  // });

                                  if (Platform.isIOS) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>SelectMnemonicPage(
                                      password: widget.password,
                                      coin: widget.coin,
                                      selectMnemonicCallBackFuture: (mnemonic) {
                                        mnemonicTemp = mnemonic;
                                        createChain();

                                        return;
                                      },
                                    )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        SlideRoute(SelectMnemonicPage(
                                          password: widget.password,
                                          coin: widget.coin,
                                          selectMnemonicCallBackFuture: (mnemonic) {
                                            mnemonicTemp = mnemonic;
                                            createChain();

                                            return;
                                          },
                                        )));
                                  }


                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: MediaQuery.of(context).size.width - 36,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(top: 0, left: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 36.0,
                                                    height: 36.0,
                                                    decoration: BoxDecoration(),
                                                    child: ClipOval(
                                                      child: Container(
                                                        width: 45.0,
                                                        height: 45.0,
                                                        decoration: BoxDecoration(
                                                          border: Border(bottom: BorderSide(color: Color(0xFFfafbfc), width: 1.0), top: BorderSide(color: Color(0xFFfafbfc), width: 1.0), left: BorderSide(color: Color(0xFFfafbfc), width: 1.0), right: BorderSide(color: Color(0xFFfafbfc), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.circular(36.0),
                                                          image: DecorationImage(
                                                            image: AssetImage("images/account_copy.png"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                                    child: Text(
                                                      S.of(context).AddAccountPage_copy,
                                                      style: new TextStyle(
                                                        fontSize: 20,
                                                        color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
      ),
    );
  }

  Future createChain() async {
    if (!mounted) {
      return;
    }
    if (mnemonicTemp == null || widget.password == null) {
      return;
    }

    EasyLoading.show();
    var params = {
      "name": "aeRestoreAccountMnemonic",
      "params": {"mnemonic": mnemonicTemp}
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
      if (!await checkAccount(widget.coin!.name,address)) return;

      final key = Utils.generateMd5Int(widget.password! + address);
      var signingKeyAesEncode = Utils.aesEncode(secretKey, key);
      var mnemonicAesEncode = Utils.aesEncode(mnemonicTemp!, key);

      await WalletCoinsManager.instance.addChain(widget.coin!.name, widget.coin!.fullName);
      await WalletCoinsManager.instance.addAccount(widget.coin!.name, widget.coin!.fullName, address, mnemonicAesEncode, signingKeyAesEncode, AccountType.MNEMONIC,false);
      checkSuccess();

      return;
    }, channelJson);
  }

  Future<bool> checkAccount(String? name,String address) async {
    var walletCoinModel = await WalletCoinsManager.instance.getCoins();
    bool isExist = false;
    if(walletCoinModel.coins == null){
      return true;
    }
    for (var i = 0; i < walletCoinModel.coins!.length; i++) {
      if(name == walletCoinModel.coins![i].name){
        for (var j = 0; j < walletCoinModel.coins![i].accounts!.length; j++) {
          if (walletCoinModel.coins![i].accounts![j].address == address) {
            isExist = true;
          }
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

  void checkSuccess() {
    Navigator.of(super.context).pop();
    if (widget.accountCallBackFuture != null) {
      widget.accountCallBackFuture!();
    }
    EasyLoading.dismiss(animation: true);
  }
}
