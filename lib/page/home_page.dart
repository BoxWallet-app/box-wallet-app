import 'package:box/generated/l10n.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BoxApp.getLanguage().then((String value) {
      if (value == "en") {
        S.load(Locale("en", "US"));
      } else {
        S.load(Locale("cn", "CN"));
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationWidget();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
