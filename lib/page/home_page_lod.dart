import 'package:box/generated/l10n.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';

import '../main.dart';

class HomePageOld extends StatefulWidget {
  @override
  _HomePageOldState createState() => _HomePageOldState();
}

class _HomePageOldState extends State<HomePageOld> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationWidget();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
