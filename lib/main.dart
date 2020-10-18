import 'dart:convert';

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
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:webview_flutter/webview_flutter.dart';
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
    ..progressColor = Colors.red
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false;
  // 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(BoxApp());
}

//class Test extends StatefulWidget {
//  @override
//  _TestState createState() => _TestState();
//}
//
//class _TestState extends State<Test> {
//  @override
//  void initState() {
//    super.initState();
//    _showOverlay(context);
//  }




//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        body: Container(
//          child: Column(
//            children: [
//              MaterialButton(
//                onPressed: () {
//                  _webViewController.evaluateJavascript("getHeight();");
//                },
//                child: Text("Flutter js - HEIGHT"),
//              ),
//              MaterialButton(
//                onPressed: () {
//                  _webViewController.evaluateJavascript("getMnemonic();");
//                },
//                child: Text("Flutter js - WORD"),
//              ),
//              MaterialButton(
//                onPressed: () {
//                  _webViewController.evaluateJavascript("getSecretKey('edge input extra small april flip draft resist enlist card million steak');");
//                },
//                child: Text("Flutter js - getSecretKey"),
//              ),
//            ],
//          ),
//        ),
//        floatingActionButton: Builder(builder: (context) {
//          return FloatingActionButton(child: Icon(Icons.fiber_smart_record), onPressed: () => _showOverlay(context));
//        }),
//      ),
//    );
//  }
//}
typedef FlutterJsSecretKeyCallBack = Future Function(String content);

class BoxApp extends StatelessWidget {

  static bool isInitJs;

  static WebViewController webViewController;

  static String filePath = 'assets/js/ae.html';

  static FlutterJsSecretKeyCallBack flutterJsSecretKeyCallBack;

  static loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    BoxApp.webViewController.loadUrl(Uri.dataFromString(fileHtmlContents, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
    isInitJs = true;
    print("初始化成功");
  }

  static getSecretKey(FlutterJsSecretKeyCallBack callBack,String mnemonic ){
    BoxApp.flutterJsSecretKeyCallBack = callBack;
    BoxApp.webViewController.evaluateJavascript("getSecretKey('"+mnemonic+"');");
  }
  // *** dome1 同时显示俩盒子。
  static showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
            width: 10,
            height: 10,
            child: WebView(
              initialUrl: '',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                BoxApp.webViewController = webViewController;
                loadHtmlFromAssets();
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'getHeight_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      print("get message from JS, message is: ${message.message}");
                    }),
                JavascriptChannel(
                    name: 'getMnemonic_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      print(message.message);
                    }),
                JavascriptChannel(
                    name: 'getSecretKey_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      if(BoxApp.flutterJsSecretKeyCallBack!=null){
                        BoxApp.flutterJsSecretKeyCallBack(message.message);
                      }
                      print(message.message);
                    }),
              ].toSet(),
            )),
      );
    });
    overlayState.insert(overlayEntry);
  }





  static var context;

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
