import 'package:box/page/aens_detail_page.dart';
import 'package:box/page/aens_my_page.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/aens_register.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/login_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(BoxApp());
}

class BoxApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('zh', 'CH'), // Hebrew
          // ... other locales the app supports
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'aens': (BuildContext context) => AensPage(),
          'aens_my': (BuildContext context) => AensMyPage(),
          'aens_register': (BuildContext context) => AensRegister(),
          'aens_detail': (BuildContext context) => AensDetailPage(),
          'scan_page': (BuildContext context) => ScanPage(),
        });
  }

  static setSigningKey(String signingKey) {}

  static String getSigningKey() {
    return "d03826de64d010f683b4aee0ac67e074e01725bb6f94c6d26942ab5a5671886a5e88d722246295cefec3143d2cf2212347aac960d0b3ea4abe03fba86ce0dc2e";
  }

  static String getAddress() {
    return "ak_QyFYYpgJ1vUGk1Lnk8d79WJEVcAtcfuNHqquuP2ADfxsL6yKx";
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
