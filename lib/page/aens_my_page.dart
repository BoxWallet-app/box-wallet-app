import 'package:box/dao/aens_page_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../main.dart';
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            S.of(context).aens_my_page_title,
            style: TextStyle(fontSize: 18,fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
          ),
          centerTitle: true,

          bottom: TabBar(
            unselectedLabelColor: Colors.black54,
            indicatorSize: TabBarIndicatorSize.label,
            dragStartBehavior: DragStartBehavior.down,
            indicator: UnderlineIndicator(
                strokeCap: StrokeCap.round,
                borderSide: BorderSide(
                  color: Color(0xFFFC2365),
                  width: 2,
                ),
                insets: EdgeInsets.only(bottom: 5)),
            tabs: <Widget>[
              Tab(icon: Text(S.of(context).aens_my_page_title_tab_1 ,style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),)),
              Tab(icon: Text(S.of(context).aens_my_page_title_tab_2,style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),)),
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
