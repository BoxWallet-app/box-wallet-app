import 'package:box/generated/l10n.dart';
import 'package:box/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _value = "";

  @override
  void initState() {
    super.initState();

    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 35.0
      ..radius = 10.0
      ..backgroundColor = Colors.white
      ..indicatorColor = Color(0xFFFC2365)
      ..textColor = Colors.black
      ..progressColor=Colors.red
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true;
    BoxApp.getLanguage().then((String value) {
      print("getLanguage->" + value);
      S.load(Locale(value, value.toUpperCase()));
      setState(() {
        _value = value;
      });
      Future.delayed(Duration(seconds: 1), () {
        S.load(Locale(value, value.toUpperCase()));
//        Navigator.pushReplacement(context,LoginPage());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        _value,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
