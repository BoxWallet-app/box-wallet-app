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
            ],
          ),
        ),
      ),
    );
  }
}
