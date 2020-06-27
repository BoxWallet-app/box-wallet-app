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
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '域名',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tx',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '价格(ae)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '当前高度',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '创建高度',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),



          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '结束高度',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '到期高度',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '所有者',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(

                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new Text(
                      "Container ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),




        ],
      ),
    );
  }
}
