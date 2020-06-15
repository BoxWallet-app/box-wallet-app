import 'package:box/page/aens_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          child: MaterialButton(
            child: Text(
              "跳转123123",
              style: new TextStyle(fontSize: 17, color: Color(0xFFE71744)),
            ),
            height: 50,
            minWidth: 320,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AensPage()));
            },
          ),
        ));
  }
}
