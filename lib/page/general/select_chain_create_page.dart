import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../config.dart';

class SelectChainCreatePage extends StatefulWidget {
  final String mnemonic;
  final String password;

  const SelectChainCreatePage({Key key, this.mnemonic, this.password}) : super(key: key);

  @override
  _SelectChainCreatePathState createState() => _SelectChainCreatePathState();
}

class _SelectChainCreatePathState extends State<SelectChainCreatePage> {
  var loadingType = LoadingType.finish;
  List<ChainsModel> chains;
  PriceModel priceModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chains = WalletCoinsManager.instance.getChains();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).select_chain_page_select_chain,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
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
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {},
        child: Column(
          children: [
            Expanded(
              child: EasyRefresh(
                header: BoxHeader(),
                child: ListView.builder(
                  itemCount: chains.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: itemListView(context, index),
                          ),
                        ));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: FlatButton(
                  onPressed: () async {
                    bool isSelect = false;
                    for (var i = 0; i < chains.length; i++) {
                      if (chains[i].isSelect) {
                        isSelect = true;
                        break;
                      }
                    }
                    if (!isSelect) {
                      EasyLoading.showToast( S.of(context).SelectChainCreatePage_error, duration: Duration(seconds: 1));
                      return;
                    }

                    await WalletCoinsManager.instance.setCoins(null);

                    EasyLoading.show();
                    var value = await WalletCoinsManager.instance.getCoins();

                    await createChain();


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
      ),
    );
  }

  Future createChain() async {
    for (var i = 0; i < chains.length; i++) {
      if (chains[i].isSelect) {
        if (chains[i].name == "AE") {
          BoxApp.getSecretKey((address, signingKey) async {
            final key = Utils.generateMd5Int(widget.password + address);
            var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
            var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic, key);
            await WalletCoinsManager.instance.addChain(chains[i].name,chains[i].nameFull);
            await WalletCoinsManager.instance.addAccount(chains[i].name,chains[i].nameFull, address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, false);
            chains[i].isSelect = false;
            createChain();
          }, widget.mnemonic);
          return;
        }
        if (chains[i].name == "CFX") {
          BoxApp.getSecretKeyCFX((address, signingKey) async {
            final key = Utils.generateMd5Int(widget.password + address);
            var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
            var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic, key);
            await WalletCoinsManager.instance.addChain(chains[i].name,chains[i].nameFull);
            await WalletCoinsManager.instance.addAccount(chains[i].name,chains[i].nameFull, address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, false);
            chains[i].isSelect = false;
            createChain();
          }, widget.mnemonic);
          return;
        }

        if (chains[i].name == "OKT") {
          BoxApp.getSecretKeyETH((address, signingKey) async {
            final key = Utils.generateMd5Int(widget.password + address);
            var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
            var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic, key);
            await WalletCoinsManager.instance.addChain(chains[i].name,chains[i].nameFull);
            await WalletCoinsManager.instance.addAccount(chains[i].name,chains[i].nameFull, address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, false);
            chains[i].isSelect = false;
            createChain();
          }, widget.mnemonic);
          return;
        }
        if (chains[i].name == "BNB") {
          BoxApp.getSecretKeyETH((address, signingKey) async {
            final key = Utils.generateMd5Int(widget.password + address);
            var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
            var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic, key);
            await WalletCoinsManager.instance.addChain(chains[i].name,chains[i].nameFull);
            await WalletCoinsManager.instance.addAccount(chains[i].name,chains[i].nameFull, address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, false);
            chains[i].isSelect = false;
            createChain();
          }, widget.mnemonic);
          return;
        }
        if (chains[i].name == "HT") {
          BoxApp.getSecretKeyETH((address, signingKey) async {
            final key = Utils.generateMd5Int(widget.password + address);
            var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
            var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic, key);
            await WalletCoinsManager.instance.addChain(chains[i].name,chains[i].nameFull);
            await WalletCoinsManager.instance.addAccount(chains[i].name,chains[i].nameFull, address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, false);
            chains[i].isSelect = false;
            createChain();
          }, widget.mnemonic);
          return;
        }
        if (chains[i].name == "ETH") {
          BoxApp.getSecretKeyETH((address, signingKey) async {
            final key = Utils.generateMd5Int(widget.password + address);
            var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
            var mnemonicAesEncode = Utils.aesEncode(widget.mnemonic, key);
            await WalletCoinsManager.instance.addChain(chains[i].name,chains[i].nameFull);
            await WalletCoinsManager.instance.addAccount(chains[i].name,chains[i].nameFull, address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, false);
            chains[i].isSelect = false;
            createChain();
          }, widget.mnemonic);
          return;
        }
      }
    }
    checkSuccess();
  }



  Widget itemListView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: Text(
          S.of(context).SelectChainCreatePage_select_chain,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withAlpha(180),
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
      );
    }
    index = index - 1;
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            setState(() {
              chains[index].isSelect = !chains[index].isSelect;
            });
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
//                            buildTypewriterAnimatedTextKit(),

                            Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: Container(
                                  width: 45.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFfafbfc), width: 1.0), top: BorderSide(color: Color(0xFFfafbfc), width: 1.0), left: BorderSide(color: Color(0xFFfafbfc), width: 1.0), right: BorderSide(color: Color(0xFFfafbfc), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(36.0),
                                    image: DecorationImage(
                                      image: AssetImage("images/" + chains[index].name + ".png"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  chains[index].nameFull + " (" + chains[index].name + ")",
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: new TextStyle(
                                    fontSize: 20,

                                    color: Color(0xff333333),

//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Image(
                                width: 22,
                                height: 22,
                                image: AssetImage(chains[index].isSelect ? "images/check_box_select.png" : "images/check_box_normal.png"),
                              ),
                              margin: const EdgeInsets.only(left: 0.0),
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
    );
  }

  void checkSuccess() {
    for (var i = 0; i < chains.length; i++) {
      if(chains[i].isSelect){
        return;
      }
    }
    EasyLoading.dismiss(animation: true);

    Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
  }
}
