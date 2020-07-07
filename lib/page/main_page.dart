import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/aens_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState(){
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text('main'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                child: Text(
                  S.of(context).title,
                  style: new TextStyle(fontSize: 17, color: Color(0xFFE71744)),
                ),
                height: 50,
                minWidth: 320,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AensPage()));
                },
              ),
              ArgonButton(
                height: 50,
                roundLoadingShape: false,
                width: MediaQuery.of(context).size.width * 0.45,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                onTap: (startLoading, stopLoading, btnState) async {
                  S.load(Locale('cn','ZH'));

                },
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),

                borderRadius: 5.0,
                color: Color(0xFF7866FE),
              ),
              ArgonButton(
                height: 50,
                roundLoadingShape: true,
                width: MediaQuery.of(context).size.width * 0.45,
                onTap: (startLoading, stopLoading, btnState) {
                  setState(() {
                    S.load(Locale('en','US'));
                  });
                },
                child: Text(
                  "SignUp",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitRing(
                    color: Colors.white,
                    // size: loaderWidth ,
                  ),
                ),
                borderRadius: 30.0,
                color: Color(0xFFfb4747),
              ),
              ArgonButton(
                height: 50,
                roundLoadingShape: true,
                width: MediaQuery.of(context).size.width * 0.45,
                onTap: (startLoading, stopLoading, btnState) {
                  setState(() {
                    S.load(Locale('cn','CN'));
                  });
                },
                child: Text(
                  "SignUp2",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitRing(
                    color: Colors.white,
                    // size: loaderWidth ,
                  ),
                ),
                borderRadius: 30.0,
                color: Color(0xFFfb4747),
              ),
            ],
          ),
        ));
  }
}
