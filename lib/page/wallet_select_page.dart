import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'account_login_page.dart';
import 'add_account_page.dart';
import 'home_page_v2.dart';

class WalletSelectPage extends StatefulWidget {
  const WalletSelectPage({Key key}) : super(key: key);

  @override
  _WalletSelectPageState createState() => _WalletSelectPageState();
}

class _WalletSelectPageState extends State<WalletSelectPage> {
  WalletCoinsModel model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallet();
  }

  getWallet() {
    WalletCoinsManager.instance.getCoins().then((value) {
      model = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(0),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Material(
            color: Colors.transparent,
            child: InkWell(onTap: (){
              Navigator.pop(context);
            },child: Container( height: MediaQuery.of(context).size.height * 0.25,  width: MediaQuery.of(context).size.width,)),
          ),
          Material(
            color:   Colors.transparent.withAlpha(0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              margin:
                  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          left: 0,
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
                              "选择账户",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily:
                                    BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.75 - 52,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.75 - 52,
                            width: 52,
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return itemCoin(index);
                              },
                            ),
                          ),
                        ),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.75 - 52,
                            width: MediaQuery.of(context).size.width - 52,
                            child: ListView.builder(
                              itemCount: model == null ? 1 : model.ae.length + 1,
                              itemBuilder: (context, index) {
                                return itemAccount(index);
                              },
                            ),
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
    );
  }

  Widget itemCoin(int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (index != 0) {
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
                        fontFamily:
                            BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
          width: 52.0,
          height: 52.0,
          color: index == 0 ? Colors.black12 : Colors.transparent,
          child: Center(
            child: Container(
              child: ClipOval(
                child: Container(
                  width: 27.0,
                  height: 27.0,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                        top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                        left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                        right:
                            BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
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
    if (model == null) {
      return Container();
    }
    if (model.ae.length == index) {
      return Container(
        height: 50,
        margin: EdgeInsets.only(left: 18, right: 18),
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAccountPage(
                            accountCallBackFuture: () {
                              WalletCoinsManager.instance.getCoins().then((value) {
                                model = value;
                                for (var i = 0; i < model.ae.length; i++) {
                                  model.ae[i].isSelect = false;
                                }

                                model.ae[index].isSelect = true;
                                BoxApp.setSigningKey( model.ae[index].signingKey);
                                BoxApp.setAddress(model.ae[index].address);
                                WalletCoinsManager.instance.setCoins(model).then((value) {
                                  eventBus.fire(AccountUpdateEvent());
                                  Navigator.of(super.context).pop();
                                  return;
                                });
                                return;
                              });
                              return;
                            },
                          )));
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
              gradient:
                  const LinearGradient(begin: Alignment.centerLeft, colors: [
                Color(0xFFE51363),
                Color(0xFFFF428F),
              ]),
            ),
          ),

          Positioned(
            left: 0,
            top: 0,
            child: Container(
              margin: EdgeInsets.only(left: 18, right: 18, top: 10),
              child: Text("账户 - " + (index + 1).toString(),
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffffffff).withAlpha(200),
                      letterSpacing: 1.3,
                      fontFamily:
                          BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
            ),
          ),
          if (model.ae[index].address != HomePageV2.address)
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
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    //设置四周边框
                    border: new Border.all(
                      width: 1,
                      color: Color(0xffffffff).withAlpha(200),
                    ),
                    //设置四周边框
                  ),
                  padding: EdgeInsets.only(left: 18, right: 18),
                  margin: const EdgeInsets.only(top: 0),
                  child: Text(
                    "切 换",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily:
                          BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      color: Color(0xffffffff).withAlpha(200),
                    ),
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
              for (var i = 0; i < model.ae.length; i++) {
                model.ae[i].isSelect = false;
              }

              model.ae[index].isSelect = true;
              BoxApp.setSigningKey( model.ae[index].signingKey);
              BoxApp.setAddress(model.ae[index].address);
              WalletCoinsManager.instance.setCoins(model).then((value) {
                eventBus.fire(AccountUpdateEvent());
                Navigator.of(super.context).pop();
                // Navigator.of(super.context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 18, right: 18, bottom: 18),
              child: Text(
                  Utils.formatHomeCardAccountAddress(model.ae[index].address),
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffffffff).withAlpha(200),
                      letterSpacing: 1.3,
                      fontFamily:
                      BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
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
    return "";
  }
}
