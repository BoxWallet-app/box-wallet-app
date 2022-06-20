import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';

typedef SelectChainPageCallBackFuture = Future? Function(ChainsModel);

class SelectChainPage extends StatefulWidget {
  final int? type;
  final SelectChainPageCallBackFuture? selectChainPageCallBackFuture;

  const SelectChainPage({Key? key, this.type, this.selectChainPageCallBackFuture}) : super(key: key);

  @override
  _SelectChainPageState createState() => _SelectChainPageState();
}

class _SelectChainPageState extends State<SelectChainPage> {
  late List<ChainsModel> chains;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chains = WalletCoinsManager.instance.getChains();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(0),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
                highlightColor: Colors.transparent,
                radius: 0.0,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                )),
            Material(
              color: Colors.transparent.withAlpha(0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: ShapeDecoration(
                  // color: Color(0xffffffff),
                  // color: Color(0xFFfafafa),
                  color: Color(0xFFfafbfc),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 52,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 52,
                                  width: 52,
                                  padding: EdgeInsets.all(15),
                                  child: Icon(
                                    Icons.close,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              height: 52,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(
                                getTitleText(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 1,
                    //   color: Color(0xFFfafbfc),
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                       S.of(context).select_chain_page_select_chain,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xFFfafbfc),
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: Container(
                            color: Color(0xFFfafbfc),
                            // height: MediaQuery.of(context).size.height * 0.75 - 52,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemCount: chains.length,
                              itemBuilder: (context, index) {
                                return itemCoin(context,index);
                              },
                              padding: EdgeInsets.all(10),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Container(
                    //   margin: const EdgeInsets.only(top: 16, bottom: 0),
                    //   child: Container(
                    //     height: 40,
                    //     width: MediaQuery.of(context).size.width - 32,
                    //     child: FlatButton(
                    //       onPressed: () {
                    //         Navigator.pop(context); //关闭对话框
                    //       },
                    //       color: Color(0xFFFC2365),
                    //       textColor: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(30)),
                    //     ),
                    //   ),
                    // ),
//          Text(text),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTitleText() {
    switch (widget.type) {
      case 0:
        return  S.of(context).select_chain_page_create_wallet;
      case 1:
        return  S.of(context).select_chain_page_select_chain;
      case 2:
        return  S.of(context).select_chain_page_add_chain;
    }
    return  S.of(context).select_chain_page_select_chain;
  }

  Widget itemCoin(BuildContext context,int index) {
    return Container(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            switch (widget.type) {
              case 0:
                if (chains[index].name == "AE") {
                  createAe();
                }
                if (chains[index].name == "CFX") {
                  createCFX();
                }

                break;
              case 1:
                Navigator.of(context).pop();
                if (widget.selectChainPageCallBackFuture != null) widget.selectChainPageCallBackFuture!(chains[index]);


                break;
              case 2:
                if (widget.selectChainPageCallBackFuture != null) widget.selectChainPageCallBackFuture!(chains[index]);

                Navigator.of(context).pop();
                break;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 0),
                child: ClipOval(
                  child: Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFfafbfc), width: 1.0), top: BorderSide(color: Color(0xFFfafbfc), width: 1.0), left: BorderSide(color: Color(0xFFfafbfc), width: 1.0), right: BorderSide(color: Color(0xFFfafbfc), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(36.0),
                      image: DecorationImage(
                        image: AssetImage("images/" + chains[index].name! + ".png"),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 5,right: 10),
                  child: Text(
                    (BoxApp.language == "cn" ? chains[index].nameFullCN : chains[index].nameFull )!  + "\n(" + chains[index].name! + ")",
                    textAlign:TextAlign.center,
                    style: new TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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

  void createAe() {
    BoxApp.getGenerateSecretKey((address, signingKey, mnemonic) {
      showGeneralDialog(useRootNavigator:false,
          context: context,
          pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
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
                      title: S.of(context).password_widget_set_password,
                      passwordCallBackFuture: (String password) async {
                        WalletCoinsManager.instance.getCoins().then((walletCoinModel) {
                          final key = Utils.generateMd5Int(password + address);
                          var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
                          var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);

                          // walletCoinModel.ae.add(account);
                          WalletCoinsManager.instance.addAccount("AE", "Aeternity", address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, true).then((value) {
                            BoxApp.setSigningKey(signingKeyAesEncode);
                            BoxApp.setMnemonic(mnemonicAesEncode);
                            BoxApp.setAddress(address);
                            Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
                          });
                          return;
                        });
                        return;
                      }),
                ));
          });
      return;
    });
  }

  void createCFX() {
    BoxApp.getGenerateSecretKeyCFX((address, signingKey, mnemonic) {
      showGeneralDialog(useRootNavigator:false,
          context: context,
          pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
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
                      title: S.of(context).password_widget_set_password,
                      passwordCallBackFuture: (String password) async {
                        WalletCoinsManager.instance.getCoins().then((walletCoinModel) {
                          final key = Utils.generateMd5Int(password + address);
                          var signingKeyAesEncode = Utils.aesEncode(signingKey, key);
                          var mnemonicAesEncode = Utils.aesEncode(mnemonic, key);

                          // walletCoinModel.ae.add(account);
                          WalletCoinsManager.instance.addAccount("CFX", "conflux", address, mnemonicAesEncode, signingKeyAesEncode,AccountType.MNEMONIC, true).then((value) {
                            BoxApp.setSigningKey(signingKeyAesEncode);
                            BoxApp.setMnemonic(mnemonicAesEncode);
                            BoxApp.setAddress(address);
                            Navigator.of(super.context).pushNamedAndRemoveUntil("/tab", ModalRoute.withName("/tab"));
                          });
                          return;
                        });
                        return;
                      }),
                ));
          });
      return;
    });
  }
}
