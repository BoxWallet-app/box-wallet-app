import 'dart:io';

import 'package:box/dao/aeternity/aens_page_dao.dart';
import 'package:box/dao/conflux/cfx_nft_balance_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/page/aeternity/ae_aens_register.dart';
import 'package:box/page/confux/cfx_nft_list_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../main.dart';

class CfxNftNewPage extends StatefulWidget {
  @override
  _CfxNftNewPageState createState() => _CfxNftNewPageState();
}

class _CfxNftNewPageState extends State<CfxNftNewPage> {
  List<String> tabs = List<String>();
  var _loadingType = LoadingType.loading;

  @override
  void initState() {
    super.initState();
    netNftBalance();
  }

  void netNftBalance() {
    CfxNftBalanceDao.fetch().then((CfxNftBalanceModel model) {
      if (model == null) {
        return;
      }
      tabs.clear();
      for (var i = 0; i < model.data.length; i++) {
        tabs.add(model.data[i].name.zh + "(" + model.data[i].balance.toString() + ")");
      }
      _loadingType = LoadingType.finish;
      setState(() {});
    }).catchError((e) {});
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
          "收藏品",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xfffafafa),
      body: LoadingWidget(
        child: EasyRefresh(
          footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
          child: ListView.builder(
            itemBuilder: _renderRow,
            itemCount: tabs.length,
          ),
        ),
        type: _loadingType,
        onPressedError: () {
          setState(() {
            _loadingType = LoadingType.loading;
          });
          netNftBalance();
        },
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if (index < list.length) {
    return Container(margin: EdgeInsets.only(left: 15, right: 15, top: 12), child: buildColumn(context, index));
  }

  Column buildColumn(BuildContext context, int position) {
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {},
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
                                tabs[position],
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
                      /*3*/
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Tab createTab(BuildContext context, String tab) {
    return Tab(
        icon: Text(
      tab,
      style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w600),
    ));
  }
}
