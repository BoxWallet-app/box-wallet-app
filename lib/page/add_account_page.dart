import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_token_add_page.dart';
import 'package:box/page/aeternity/ae_token_record_page.dart';
import 'package:box/page/select_mnemonic_page.dart';
import 'package:box/page/set_password_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../a.dart';
import 'account_login_page.dart';
import 'create_mnemonic_copy_page.dart';
typedef AddAccountCallBackFuture = Future Function();
class AddAccountPage extends StatefulWidget {
  final Coin coin;
  final String password;
  final AddAccountCallBackFuture accountCallBackFuture;
  const AddAccountPage({Key key, this.coin, this.password, this.accountCallBackFuture}) : super(key: key);

  @override
  _SelectChainCreatePathState createState() => _SelectChainCreatePathState();
}

class _SelectChainCreatePathState extends State<AddAccountPage> {
  var loadingType = LoadingType.finish;
  List<ChainsModel> chains;
  PriceModel priceModel;

  bool isOtherAccount = false;

  List<String> mnemonics = List();

  String mnemonicTemp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chains = WalletCoinsManager.instance.getChains();



    WalletCoinsManager.instance.getCoins().then((walletCoinsModel) async {
      mnemonics.clear();
      var prefs = await SharedPreferences.getInstance();
      for (var i = 0; i < walletCoinsModel.coins.length; i++) {
        if(widget.coin.name == walletCoinsModel.coins[i].name){
          continue;
        }

        for (var j = 0; j < walletCoinsModel.coins[i].accounts.length; j++) {
          var address =walletCoinsModel.coins[i].accounts[j].address;

          var mnemonic = prefs.getString((Utils.generateMD5(address + "mnemonic")));
          final key = Utils.generateMd5Int(widget.password +  address);

          var mnemonicAesEncode = Utils.aesDecode(mnemonic, key);

          mnemonics.add(mnemonicAesEncode);
        }
      }
      for (var i = 0; i < mnemonics.length; i++) {
        for (var j = 0; j < widget.coin.accounts.length; j++) {
          var address =widget.coin.accounts[j].address;

          var mnemonic = prefs.getString((Utils.generateMD5(address + "mnemonic")));
          final key = Utils.generateMd5Int(widget.password +  address);

          var mnemonicAesEncode = Utils.aesDecode(mnemonic, key);
          if(mnemonicAesEncode == mnemonics[i]){
            print("重复了"+mnemonicAesEncode);
            mnemonics.remove(mnemonicAesEncode);

          }
        }
      };
      print(mnemonics);
      if(mnemonics.length!=0){
        isOtherAccount = true;
      }

      setState(() {

      });
    });


    eventBus.on<AddAccount>().listen((event) {
     createChain();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "添加新账户",
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
                        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                        child: Text(
                          "你可以用下面几种方式来添加或者创建你的公链下新账户",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withAlpha(180),
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            onTap: () {
                              EasyLoading.show();
                              BoxApp.getGenerateSecretKey((signingKey, address, mnemonic) {
                                mnemonicTemp = mnemonic;
                                EasyLoading.dismiss(animation: true);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMnemonicCopyPage(mnemonic: mnemonic, type: CreateMnemonicCopyPage.ADD)));
                                return;
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
                                                padding: const EdgeInsets.only(left: 18, right: 18),
                                                child: Text(
                                                  "创建新的助记词",
                                                  style: new TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            onTap: () {
                              // setState(() {
                              //   chains[index].isSelect = !chains[index].isSelect;
                              // });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLoginPage(type:CreateMnemonicCopyPage.ADD,accountLoginCallBackFuture: (mnemonic){
                                mnemonicTemp = mnemonic;
                                createChain();
                                return;
                              },)));
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
                                                        image: AssetImage("images/account_import.png"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left: 18, right: 18),
                                                child: Text(
                                                  "使用助记词导入",
                                                  style: new TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                          margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                          child: Text(
                            "或者从其他公链复制过来",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withAlpha(180),
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            ),
                          ),
                        ),
                      if (isOtherAccount)
                        Container(
                          margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              onTap: () {
                                // setState(() {
                                //   chains[index].isSelect = !chains[index].isSelect;
                                // });
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectMnemonicPage(password: widget.password,coin: widget.coin,selectMnemonicCallBackFuture: (mnemonic){


                                  mnemonicTemp = mnemonic;
                                  createChain();


                                  return;
                                },)));
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
                                                  padding: const EdgeInsets.only(left: 18, right: 18),
                                                  child: Text(
                                                    "使用同一套助记词",
                                                    style: new TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
    );
  }

  Future createChain() async {
    if(!mounted){
      return;

    }
    if ( mnemonicTemp == null || widget.password == null) {
      return;
    }














    EasyLoading.show();
    if (widget.coin.name == "AE") {
      BoxApp.getSecretKey((address, signingKey) async {
        print(address);
        print(signingKey);

        if(!await checkAccount(address))return;

        final key = Utils.generateMd5Int(widget.password + address);
        var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
        var mnemonicAesEncode = Utils.aesEncode(mnemonicTemp, key);



        await WalletCoinsManager.instance.addChain(widget.coin.name, widget.coin.fullName);
        await WalletCoinsManager.instance.addAccount(widget.coin.name, widget.coin.fullName, address, mnemonicAesEncode, signingKeyAesEncode, false);
        print("创建AE成功");
        checkSuccess();
      }, mnemonicTemp);
    }
    if (widget.coin.name == "CFX") {
      BoxApp.getSecretKeyCFX((address, signingKey) async {
        print(address);
        print(signingKey);
        if(!await checkAccount(address))return;
        final key = Utils.generateMd5Int(widget.password + address);
        var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
        var mnemonicAesEncode = Utils.aesEncode(mnemonicTemp, key);
        await WalletCoinsManager.instance.addChain(widget.coin.name, widget.coin.fullName);
        await WalletCoinsManager.instance.addAccount(widget.coin.name, widget.coin.fullName, address, mnemonicAesEncode, signingKeyAesEncode, false);
        print("创建CFX成功");
        checkSuccess();
      }, mnemonicTemp);
    }

  }

  Future<bool> checkAccount(String address) async {
    var walletCoinModel = await WalletCoinsManager.instance.getCoins();
    bool isExist = false;
    for (var i = 0; i < walletCoinModel.coins.length; i++) {
      for (var j = 0; j < walletCoinModel.coins[i].accounts.length; j++) {
        if (walletCoinModel.coins[i].accounts[j].address == address) {
          isExist = true;
        }
      }
    }
    if (isExist) {
      EasyLoading.dismiss(animation: true);
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("重复账户"),
            content: Text("钱包已存在该账户"),
            actions: <Widget>[
              TextButton(
                child: new Text(S
                    .of(context)
                    .dialog_conform),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),

            ],
          );
        },
      ).then((val) {
        print(val);
      });

      return false;
    }
    return true;
  }

  void checkSuccess() {
    Navigator.of(super.context).pop();
    if(widget.accountCallBackFuture!=null){
      widget.accountCallBackFuture();
    }
    EasyLoading.dismiss(animation: true);

  }
}