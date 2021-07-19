import 'package:box/dao/aens_page_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/page/aeternity/ae_aens_register.dart';
import 'package:box/page/aeternity/ae_swap_buy_sell_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../main.dart';
import 'ae_aens_list_page.dart';
import 'ae_aens_my_page.dart';

class AeSwapsPage extends StatefulWidget {
  @override
  _AeSwapsPageState createState() => _AeSwapsPageState();
}

class _AeSwapsPageState extends State<AeSwapsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F5F5),
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

        ),
        body: AeSwapBuySellPage()
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
