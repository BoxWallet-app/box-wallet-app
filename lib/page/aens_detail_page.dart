import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AensDetailPage extends StatefulWidget {
  @override
  _AensDetailPageState createState() => _AensDetailPageState();
}

class _AensDetailPageState extends State<AensDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'AENS详情',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Text("123"),
    );
  }
}
