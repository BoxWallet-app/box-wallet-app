import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    BoxApp.getLanguage().then((String value) {
      print("getLanguage->" + value);
      S.load(Locale(value, value.toUpperCase()));
      setState(() {
        _value = value;
      });
      Future.delayed(Duration(seconds: 1), () {
        S.load(Locale(value, value.toUpperCase()));
//        Navigator.pushReplacement(context,LoginPage());
        BoxApp.getAddress().then((value) {
          if (value.length > 10) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Column(
                  children: <Widget>[
//                  Container(
//                    width: MediaQuery.of(context).size.width,
//                    height: 100,
//                    color: Color(0x32FC2365),
//                  ),
                    Container(
                      decoration: new BoxDecoration(
                        gradient: const LinearGradient(begin: Alignment.topRight, colors: [
//                        Color(0x1AFC2365),
                          Color(0xFFFAFAFA),
                        ]),
                      ),
                      height: 600,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQueryData.fromWindow(window).padding.bottom + 50,
                child: Container(
                  alignment: Alignment.center,
                  child: Image(
                    width: 153,
                    height: 36,
                    image: AssetImage('images/home_logo_left.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
