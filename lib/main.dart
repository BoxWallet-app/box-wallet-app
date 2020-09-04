import 'package:box/page/account_login_page.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/mnemonic_confirm_page.dart';
import 'package:box/page/aens_detail_page.dart';
import 'package:box/page/aens_my_page.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/aens_register.dart';
import 'package:box/page/home_page_lod.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/login_page.dart';
import 'package:box/page/main_page.dart';
import 'package:box/page/mnemonic_copy_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

void main() {
  // 强制竖屏
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // ignore: unrelated_type_equality_checks
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
    ..userInteractions = false;
  runApp(BoxApp());
}

class BoxApp extends StatelessWidget {
  static var context;

  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    BoxApp.context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
      },
      home: FlutterEasyLoading(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashPage(),

          localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          theme: new ThemeData(
            primaryColor: Colors.white,
          ),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => LoginPage(),
            '/home': (BuildContext context) => HomePage(),
          },
        ),
      ),
    );
  }

  static setMnemonic(String mnemonic) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('mnemonic', mnemonic);
  }


  static Future<String> getMnemonic() async {
    var prefs = await SharedPreferences.getInstance();
    var mnemonic = prefs.getString('mnemonic');
    return mnemonic;
  }

  static setSigningKey(String signingKey) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('signingKey', signingKey);
  }

  static Future<String> getSigningKey() async {
    var prefs = await SharedPreferences.getInstance();
    var signingKey = prefs.getString('signingKey');
    return signingKey;
  }

  static Future<String> setAddress(String address) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('address', address);
  }

  static Future<String> getAddress() async {
    var prefs = await SharedPreferences.getInstance();
    var address = prefs.getString('address');
    if (address == null) {
      return "-";
    }
    return address;
  }

  static void setLanguage(String language) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  static Future<String> getLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    var language = prefs.getString('language');
    return language == null ? "en" : language;
  }
}
