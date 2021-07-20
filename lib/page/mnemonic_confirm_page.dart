import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/page/aeternity/ae_tab_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MnemonicConfirmPage extends StatefulWidget {
  final String mnemonic;

  const MnemonicConfirmPage({Key key, this.mnemonic}) : super(key: key);

  @override
  _AccountRegisterPageState createState() => _AccountRegisterPageState();
}

class _AccountRegisterPageState extends State<MnemonicConfirmPage> {
  var mnemonicWord = Map<String, bool>();
  var childrenFalse = List<Widget>();
  var childrenTrue = List<Widget>();
  var childrenWordTrue = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    String mnemonic = "memory pool equip lesson limb naive endorse advice lift result track gravity track gravity";
//    List mnemonicList = mnemonic.split(" ");
    List mnemonicList = widget.mnemonic.split(" ");
    // mnemonicList.shuffle();
//    mnemonicList.sort((left,right)=>left.compareTo(right));
    for (var i = 0; i < mnemonicList.length; i++) {
      mnemonicWord[mnemonicList[i] + "_" + i.toString()] = false;
    }

    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  S.of(context).mnemonic_confirm_title,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 24,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  S.of(context).mnemonic_confirm_content,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10, //主轴上子控件的间距
                      runSpacing: 10, //交叉轴上子控件之间的间距
                      children: childrenTrue,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  spacing: 10, //主轴上子控件的间距
                  runSpacing: 10, //交叉轴上子控件之间的间距
                  children: childrenFalse,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    onPressed: () {
                      if (childrenWordTrue.toString() == widget.mnemonic.split(" ").toString()) {
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: Text(S.of(context).dialog_save_sucess),
                              content: Text(
                                S.of(context).dialog_save_sucess_hint,
                                style: TextStyle(
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text(
                                    S.of(context).dialog_conform,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((val) {
                          WalletCoinsManager.instance.updateAccountSaveMnemonic(false).then((value) => {Navigator.pop(context)});

                          // Navigator.replace(context,newRoute:CustomRoute(AeTabPage()), oldRoute: CustomRoute(AeTabPage()));
                          // Navigator.of(context).pushNamedAndRemoveUntil("/TabPage", ModalRoute.withName("/TabPage"));
                        });
                        return;
                      }

                      showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: Text(S.of(context).dialog_save_error),
                            content: Text(S.of(context).dialog_save_error_hint),
                            actions: <Widget>[
                              TextButton(
                                child: new Text(
                                  S.of(context).dialog_conform,
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                              ),
                            ],
                          );
                        },
                      ).then((val) {});

                      return;
                    },
                    child: Text(
                      S.of(context).dialog_conform,
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
        ));
  }

  updateData() {
    childrenFalse.clear();

    mnemonicWord.forEach((k, v) {
      if (!v) childrenFalse.add(getItemContainer(k, false));
    });

    childrenTrue.clear();
    childrenWordTrue.forEach((v) {
      childrenTrue.add(getItemContainer(v, true));
    });
    setState(() {});
  }

  Widget getItemContainer(String item, bool isSelect) {
    return Material(
      color: Color(0x00000000),
      child: Ink(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Color(0xFFCCCCCC)), borderRadius: BorderRadius.all(Radius.circular(5))),
        child: InkWell(
//          borderRadius: BorderRadius.all(Radius.circular(5)),
          onTap: () {
            if (!isSelect) {
              childrenWordTrue.add(item.split("_")[0]);
            } else {
              childrenWordTrue.remove(item.split("_")[0]);
            }
            mnemonicWord[item] = !isSelect;
            updateData();
          },
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Container(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: Text(
                item.split("_")[0],
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
