import 'package:box/dao/aens_page_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'aens_list_page.dart';
import 'aens_my_page.dart';

class AensMyPage extends StatefulWidget {
  @override
  _AensMyPageState createState() => _AensMyPageState();
}

class _AensMyPageState extends State<AensMyPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
            tooltip: 'Navigreation',
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '我的域名',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,

          bottom:TabBar(
            unselectedLabelColor: Colors.black54,
            indicatorSize: TabBarIndicatorSize.label,
            dragStartBehavior: DragStartBehavior.down,
            indicator: UnderlineIndicator(
                strokeCap: StrokeCap.round,
                borderSide: BorderSide(
                  color: Color(0xFFE71766),
                  width: 2,
                ),
                insets: EdgeInsets.only(bottom: 5)),
            tabs: <Widget>[
              Tab(icon: Text("正在竞拍")),
              Tab(icon: Text("已经注册")),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AensListPage(aensPageType: AensPageType.my_auction),
            AensListPage(aensPageType: AensPageType.my_over),
          ],
        ),
      ),
    );
  }
}
