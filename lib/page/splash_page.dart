import 'package:box/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

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

      print("getLanguage->"+value);
      S.load(Locale(value, value.toUpperCase()));
      setState(() {
        _value  = value;

      });
      Future.delayed(Duration(seconds: 1), (){
        S.load(Locale(value, value.toUpperCase()));
        Navigator.pushReplacementNamed(context, "login");
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_value),
    );
  }
}
