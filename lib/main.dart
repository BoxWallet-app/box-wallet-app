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
import 'package:box/page/splash_page.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rlp/rlp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'generated/l10n.dart';
import 'package:hex/hex.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

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
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(BoxApp());
//  runApp(Test());
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // The message that we will sign
//    test2();
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: MaterialButton(
            child: Text("123"),
            onPressed: () {
              print("123");

              showGeneralDialog(
                context: context,
                barrierLabel: "你好",
                barrierDismissible: true,
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                  return Center(
                    child: Material(
                      child: Container(
                        color: Colors.black.withOpacity(animation.value),
                        child: Text("我是一个可变的"),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
      ),
    );
    initState() {}
  }

  Future test2() async {
    // The message that we will sign
//    final message = <int>[1, 2, 3];
//    var privateKeyHex = HEX.decode("d03826de64d010f683b4aee0ac67e074e01725bb6f94c6d26942ab5a5671886a5e88d722246295cefec3143d2cf2212347aac960d0b3ea4abe03fba86ce0dc2e");
//    PrivateKey privateKey = new PrivateKey(privateKeyHex);
//
//    var publicKex = HEX.decode("ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF");
//    PublicKey publicKey = new PublicKey(publicKex);
//    // Generate a random ED25519 keypair
//    final keyPair = new KeyPair(privateKey: privateKey, publicKey: publicKey);
//
//    // Sign
//    final signature = await ed25519.sign(
//      message,
//      keyPair,
//    );
//
//    print('Signature: ${signature.bytes}');
//    print('Public key: ${signature.publicKey.bytes}');

//    var keyPair = ed.generateKey();
//    var privateKey = keyPair.privateKey;
//    var publicKey = keyPair.publicKey;

    var privateKeyHex = HEX.decode("d03826de64d010f683b4aee0ac67e074e01725bb6f94c6d26942ab5a5671886a5e88d722246295cefec3143d2cf2212347aac960d0b3ea4abe03fba86ce0dc2e");
    PrivateKey privateKey = new PrivateKey(privateKeyHex);
//
//    var publicKex = HEX.decode("XojXIiRilc7+wxQ9LPIhI0eqyWDQs+pKvgP7qGzg3C4=");
//    PublicKey publicKey = new PublicKey(publicKex);

//    var message = utf8.encode('YWVfbWFpbm5ldPhcDAGhAV6I1yIkYpXO/sMUPSzyISNHqslg0LPqSr4D+6hs4NwuoQEZ0rJgoQ1wez4TmmcNBApTSPS/77bjxxiRWxMZ3t3umIZa8xB6QACGD1ouZ2AAgwUOT4ICsYA=');

    var message = HEX.decode("61655f6d61696e6e6574f85e0c01a1015e88d722246295cefec3143d2cf2212347aac960d0b3ea4abe03fba86ce0dc2ea10119d2b260a10d707b3e139a670d040a5348f4bfefb6e3c718915b1319deddee9888016345785d8a0000860f637e96f000830510438202bd80");
//    var message = HEX.decode("61655f6d61696e6e6574f85c0c01a1015e88d722246295cefec3143d2cf2212347aac960d0b3ea4abe03fba86ce0dc2ea10119d2b260a10d707b3e139a670d040a5348f4bfefb6e3c718915b1319deddee98865af3107a4000860f5a2e6760008305101e8202bc80");
    var sig = ed.sign(privateKey, message);
//    var result = ed.verify(publicKey, message, sig);

    var encodeSign = HEX.encode(sig);
    print(encodeSign);

    var xorBase64Decode = EncryptUtil.decodeBase64(
        "eyJTZW5kZXJJRCI6ImFrX2lka3g2bTNiZ1JyN1dpS1h1QjhFQllCb1JxVnNhU2M2cW80ZHNkMjNIS2dqM3FpQ0YiLCJSZWNpcGllbnRJRCI6ImFrX0NOY2Yyb3l3cWJnbVZnM0ZmS2RiSFFKZkI5NTl3clZ3cWZ6U3BkV1ZLWm5lcDduajQiLCJBbW91bnQiOjEwMDAwMDAwMDAwMDAwMDAwMCwiRmVlIjoxNjkyMDAwMDAwMDAwMCwiUGF5bG9hZCI6IiIsIlRUTCI6MzMxOTkzLCJOb25jZSI6NzAyfQ==");
    print("xorBase64Decode=>" + xorBase64Decode);
//    assert(result == true);
    var base64decode = base64Decode("");
    var wrongMessage = utf8.encode('wrong message');
//    var wrongResult = ed.verify(publicKey, wrongMessage, sig);
//    assert(wrongResult == false);
  }
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
typedef FlutterJsSecretKeyCallBack = Future Function(String signingKey, String address);
typedef FlutterJsGenerateSecretKeyCallBack = Future Function(String signingKey, String address, String mnemonic);
typedef FlutterJsValidationMnemonicCallBack = Future Function(bool isSucess);

typedef FlutterJsInitCallBack = Future Function();

class BoxApp extends StatelessWidget {
  static bool isInitJs;

  static WebViewController webViewController;

  static String filePath = 'assets/js/ae2.html';

  static FlutterJsSecretKeyCallBack flutterJsSecretKeyCallBack;
  static FlutterJsGenerateSecretKeyCallBack flutterJsGenerateSecretKeyCallBack;
  static FlutterJsValidationMnemonicCallBack flutterJsValidationMnemonicCallBack;

  static loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    BoxApp.webViewController.loadUrl(Uri.dataFromString(fileHtmlContents, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
    isInitJs = true;
    print("初始化成功");
  }

  static String signMsg(String msg,String signingKey){
    var privateKeyHex = HEX.decode(signingKey);
    PrivateKey privateKey = new PrivateKey(privateKeyHex);
    var message = HEX.decode(msg);
    var sig = ed.sign(privateKey, message);
    var encodeSign = HEX.encode(sig);
    return encodeSign;
  }

  static getSecretKey(FlutterJsSecretKeyCallBack callBack, String mnemonic) {
    BoxApp.flutterJsSecretKeyCallBack = callBack;
    BoxApp.webViewController.evaluateJavascript("getSecretKey('" + mnemonic + "');");
  }

  static getGenerateSecretKey(FlutterJsGenerateSecretKeyCallBack callBack) {
    BoxApp.flutterJsGenerateSecretKeyCallBack = callBack;
    BoxApp.webViewController.evaluateJavascript("getMnemonic();");
  }

  static getValidationMnemonic(FlutterJsValidationMnemonicCallBack callBack, String mnemonic) {
    BoxApp.flutterJsValidationMnemonicCallBack = callBack;
    BoxApp.webViewController.evaluateJavascript("validationMnemonic('" + mnemonic + "');");
  }

  // *** dome1 同时显示俩盒子。
  static showOverlay(BuildContext context, FlutterJsInitCallBack callBack) async {
    final server = Jaguar(address: "127.0.0.1", port: 9000);
    server.addRoute(serveFlutterAssets());
    await server.serve(logRequests: true);
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
//    String fileHtmlContents = await rootBundle.loadString(filePath);
//    print(fileHtmlContents);
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Container(
        alignment: Alignment.topLeft,
        child: Container(
            width: 1,
            height: 1,
            child: WebView(
//              initialUrl: Uri.dataFromString(fileHtmlContents, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
              initialUrl: "http://127.0.0.1:9000/html/ae.html",
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                callBack();
                print("初始化成功");
              },
              onWebViewCreated: (WebViewController webViewController) {
                BoxApp.webViewController = webViewController;
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
                      if (BoxApp.flutterJsGenerateSecretKeyCallBack != null) {
                        var list = message.message.split("#");
                        BoxApp.flutterJsGenerateSecretKeyCallBack(list[0], list[1], list[2]);
                      }
                    }),
                JavascriptChannel(
                    name: 'getSecretKey_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      if (BoxApp.flutterJsSecretKeyCallBack != null) {
                        var list = message.message.split("#");
                        BoxApp.flutterJsSecretKeyCallBack(list[0], list[1]);
                      }
                    }),
                JavascriptChannel(
                    name: 'validationMnemonic_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      print(message.message);
                      if (BoxApp.flutterJsValidationMnemonicCallBack != null) {
                        if (message.message == "sucess") {
                          BoxApp.flutterJsValidationMnemonicCallBack(true);
                        } else {
                          BoxApp.flutterJsValidationMnemonicCallBack(false);
                        }
                      }
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
          home: StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return SplashPage();
              }),
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
