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

        appBar:AppBar(
          backgroundColor: Color(0xFFE71766),
          title: Text('main'),
        ),
        body:Center(
          child: Text('main'),
        )
    );
  }
}
