import 'package:box/dao/aens_page_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/page/aeternity/ae_aens_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../main.dart';
import 'ae_aens_list_page.dart';
import 'ae_aens_my_page.dart';

class AeAensPage extends StatefulWidget {
  @override
  _AeAensPageState createState() => _AeAensPageState();
}

class _AeAensPageState extends State<AeAensPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            // 隐藏阴影
            leading:  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 17,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
            title: Text(
              S.of(context).aens_page_title,
              style: TextStyle(
                fontSize: 18,
                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              MaterialButton(
                minWidth: 10,
                child: new Text(
                  S.of(context).aens_page_title_my,
                  style: TextStyle(
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AeAensMyPage()));
                },
              ),
            ],

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
                  S.of(context).aens_page_title_tab_1,
                  style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontSize: 14, fontWeight: FontWeight.w600),
                )),
                Tab(
                    icon: Text(
                  S.of(context).aens_page_title_tab_2,
                  style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontWeight: FontWeight.w600),
                )),
                Tab(
                    icon: Text(
                  S.of(context).aens_page_title_tab_3,
                  style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontWeight: FontWeight.w600),
                )),
              ],
            ),
          ),
          backgroundColor: Color(0xfffafafa),
          body: Container(
            padding: const EdgeInsets.only(top: 0),
            child: TabBarView(
              children: <Widget>[
                AeAensListPage(aensPageType: AensPageType.auction),
                AeAensListPage(aensPageType: AensPageType.price),
                AeAensListPage(aensPageType: AensPageType.over),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AeAensRegister()));
            },
            child: new Icon(Icons.add),
            elevation: 3.0,
            highlightElevation: 2.0,
            backgroundColor: Color(0xFFFC2365),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50)),
    );
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
