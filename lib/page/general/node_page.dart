import 'dart:convert';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:box/dao/aeternity/node_test_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NodePage extends BaseWidget {
  @override
  _NodePageState createState() => _NodePageState();
}

class _NodePageState extends BaseWidgetState<NodePage> {
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BoxApp.getNodeUrl().then((nodeUrl) {
      if (nodeUrl == "") {
        _textEditingControllerNode.text = "https://mainnet.aeternity.io";
      } else {
        _textEditingControllerNode.text = nodeUrl;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).setting_page_node_set,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
            minWidth: 10,
            child: new Text(
              S.of(context).setting_page_node_reset,
              style: TextStyle(
                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
              ),
            ),
            onPressed: () {
              _textEditingControllerNode.text = "https://mainnet.aeternity.io";
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
        },
        child: Container(
          // height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
          color: Color(0xFFfafbfc),
          // color: Color(0xFFFFFFFF),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).setting_page_node_url,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withAlpha(180),
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: Color(0xFFedf3f7),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
//                                          autofocus: true,

                        controller: _textEditingControllerNode,
                        focusNode: focusNodeNode,
//              inputFormatters: [
//                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
//              ],
                        maxLines: 1,
                        style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 18,
                          fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(left: 10.0),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666).withAlpha(85),
                          ),
                        ),
                        cursorColor: Color(0xFFFC2365),
                        cursorWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20, left: 30, right: 30),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                    onPressed: () {
                      EasyLoading.show();
                      NodeTestDao.fetch(_textEditingControllerNode.text).then((isSucess) {
                        EasyLoading.dismiss();
                        if (isSucess) {
                          BoxApp.setNodeUrl(_textEditingControllerNode.text);
                          setSDKBaseUrl(_textEditingControllerNode.text);
                          showConfirmDialog(S.of(context).dialog_hint, S.of(context).dialog_node_set_sucess);
                        } else {
                          showConfirmDialog(S.of(context).dialog_hint, S.of(context).dialog_node_set_error);
                        }
                      }).catchError((e) {
                        EasyLoading.dismiss();
                        showConfirmDialog(S.of(context).dialog_hint, S.of(context).dialog_node_set_error);
                      });
                      return;
                    },
                    child: Text(
                      S.of(context).setting_page_node_save,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
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

  //设置SDK Url
  void setSDKBaseUrl(String nodeUrl) {
    var jsonData = {
      "name": "aeSetNodeUrl",
      "params": {"url": nodeUrl}
    };
    var channelJson = json.encode(jsonData);
    BoxApp.sdkChannelCall((result) {
      return;
    }, channelJson);
  }

  Material buildItem(String key, bool isSelect, GestureTapCallback tab) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          padding: const EdgeInsets.only(left: 18, right: 21, top: 20, bottom: 20),
          child: Row(
            children: [
              /*1*/
              Column(
                children: [
                  /*2*/
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                  ),
                ],
              ),
              /*3*/
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image(
                    width: 25,
                    height: 25,
                    image: AssetImage(isSelect ? "images/check_box_select.png" : "images/check_box_normal.png"),
                  ),
                  margin: const EdgeInsets.only(left: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
