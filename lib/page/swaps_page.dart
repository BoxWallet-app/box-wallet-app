import 'package:box/dao/aens_page_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/page/aens_register.dart';
import 'package:box/page/swap_buy_sell_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../main.dart';
import 'aens_list_page.dart';
import 'aens_my_page.dart';

class SwapsPage extends StatefulWidget {
  @override
  _SwapsPageState createState() => _SwapsPageState();
}

class _SwapsPageState extends State<SwapsPage> {
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
            S.of(context).swap_buy_sell_order_title,
            style: TextStyle(
              fontSize: 18,
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
                S.of(context).swap_buy_sell_order_tab1,
                style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontSize: 14, fontWeight: FontWeight.w600),
              )),
              Tab(
                  icon: Text(
                S.of(context).swap_buy_sell_order_tab2,
                style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontWeight: FontWeight.w600),
              )),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 0),
          child: TabBarView(
            children: <Widget>[
              SwapBuySellPage(type: 0),
              SwapBuySellPage(type: 1),
            ],
          ),
        ),
      ),
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
