import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'aeternity/ae_account_login_page.dart';
import 'aeternity/ae_account_add_page.dart';
import 'aeternity/ae_home_page.dart';

class WalletSelectPage extends StatefulWidget {
  const WalletSelectPage({Key key}) : super(key: key);

  @override
  _WalletSelectPageState createState() => _WalletSelectPageState();
}

class _WalletSelectPageState extends State<WalletSelectPage> {
  WalletCoinsModel walletCoinsModel;
  String coinName;
  int coinIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallet();
  }

  getWallet() {
    WalletCoinsManager.instance.getCoins().then((value) {
      walletCoinsModel = value;
      WalletCoinsManager.instance.getCurrentCoin().then((value) {
        coinName = value[0];
        coinIndex = value[1];
        setState(() {});
      });
    });
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
                  color: Color(0xffffffff),
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
                                "钱包",
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
                    Container(
                      height: 1,
                      color: Color(0xFFF5F5F5),
                      width: MediaQuery.of(context).size.width,
                    ),


                    Container(
                      height: MediaQuery.of(context).size.height * 0.75 - 52-1,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xFFfafafa),
                      child: Row(
                        children: [
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: Container(
                              color: Color(0xFFF5F5F5),
                              height: MediaQuery.of(context).size.height * 0.75 - 52,
                              width: 56,
                              child: ListView.builder(
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return itemCoin(index);
                                },
                              ),
                            ),
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 56,
                                  padding: EdgeInsets.only(left: 18),
                                  height: 42,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          getCoinNmae(),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            color: Color(0xFF000000).withAlpha(200),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          onTap: () async {
                                            if (coinIndex != 0) {
                                              showPlatformDialog(
                                                context: context,
                                                builder: (_) => BasicDialogAlert(
                                                  title: Text(
                                                    "功能开发中",
                                                  ),
                                                  content: Text(
                                                    "支持更多公链尽情期待",
                                                    style: TextStyle(
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    BasicDialogAction(
                                                      title: Text(
                                                        "确认",
                                                        style: TextStyle(
                                                          color: Color(0xFFFC2365),
                                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context, rootNavigator: true).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                              return;
                                            }
                                            final result = await showConfirmationDialog<int>(
                                              context: context,
                                              cancelLabel: S.of(context).dialog_dismiss,
                                              actions: [
                                                ...List.generate(
                                                  2,
                                                  (index) => AlertDialogAction(
                                                    label: index == 0 ? '导入' : "创建",
                                                    key: index,
                                                  ),
                                                ),
                                              ],
                                              title: getCoinNmae() + " 钱包",
                                            );
                                            if (result == 0) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AeAccountAddPage(
                                                            accountCallBackFuture: () {
                                                              WalletCoinsManager.instance.getCoins().then((value) {
                                                                walletCoinsModel = value;
                                                                for (var i = 0; i < walletCoinsModel.ae.length; i++) {
                                                                  walletCoinsModel.ae[i].isSelect = false;
                                                                }
                                                                walletCoinsModel.ae[walletCoinsModel.ae.length - 1].isSelect = true;
                                                                BoxApp.setSigningKey(walletCoinsModel.ae[walletCoinsModel.ae.length - 1].signingKey);
                                                                BoxApp.setAddress(walletCoinsModel.ae[walletCoinsModel.ae.length - 1].address);
                                                                WalletCoinsManager.instance.setCoins(walletCoinsModel).then((value) {
                                                                  eventBus.fire(AccountUpdateEvent());
                                                                  Navigator.of(super.context).pop();
                                                                  return;
                                                                });
                                                                return;
                                                              });
                                                              return;
                                                            },
                                                          )));
                                            }
                                            if (result == 1) {
                                              BoxApp.getGenerateSecretKey((address, signingKey, mnemonic) {
                                                showGeneralDialog(
                                                    context: context,
                                                    pageBuilder: (context, anim1, anim2) {},
                                                    barrierColor: Colors.grey.withOpacity(.4),
                                                    barrierDismissible: true,
                                                    barrierLabel: "",
                                                    transitionDuration: Duration(milliseconds: 400),
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
                                                                    var keyAesEncode = Utils.aesEncode(mnemonic, key);

                                                                    Account account = Account();
                                                                    account.signingKey = signingKeyAesEncode;
                                                                    account.address = address;
                                                                    account.mnemonic = keyAesEncode;
                                                                    account.isSelect = true;
                                                                    walletCoinModel.ae.add(account);
                                                                    WalletCoinsManager.instance.setCoins(walletCoinModel).then((value) {
                                                                      BoxApp.setSigningKey(signingKeyAesEncode);
                                                                      BoxApp.setAddress(address);
                                                                      BoxApp.setMnemonic(keyAesEncode);
                                                                      WalletCoinsManager.instance.getCoins().then((value) {
                                                                        walletCoinsModel = value;
                                                                        for (var i = 0; i < walletCoinsModel.ae.length; i++) {
                                                                          walletCoinsModel.ae[i].isSelect = false;
                                                                        }
                                                                        walletCoinsModel.ae[walletCoinsModel.ae.length - 1].isSelect = true;
                                                                        BoxApp.setSigningKey(walletCoinsModel.ae[walletCoinsModel.ae.length - 1].signingKey);
                                                                        BoxApp.setAddress(walletCoinsModel.ae[walletCoinsModel.ae.length - 1].address);
                                                                        BoxApp.setMnemonic(walletCoinsModel.ae[walletCoinsModel.ae.length - 1].mnemonic);
                                                                        WalletCoinsManager.instance.setCoins(walletCoinsModel).then((value) {
                                                                          eventBus.fire(AccountUpdateEvent());
                                                                          Navigator.of(super.context).pop();
                                                                          return;
                                                                        });
                                                                        return;
                                                                      });
                                                                      return;
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
                                Container(
                                  color: Color(0xFFfafafa),
                                  height: MediaQuery.of(context).size.height * 0.75 - 52 -1- 42,
                                  width: MediaQuery.of(context).size.width - 56,
                                  child: ListView.builder(
                                    itemCount: walletCoinsModel == null ? 1 : getCoinAccount().length + 1,
                                    itemBuilder: (context, index) {
                                      return itemAccount(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  String getCoinNmae() {
    if (coinIndex == 0) {
      return "Aeternity";
    }
    if (coinIndex == 1) {
      return "BTC";
    }
    if (coinIndex == 2) {
      return "Ethereum";
    }
    if (coinIndex == 3) {
      return "Bytom";
    }
    return "";
  }

  List<Account> getCoinAccount() {
    if (coinIndex == 0) {
      return walletCoinsModel.ae;
    }
    if (coinIndex == 1) {
      return walletCoinsModel.btc;
    }
    if (coinIndex == 2) {
      return walletCoinsModel.eth;
    }
    if (coinIndex == 3) {
      return walletCoinsModel.btm;
    }
  }

  Widget itemCoin(int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // if (index != 0) {
          // showPlatformDialog(
          //   context: context,
          //   builder: (_) => BasicDialogAlert(
          //     title: Text(
          //       "功能开发中",
          //     ),
          //     content: Text(
          //       "支持更多公链尽情期待",
          //       style: TextStyle(
          //         fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          //       ),
          //     ),
          //     actions: <Widget>[
          //       BasicDialogAction(
          //         title: Text(
          //           "确认",
          //           style: TextStyle(
          //             color: Color(0xFFFC2365),
          //             fontFamily:
          //                 BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          //           ),
          //         ),
          //         onPressed: () {
          //           Navigator.of(context, rootNavigator: true).pop();
          //         },
          //       ),
          //     ],
          //   ),
          // );
          // }
          coinIndex = index;
          setState(() {});
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
              child: ClipOval(
                child: Container(
                  width: 27.0,
                  height: 27.0,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                        top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                        left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(36.0),
                    image: DecorationImage(
                      image: AssetImage(getCoinIcon(index)),
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

  Widget itemAccount(int index) {
    if (walletCoinsModel == null) {
      return Container();
    }
    var coinAccount = getCoinAccount();
    if (coinAccount.length == index) {
      if (coinAccount.length == 0)
        return Container(
          height: 50,
          margin: EdgeInsets.only(left: 18, right: 18),
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              onTap: () {
                if (coinIndex != 0) {
                  showPlatformDialog(
                    context: context,
                    builder: (_) => BasicDialogAlert(
                      title: Text(
                        "功能开发中",
                      ),
                      content: Text(
                        "支持更多公链尽情期待",
                        style: TextStyle(
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                      actions: <Widget>[
                        BasicDialogAction(
                          title: Text(
                            "确认",
                            style: TextStyle(
                              color: Color(0xFFFC2365),
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  //设置四周边框
                  border: new Border.all(
                    width: 1,
                    color: Color(0xFFE51363).withAlpha(200),
                  ),
                  //设置四周边框
                ),
                padding: EdgeInsets.only(left: 18, right: 18),
                margin: const EdgeInsets.only(top: 0),
                child: Text(
                  "添加新账户",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    color: Color(0xFFE51363).withAlpha(200),
                  ),
                ),
              ),
            ),
          ),
        );
      else {
        return Container();
      }
    }
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(left: 18, right: 18, bottom: 10),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                Color(0xFFE51363),
                Color(0xFFFF428F),
              ]),
            ),
          ),
          if (walletCoinsModel.ae[index].address == AeHomePage.address)
            // Positioned(
            //   right: 0,
            //   top: 0,
            //   height: 100,
            //   child: Container(
            //     height: 100,
            //     margin: EdgeInsets.only(left: 18, right: 18),
            //     alignment: Alignment.center,
            //     child: Container(
            //       height: 30,
            //       alignment: Alignment.center,
            //       decoration: new BoxDecoration(
            //         //设置四周圆角 角度
            //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
            //         //设置四周边框
            //         border: new Border.all(
            //           width: 1,
            //           color: Color(0xffffffff).withAlpha(200),
            //         ),
            //         //设置四周边框
            //       ),
            //       padding: EdgeInsets.only(left: 18, right: 18),
            //       margin: const EdgeInsets.only(top: 0),
            //       child: Text(
            //         "切 换",
            //         maxLines: 1,
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            //           color: Color(0xffffffff).withAlpha(200),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              right: 0,
              top: 0,
              height: 100,
              child: Container(
                height: 100,
                margin: EdgeInsets.only(left: 18, right: 18),
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
            child: Container(
              width: 87,
              height: 58,
              child: Image(
                image: AssetImage("images/card_top.png"),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 120,
              height: 46,
              child: Image(
                image: AssetImage("images/card_bottom.png"),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              for (var i = 0; i < walletCoinsModel.ae.length; i++) {
                walletCoinsModel.ae[i].isSelect = false;
              }

              walletCoinsModel.ae[index].isSelect = true;
              BoxApp.setSigningKey(walletCoinsModel.ae[index].signingKey);
              BoxApp.setAddress(walletCoinsModel.ae[index].address);
              WalletCoinsManager.instance.setCoins(walletCoinsModel).then((value) {
                eventBus.fire(AccountUpdateEvent());
                Navigator.of(super.context).pop();
                // Navigator.of(super.context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 18, right: 18, bottom: 16),
              child: Text(Utils.formatHomeCardAccountAddress(walletCoinsModel.ae[index].address),
                  strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffffffff).withAlpha(250),
                      letterSpacing: 1.5,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: walletCoinsModel.ae[index].address));
                  Fluttertoast.showToast(
                      msg: S.of(context).token_receive_page_copy_sucess + ":\n" + walletCoinsModel.ae[index].address,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 18, right: 18, top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("账户-" + (index + 1).toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffffff).withAlpha(200),
                                letterSpacing: 1.3,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        padding: EdgeInsets.all(4),
                        child: Image(
                          width: 36,
                          height: 36,
                          color: Colors.white,
                          image: AssetImage('images/wallet_select_copy.png'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCoinIcon(int index) {
    if (index == 0) {
      return "images/AE.png";
    }
    if (index == 1) {
      return "images/BTC.png";
    }
    if (index == 2) {
      return "images/ETH.png";
    }
    if (index == 3) {
      return "images/BTM.png";
    }
    return "";
  }
}
