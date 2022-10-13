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
import 'package:underline_indicator/underline_indicator.dart';

import '../../main.dart';

class CfxNftPage extends StatefulWidget {
  @override
  _CfxNftPageState createState() => _CfxNftPageState();
}

class _CfxNftPageState extends State<CfxNftPage> {
  List<Widget> tabs = <Widget>[];
  List<Widget> tabsView = <Widget>[];

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
      tabsView.clear();
      for (var i = 0; i < model.data!.length; i++) {
        var tab = createTab(context, model.data![i].name!.zh! + "(" + model.data![i].balance.toString() + ")");
        tabs.add(tab);
        tabsView.add(CfxNftListPage(data: model.data![i]));
      }
      setState(() {});
    }).catchError((e) {
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
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
                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Color(0xfffafafa),
          body: LoadingWidget(
            type: LoadingType.loading,
            child: Container(),
          ));
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
              ),
            ),
            centerTitle: true,

            bottom: TabBar(
              unselectedLabelColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.label,
              dragStartBehavior: DragStartBehavior.down,
              isScrollable: true,
              indicator: UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(
                    color: Color(0xFFFC2365),
                    width: 2,
                  ),
                  insets: EdgeInsets.only(bottom: 5)),
              tabs: tabs,
            ),
          ),
          backgroundColor: Color(0xfffafafa),
          body: Container(
            padding: const EdgeInsets.only(top: 0),
            child: TabBarView(
              children: tabsView,
            ),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50)),
    );
  }

  Tab createTab(BuildContext context, String tab) {
    return Tab(
        icon: Text(
      tab,
      style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w600),
    ));
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
