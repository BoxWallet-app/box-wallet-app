import 'dart:io';

import 'package:box/dao/conflux/cfx_nft_balance_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/page/general/cfx_node_page.dart';
import 'package:box/page/general/node_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class NodeSelectPage extends StatefulWidget {
  @override
  _NodeSelectPageState createState() => _NodeSelectPageState();
}

class _NodeSelectPageState extends State<NodeSelectPage> {
  @override
  void initState() {
    super.initState();
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
          S.of(context).NodePage_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xfffafafa),
      body: EasyRefresh(
        footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
        child: Container(
          margin: EdgeInsets.only(left: 16,right: 16),
          child: Column(
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  onTap: () async {
                    if (Platform.isIOS) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NodePage()));
                    } else {
                      Navigator.push(context, SlideRoute(NodePage()));
                    }

                    return;
                  },
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
                                      "AE (Aeternity)",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
//                                  fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*3*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    onTap: () async {
                      if (Platform.isIOS) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CfxNodePage()));
                      } else {
                        Navigator.push(context, SlideRoute(CfxNodePage()));
                      }
                      return;
                    },
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
                                        "CFX (Conflux)",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
//                                  fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*3*/
                            ],
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
