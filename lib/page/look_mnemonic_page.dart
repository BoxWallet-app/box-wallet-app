import 'dart:io';
import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'box_code_mnemonic_page.dart';

class LookMnemonicPage extends StatefulWidget {
  final String mnemonic;
  final String privateKey;

  const LookMnemonicPage({Key key, this.mnemonic, this.privateKey}) : super(key: key);

  @override
  _SelectMnemonicPathState createState() => _SelectMnemonicPathState();
}

class _SelectMnemonicPathState extends State<LookMnemonicPage> {
  var loadingType = LoadingType.finish;
  List<String> mnemonics = List();
  PriceModel priceModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).LookMnemonicPage_title,
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
        child: EasyRefresh(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                child: Text(
                  S.of(context).LookMnemonicPage_title2,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withAlpha(180),
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              if (widget.mnemonic != "")
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: Text(
                    S.of(context).LookMnemonicPage_group1,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
              if (widget.mnemonic != "")
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Color(0xFFedf3f7),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.mnemonic));
                        Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
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
                                              widget.mnemonic,
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
                ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                child: Text(
                  S.of(context).LookMnemonicPage_group2,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withAlpha(180),
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Color(0xFFedf3f7),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.privateKey));
                      Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
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
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(top: 10, bottom: 15, right: 10, left: 10),
                                          child: Text(
                                            widget.privateKey,
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
              ),
              if (widget.mnemonic != "")
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: Text(
                    S.of(context).LookMnemonicPage_title3,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
              if (widget.mnemonic != "")
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      onPressed: () {
                        showGeneralDialog(
                            useRootNavigator: false,
                            context: context,
                            pageBuilder: (context, anim1, anim2) {},
                            //barrierColor: Colors.grey.withOpacity(.4),
                            barrierDismissible: true,
                            barrierLabel: "",
                            transitionDuration: Duration(milliseconds: 0),
                            transitionBuilder: (_, anim1, anim2, child) {
                              final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                              return Transform(
                                transform: Matrix4.translationValues(0.0, 0, 0.0),
                                child: Opacity(
                                  opacity: anim1.value,
                                  // ignore: missing_return
                                  child: PayPasswordWidget(
                                    title: S.of(context).LookMnemonicPage_msg,
                                    dismissCallBackFuture: (String password) {
                                      return;
                                    },
                                    passwordCallBackFuture: (String password) async {
                                      var aesDecode = Utils.aesEncode(widget.mnemonic, Utils.generateMd5Int(password));
                                      if (Platform.isIOS) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => BoxCodeMnemonicPage(code: "box_" + aesDecode)));
                                      } else {
                                        Navigator.push(context, SlideRoute(BoxCodeMnemonicPage(code: "box_" + aesDecode)));
                                      }
                                    },
                                  ),
                                ),
                              );
                            });

                        return;
                      },
                      child: Text(
                        S.of(context).LookMnemonicPage_btn,
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
      ),
    );
  }
}
