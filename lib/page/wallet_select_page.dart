import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WalletSelectPage extends StatefulWidget {
  const WalletSelectPage({Key key}) : super(key: key);

  @override
  _WalletSelectPageState createState() => _WalletSelectPageState();
}

class _WalletSelectPageState extends State<WalletSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent.withAlpha(0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: ShapeDecoration(
          color: Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 52,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child:      Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.close,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child:      Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.close,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 70,
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(left: 16, right: 16),
              padding: EdgeInsets.only(top: 12, bottom: 12),
              //边框设置
              decoration: new BoxDecoration(
                color: Color(0xFFeeeeee),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width - 20,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                //边框设置
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 32,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context); //关闭对话框
                  },
                  color: Color(0xFFFC2365),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
//          Text(text),
          ],
        ),
      ),
    );
  }
}
