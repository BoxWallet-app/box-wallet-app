import 'dart:io';

import 'package:box/dao/conflux/cfx_nft_balance_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/page/general/cfx_node_page.dart';
import 'package:box/page/general/node_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class ModelPage extends StatefulWidget {
  @override
  _ModelPageState createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  bool isOpenSecurity = false;

  @override
  void initState() {
    super.initState();
    getModel();
  }

  getModel() async {
    isOpenSecurity = await BoxApp.getAuth();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "模式",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xfffafafa),
      body: EasyRefresh(
        // footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            /*1*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*2*/
                                Container(
                                  child: Text(
                                    "应急模式",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 20,
                            child: Switch(
                              value: isOpenSecurity,
                              activeColor: Color(0xFFFC2365),
                              onChanged: (value) {
                                setState(() {
                                  isOpenSecurity = value;
                                });
                                eventBus.fire(ModelUpdateEvent());
                                BoxApp.setAuth(isOpenSecurity);
                              },
                            ),
                          ),
                          /*3*/
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 12),
                alignment: Alignment.topLeft,
                child: Text(
                  "应急模式将开启BoxWallet和节点直接交互，BoxWallet的功能将变为极简模式。访问速度也会有影响。建议尽在BoxWallet服务器被攻击时候根据使用情况用户酌情开启。",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withAlpha(130),
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
