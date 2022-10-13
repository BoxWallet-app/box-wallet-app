import 'package:box/generated/l10n.dart';
import 'package:box/page/aeternity/ae_swap_buy_sell_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

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
            S.of(context).swap_buy_sell_order_title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
