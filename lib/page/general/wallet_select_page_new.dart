import 'dart:io';

import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/add_account_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/general/select_chain_page.dart';
import 'package:box/page/general/set_address_name_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../main.dart';

class WalletSelectPageNew extends BaseWidget {
  WalletSelectPageNew({Key? key});

  @override
  _WalletSelectPageNewState createState() => _WalletSelectPageNewState();
}

class _WalletSelectPageNewState extends BaseWidgetState<WalletSelectPageNew> {
  WalletCoinsModel? walletCoinsModel;
  int? coinIndex;
  late int coinLength;
  String? address = "";
  Account? account;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallet();
    getAddress();
  }

  getWallet() {
    coinLength = WalletCoinsManager.instance.getChains().length;
    WalletCoinsManager.instance.getCoins().then((value) {
      walletCoinsModel = value;

      if (coinIndex == null) {
        WalletCoinsManager.instance.getCurrentCoin().then((value) {
          coinIndex = value![1] as int?;
          setState(() {});
        });
      }
      setState(() {});
    });
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? acc) {
      address = acc!.address;
      account = acc;
      if (!mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFfafbfc),
        title: Text(
          S.of(context).select_wallet_page_wallet,
          style: new TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              size: 17,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 18),
              color: Color(0xFFfafbfc),
              height: 42,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      walletCoinsModel == null ? "" : walletCoinsModel!.coins![coinIndex!].fullName!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                        color: Color(0xFF000000).withAlpha(200),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      onTap: () async {
                        // if (coinIndex != 0) {
                        //   return;
                        // }
                        createImportAccount(context);
                      },
                      child: Container(
                        height: 30,
                        width: 60,
                        padding: EdgeInsets.all(4),
                        child: Image(
                          width: 36,
                          height: 36,
                          color: Colors.black,
                          image: AssetImage('images/token_add.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: EasyRefresh(
                child: ListView.builder(
                  itemCount: walletCoinsModel == null ? 1 : walletCoinsModel!.coins![coinIndex!].accounts!.length + 1,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: itemAccount(context, index),
                          ),
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemCoin(int index) {
    if (walletCoinsModel!.coins!.length == index) {
      if (coinLength > walletCoinsModel!.coins!.length) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showMaterialModalBottomSheet(
                  expand: true,
                  context: context,
                  enableDrag: false,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SelectChainPage(
                        type: 2,
                        selectChainPageCallBackFuture: (model) {
                          WalletCoinsManager.instance.addChain(model.name, model.nameFull).then((walletCoinModel) {
                            if (walletCoinModel != null) {
                              this.walletCoinsModel = walletCoinModel;
                              coinIndex = index;
                              setState(() {});
                              return;
                            }
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return new AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  title: new Text(S.of(context).dialog_hint),
                                  content: new SingleChildScrollView(
                                    child: new ListBody(
                                      children: <Widget>[
                                        new Text(S.of(context).dialog_add_wallet_error),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    new TextButton(
                                      child: new Text(S.of(context).dialog_conform),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((val) {
                              if (val!) {}
                            });
                          });
                          return;

                          return;
                        },
                      ));
            },
            child: Container(
              width: 56.0,
              height: 52.0,
              margin: EdgeInsets.all(2),
              decoration: new BoxDecoration(
                color: index == coinIndex ? Colors.black12 : Colors.transparent,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                //设置四周边框
                // border: new Border.all(
                //   width: 1,
                //   color: Color(0xFFE51363).withAlpha(200),
                // ),
                //设置四周边框
              ),
              child: Center(
                child: Container(
                  child: Container(
                    height: 25,
                    width: 25,
                    margin: EdgeInsets.only(left: 4, right: 5),
                    padding: EdgeInsets.all(1),
                    child: Image(
                      width: 36,
                      height: 36,
                      color: Color(0xFF000000).withAlpha(200),
                      image: AssetImage('images/chain_add.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return Container();
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          coinIndex = index;
          setState(() {});
        },
        child: Container(
          width: 56.0,
          height: 52.0,
          margin: EdgeInsets.all(4),
          decoration: new BoxDecoration(
            color: index == coinIndex ? Colors.black12 : Colors.transparent,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //设置四周边框
            // border: new Border.all(
            //   width: 1,
            //   color: Color(0xFFE51363).withAlpha(200),
            // ),
            //设置四周边框
          ),
          child: Center(
            child: Container(
              child: ClipOval(
                child: Container(
                  width: 27.0,
                  height: 27.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(36.0),
                    image: DecorationImage(
                      image: AssetImage("images/" + walletCoinsModel!.coins![index].name! + ".png"),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemAccount(BuildContext context, int index) {
    if (walletCoinsModel == null || account == null) {
      return Container();
    }
    if (index >= walletCoinsModel!.coins![coinIndex!].accounts!.length) {
      return Container(
        height: 50,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: MediaQuery.of(context).padding.bottom + 20),
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            onTap: () {
              createImportAccount(context);
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(5)),
                //设置四周边框
                border: new Border.all(
                  width: 1,
                  color: getCoinColor().withAlpha(200),
                ),
                //设置四周边框
              ),
              padding: EdgeInsets.only(left: 15, right: 15),
              margin: const EdgeInsets.only(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 4, right: 5),
                    padding: EdgeInsets.all(1),
                    child: Image(
                      width: 36,
                      height: 36,
                      color: getCoinColor().withAlpha(200),
                      image: AssetImage('images/wallet_select_account_add.png'),
                    ),
                  ),
                  Text(
                    S.of(context).select_wallet_page_add_account,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      color: getCoinColor().withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Stack(
        children: [
          getCoinBg(),
          if (walletCoinsModel!.coins![coinIndex!].accounts![index].address == address && walletCoinsModel!.coins![coinIndex!].name == account!.coin)
            Positioned(
              right: 0,
              top: 0,
              height: 100,
              child: Container(
                height: 100,
                margin: EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.center,
                child: Container(
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.all(4),
                  child: Image(
                    width: 36,
                    height: 36,
                    color: Colors.white,
                    image: AssetImage('images/wallet_select_confrim.png'),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 0,
            top: 0,
            child: getCardImage(),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: getCardImageBottom(),
          ),
          InkWell(
            onTap: () {
              for (var i = 0; i < walletCoinsModel!.coins!.length; i++) {
                for (var j = 0; j < walletCoinsModel!.coins![i].accounts!.length; j++) {
                  walletCoinsModel!.coins![i].accounts![j].isSelect = false;
                }
              }

              walletCoinsModel!.coins![coinIndex!].accounts![index].isSelect = true;
              WalletCoinsManager.instance.changeAccount(walletCoinsModel, walletCoinsModel!.coins![coinIndex!].accounts![index].address!).then((value) {
                eventBus.fire(AccountUpdateEvent());
                Navigator.of(context).pop();
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 16),
              child: Text(getCoinFormatAddress(index), strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"), style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Color(0xffffffff).withAlpha(220), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto")),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (Platform.isIOS) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SetAddressNamePage(
                                      name: getAccountName(index, context),
                                      address: walletCoinsModel!.coins![coinIndex!].accounts![index].address,
                                      setAddressNamePageCallBackFuture: () {
                                        getWallet();

                                        return;
                                      },
                                    )));
                      } else {
                        Navigator.push(
                            context,
                            SlideRoute(SetAddressNamePage(
                              name: getAccountName(index, context),
                              address: walletCoinsModel!.coins![coinIndex!].accounts![index].address,
                              setAddressNamePageCallBackFuture: () {
                                getWallet();

                                return;
                              },
                            )));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 18, right: 2, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(getAccountName(index, context)!, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400, color: Color(0xffffffff).withAlpha(200), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto")),
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.only(left: 4),
                            padding: EdgeInsets.all(2),
                            child: Image(
                              width: 36,
                              height: 36,
                              color: Color(0xffffffff).withAlpha(200),
                              image: AssetImage('images/wallet_select_edit.png'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: walletCoinsModel!.coins![coinIndex!].accounts![index].address));
                      Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess + ":\n" + walletCoinsModel!.coins![coinIndex!].accounts![index].address!, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 2, right: 6, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            padding: EdgeInsets.all(4),
                            child: Image(
                              width: 36,
                              height: 36,
                              color: Color(0xffffffff).withAlpha(200),
                              image: AssetImage('images/wallet_select_copy.png'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (walletCoinsModel!.coins![coinIndex!].accounts![index].address != address || walletCoinsModel!.coins![coinIndex!].name != account!.coin)
            Positioned(
              right: 0,
              top: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return new AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          title: new Text(S.of(context).dialog_delete_account),
                          content: new SingleChildScrollView(
                            child: new ListBody(
                              children: <Widget>[
                                new Text(S.of(context).dialog_delete_account_msg),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: new Text(S.of(context).dialog_dismiss),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(false);
                              },
                            ),
                            new TextButton(
                              child: new Text(S.of(context).dialog_conform),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    ).then((val) {
                      if (val!) {
                        var removeAddress = walletCoinsModel!.coins![coinIndex!].accounts![index].address;
                        walletCoinsModel!.coins![coinIndex!].accounts!.removeAt(index);

                        WalletCoinsManager.instance.removeAccount(walletCoinsModel, removeAddress).then((value) {
                          getWallet();
                        });
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          padding: EdgeInsets.all(4),
                          child: Image(
                            width: 36,
                            height: 36,
                            color: Color(0xffffffff).withAlpha(200),
                            image: AssetImage('images/wallet_select_delete.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getAccount(walletCoinsModel!.coins![coinIndex!].accounts![index].accountType),
                      style: TextStyle(fontSize: 12, color: Color(0xffffffff).withAlpha(150), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container getCardImageBottom() {
    if (walletCoinsModel!.coins![coinIndex!].name == "BNB") {
      return Container();
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "ETH") {
      return Container();
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "HT") {
      return Container();
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "OKT") {
      return Container();
    }
    return Container(
      width: 120,
      height: 46,
      child: Image(
        image: AssetImage("images/card_bottom.png"),
      ),
    );
  }

  Container getCardImage() {
    if (walletCoinsModel!.coins![coinIndex!].name == "AE") {
      return Container(
        width: 87,
        height: 58,
        child: Image(
          image: AssetImage("images/card_top.png"),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "CFX") {
      return Container(
        width: 87,
        height: 58,
        child: Image(
          image: AssetImage("images/card_top.png"),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "BNB") {
      return Container(
        width: 87,
        height: 58,
        child: Image(
          image: AssetImage("images/ic_main_bnb.png"),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "ETH") {
      return Container(
        width: 87,
        height: 58,
        child: Image(
          image: AssetImage("images/ic_main_eth.png"),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "HT") {
      return Container(
        width: 87,
        height: 58,
        child: Image(
          image: AssetImage("images/ic_main_ht.png"),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "OKT") {
      return Container(
        width: 87,
        height: 58,
        child: Image(
          image: AssetImage("images/ic_main_okt.png"),
        ),
      );
    }
    return Container(
      width: 87,
      height: 58,
      child: Image(
        image: AssetImage("images/card_top.png"),
      ),
    );
  }

  String getAccount(int? accountType) {
    if (accountType == AccountType.ADDRESS) {
      return S.of(context).WalletSelectPage_account_type3;
    }
    if (accountType == AccountType.MNEMONIC) {
      return S.of(context).WalletSelectPage_account_type1;
    }
    if (accountType == AccountType.PRIVATE_KEY) {
      return S.of(context).WalletSelectPage_account_type2;
    }
    return "";
  }

  String? getAccountName(int index, BuildContext context) {
    var name = walletCoinsModel!.coins![coinIndex!].accounts![index].name;
    if (name == null || name == "") {
      return S.of(context).select_wallet_page_add_account_2 + "-" + (index + 1).toString();
    } else {
      return walletCoinsModel!.coins![coinIndex!].accounts![index].name;
    }
  }

  String getCoinFormatAddress(int index) {
    if (walletCoinsModel!.coins![coinIndex!].name == "AE") {
      return Utils.formatHomeCardAccountAddress(walletCoinsModel!.coins![coinIndex!].accounts![index].address);
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "CFX") {
      return Utils.formatHomeCardAccountAddressCFX(walletCoinsModel!.coins![coinIndex!].accounts![index].address);
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "BNB" || walletCoinsModel!.coins![coinIndex!].name == "OKT" || walletCoinsModel!.coins![coinIndex!].name == "HT" || walletCoinsModel!.coins![coinIndex!].name == "ETH") {
      return Utils.formatHomeCardAccountAddressCFX(walletCoinsModel!.coins![coinIndex!].accounts![index].address);
    }
    return "";
  }

  Container getCoinBg() {
    if (walletCoinsModel!.coins![coinIndex!].name == "AE") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFFE51363),
            Color(0xFFFF428F),
          ]),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "CFX") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFF3292C7),
            Color(0xFF37A1DB),
          ]),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "BNB") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFFE1A200),
            Color(0xFFE6A700),
          ]),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "BNB") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFFE1A200),
            Color(0xFFE6A700),
          ]),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "OKT") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFF0062DB),
            Color(0xFF1F94FF),
          ]),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "HT") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFF112FD0),
            Color(0xFF112FD0),
          ]),
        ),
      );
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "ETH") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
            Color(0xFF5F66A3),
            Color(0xFF5F66A3),
          ]),
        ),
      );
    }
    return Container();
  }

  Color getCoinColor() {
    if (walletCoinsModel!.coins![coinIndex!].name == "AE") {
      return Color(0xFFE51363);
    }
    if (walletCoinsModel!.coins![coinIndex!].name == "CFX") {
      return Color(0xFF37A1DB);
    }

    if (walletCoinsModel!.coins![coinIndex!].name == "BNB") {
      return Color(0xFFE1A200);
    }

    if (walletCoinsModel!.coins![coinIndex!].name == "HT") {
      return Color(0xFF112FD0);
    }

    if (walletCoinsModel!.coins![coinIndex!].name == "OKT") {
      return Color(0xFF1F94FF);
    }

    if (walletCoinsModel!.coins![coinIndex!].name == "ETH") {
      return Color(0xFF5F66A3);
    }
    return Color(0xFFE51363);
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
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_conform,
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

  void createImportAccount(BuildContext buildContext) async {
    // ignore: unnecessary_statements
    var coin = walletCoinsModel!.coins![coinIndex!];
    showPasswordAddressDialog(context,true, (address, privateKey, mnemonic, password) async {
      logger.info(address);
      logger.info(privateKey);
      logger.info(mnemonic);
      logger.info(password);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddAccountPage(
                    coin: coin,
                    password: password,
                    accountCallBackFuture: () {
                      eventBus.fire(AccountUpdateEvent());
                      Navigator.of(super.context).pop();
                      return;
                    },
                  )));
    });
    // showGeneralDialog(
    //     useRootNavigator: false,
    //     context: buildContext,
    //     pageBuilder: (context, anim1, anim2) {
    //       return;
    //     } as Widget Function(BuildContext, Animation<double>, Animation<double>),
    //     //barrierColor: Colors.grey.withOpacity(.4),
    //     barrierDismissible: true,
    //     barrierLabel: "",
    //     transitionDuration: Duration(milliseconds: 0),
    //     transitionBuilder: (context, anim1, anim2, child) {
    //       final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
    //       return Transform(
    //           transform: Matrix4.translationValues(0.0, 0, 0.0),
    //           child: Opacity(
    //             opacity: anim1.value,
    //             // ignore: missing_return
    //             child: PayPasswordWidget(
    //                 title: S.of(context).password_widget_input_password,
    //                 isAddressPassword: true,
    //                 passwordCallBackFuture: (String password) async {
    //                   var account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
    //                   if (account.accountType == AccountType.ADDRESS) {
    //                     var isValidation = await WalletCoinsManager.instance.validationAddressPassword(password);
    //                     if (!isValidation) {
    //                       showErrorDialog(context, null);
    //                       return;
    //                     }
    //                   } else {
    //                     var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
    //                     var address = await BoxApp.getAddress();
    //                     final key = Utils.generateMd5Int(password + address);
    //                     var aesDecode = Utils.aesDecode(signingKey, key);
    //                     if (aesDecode == "") {
    //                       showErrorDialog(context, null);
    //                       return;
    //                     }
    //                   }
    //                   if (Platform.isIOS) {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => AddAccountPage(
    //                                   coin: coin,
    //                                   password: password,
    //                                   accountCallBackFuture: () {
    //                                     eventBus.fire(AccountUpdateEvent());
    //                                     Navigator.of(super.context).pop();
    //                                     return;
    //                                   },
    //                                 )));
    //                   } else {
    //                     Navigator.push(
    //                         buildContext,
    //                         SlideRoute(AddAccountPage(
    //                           coin: coin,
    //                           password: password,
    //                           accountCallBackFuture: () {
    //                             eventBus.fire(AccountUpdateEvent());
    //                             Navigator.of(super.context).pop();
    //                             return;
    //                           },
    //                         )));
    //                   }
    //
    //                   return;
    //                 }),
    //           ));
    //     });
    return;
  }
}
