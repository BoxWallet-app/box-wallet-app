import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SelectMnemonicCallBackFuture = Future Function(String);

class SelectMnemonicPage extends StatefulWidget {
  final String password;
  final Coin coin;
  final SelectMnemonicCallBackFuture selectMnemonicCallBackFuture;

  const SelectMnemonicPage({Key key, this.password, this.coin, this.selectMnemonicCallBackFuture}) : super(key: key);

  @override
  _SelectMnemonicPathState createState() => _SelectMnemonicPathState();
}

class _SelectMnemonicPathState extends State<SelectMnemonicPage> {
  var loadingType = LoadingType.finish;
  List<String> mnemonics = List();
  PriceModel priceModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WalletCoinsManager.instance.getCoins().then((walletCoinsModel) async {
      mnemonics.clear();
      for (var i = 0; i < walletCoinsModel.coins.length; i++) {
        if (widget.coin.name == walletCoinsModel.coins[i].name) {
          continue;
        }

        for (var j = 0; j < walletCoinsModel.coins[i].accounts.length; j++) {
          var address = walletCoinsModel.coins[i].accounts[j].address;

          var prefs = await SharedPreferences.getInstance();
          var mnemonic = prefs.getString((Utils.generateMD5(address + "mnemonic")));
          final key = Utils.generateMd5Int(widget.password + address);

          var mnemonicAesEncode = Utils.aesDecode(mnemonic, key);
          if (mnemonicAesEncode != null && mnemonicAesEncode !="") mnemonics.add(mnemonicAesEncode);
        }
      }
      var prefs = await SharedPreferences.getInstance();

      List<String> result = [];
      result = mnemonics.sublist(0);
      mnemonics.forEach((element) async {
        for (var j = 0; j < widget.coin.accounts.length; j++) {
          var address = widget.coin.accounts[j].address;
          var mnemonic = prefs.getString((Utils.generateMD5(address + "mnemonic")));
          final key = Utils.generateMd5Int(widget.password + address);

          var mnemonicAesEncode = Utils.aesDecode(mnemonic, key);
          if (mnemonicAesEncode == element) {
            print("delete:"+mnemonicAesEncode);
            result.remove(element);
          }
        }
      });
      mnemonics = result;
      setState(() {});
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
          S.of(context).SelectMnemonicPage_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {},
        child: Column(
          children: [
            Expanded(
              child: EasyRefresh(
                header: BoxHeader(),
                child: ListView.builder(
                  itemCount: mnemonics.length + 1,
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
          ],
        ),
      ),
    );
  }

  Widget itemListView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: Text(
          S.of(context).SelectMnemonicPage_title2,
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
        color: Color(0xFFedf3f7),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Navigator.of(context).pop();
            if (widget.selectMnemonicCallBackFuture != null) {
              widget.selectMnemonicCallBackFuture(mnemonics[index]);
            }
          },
          child: Container(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 36,
                  decoration: BoxDecoration(border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 15),
                        child: Row(
                          children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 10, bottom: 15, right: 10, left: 10),
                                child: Text(
                                  getMnemonicContent(mnemonics[index], index),
                                  style: new TextStyle(
                                    fontSize: 20,
                                    height: 1.5,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
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

  String getMnemonicContent(String mnemonic, int index) {
    var list = mnemonic.split(" ");
    return list[0] + " " + list[1] + " " + list[2] + " " + list[3] + " * * * * " + list[list.length - 4] + " " + list[list.length - 3] + list[list.length - 2] + list[list.length - 1];
  }
}
