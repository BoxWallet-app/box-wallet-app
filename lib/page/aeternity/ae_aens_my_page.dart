import 'package:box/dao/aeternity/aens_page_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../main.dart';
import 'ae_aens_list_page.dart';
import 'ae_aens_page.dart';
import 'ae_aens_register.dart';

class AeAensMyPage extends StatefulWidget {
  @override
  _AeAensMyPageState createState() => _AeAensMyPageState();
}

class _AeAensMyPageState extends State<AeAensMyPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color:Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            S.of(context).aens_my_page_title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            ),
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
              Tab(
                  icon: Text(
                S.of(context).aens_my_page_title_tab_1,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              )),
              Tab(
                  icon: Text(
                S.of(context).aens_my_page_title_tab_2,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AeAensListPage(aensPageType: AensPageType.my_auction),
            AeAensListPage(aensPageType: AensPageType.my_over),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(context, SlideRoute( AeAensRegister()));
          },
          child: new Icon(Icons.add),
          elevation: 3.0,
          highlightElevation: 2.0,
          backgroundColor: Color(0xFFFC2365),
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),
      ),
    );
  }
}
