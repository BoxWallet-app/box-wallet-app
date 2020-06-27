import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/page/aens_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                  "跳转123123",
                  style: new TextStyle(fontSize: 17, color: Color(0xFFE71744)),
                ),
                height: 50,
                minWidth: 320,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AensPage()));
                },
              ),
              ArgonButton(
                height: 50,
                roundLoadingShape: false,
                width: MediaQuery.of(context).size.width * 0.45,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                onTap: (startLoading, stopLoading, btnState) async {
//                  if (btnState == ButtonState.Idle) {
//                    startLoading();
//                  } else {
//                    stopLoading();
//                  }


                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                loader: Text(
                  "Loading...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                borderRadius: 5.0,
                color: Color(0xFF7866FE),
              ),
              ArgonButton(
                height: 50,
                roundLoadingShape: true,
                width: MediaQuery.of(context).size.width * 0.45,
                onTap: (startLoading, stopLoading, btnState) {
                  if (btnState == ButtonState.Idle) {
                    startLoading();
                  } else {
                    stopLoading();
                  }
                },
                child: Text(
                  "SignUp",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
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
