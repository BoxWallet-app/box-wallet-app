import 'package:box/page/aens_detail_page.dart';
import 'package:box/page/aens_my_page.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/aens_register.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/login_page.dart';
import 'package:box/page/main_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

void main() {
  // 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // ignore: unrelated_type_equality_checks


  runApp(BoxApp());
}

class BoxApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: HomePage(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
        'aens': (BuildContext context) => AensPage(),
        'aens_my': (BuildContext context) => AensMyPage(),
        'aens_register': (BuildContext context) => AensRegister(),
        'aens_detail': (BuildContext context) => AensDetailPage(),
        'scan_page': (BuildContext context) => ScanPage(),
        'language_page': (BuildContext context) => LanguagePage(),
      },
    );
  }

  static setSigningKey(String signingKey) {}

  static String getSigningKey() {
    return "d03826de64d010f683b4aee0ac67e074e01725bb6f94c6d26942ab5a5671886a5e88d722246295cefec3143d2cf2212347aac960d0b3ea4abe03fba86ce0dc2e";
  }

  static String getAddress() {
    return "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF";
  }

  static void setLanguage(String language) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 设置存储数据
    prefs.setString('language', language);
  }

  static Future<String> getLanguage() async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 获取存储数据
    var language = prefs.getString('language');
    return language == null ? "en" : language;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListTile(
              leading: RaisedButton(
                onPressed: () {
                  setState(() {
                    S.load(Locale('en', 'US'));
                  });
                },
                child: Text('ENGLISH'),
              ),
              trailing: RaisedButton(
                onPressed: () {
                  setState(() {
                    S.load(Locale('cn', 'ZH'));
                  });
                },
                child: Text('GERMAN'),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(S.of(context).title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  Text(""),
                  Text(S.of(context).pageHomeSamplePlaceholder("John"), style: TextStyle(fontSize: 20)),
                  Text(S.of(context).pageHomeSamplePlaceholdersOrdered("John", "Doe"), style: TextStyle(fontSize: 20)),
                  Text(S.of(context).pageHomeSamplePlural(2), style: TextStyle(fontSize: 20)),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ))
        ],
      ),
    );
  }
}
