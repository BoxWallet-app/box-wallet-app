import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import 'numeric_keyboard.dart';

//第一种自定义回调方法
typedef ConformCallBackFuture = Future? Function();
typedef DismissCallBackFuture = Future? Function();

class TxConformWidget extends StatefulWidget {
  final int color;
  final ConformCallBackFuture? conformCallBackFuture;
  final DismissCallBackFuture? dismissCallBackFuture;
  final Map<String, dynamic>? tx;

  const TxConformWidget({
    Key? key,
    this.tx,
    this.conformCallBackFuture,
    this.dismissCallBackFuture,
    this.color = 0xFFFC2365,
  }) : super(key: key);

  @override
  _TxConformWidgetWidgetState createState() => _TxConformWidgetWidgetState();
}

class _TxConformWidgetWidgetState extends State<TxConformWidget> {
  String text = '';
  List<Widget> items = [];

  @override
  void dispose() {
    super.dispose();
    if (widget.dismissCallBackFuture != null) {
      widget.dismissCallBackFuture!();
    }
  }

  @override
  void initState() {
    super.initState();
    items.add(
      Container(
        height: 20.0,
      ),
    );

    widget.tx!.forEach((key, value) {
      if (value is int || value is double) {
        if (value > 10000000000) value = value / 1000000000000000000;
      }
      value = value.toString();
      if (key == "Payload") {
        value = Utils.formatPayload(value);
      }
      if (key == "tag") {
        return;
      }
      if (key == "VSN") {
        return;
      }
      if (key == "nonce") {
        return;
      }
      if (key == "abiVersion") {
        return;
      }
      if (key == "callerId") {
        return;
      }
      if (key == "gas") {
//        value = (double.parse(value.toString()).).toString()+" AE";
        return;
      }
      if (key == "gasPrice") {
//        value = (double.parse(value.toString())/100000000000000000).toString()+" AE";
        return;
      }
      if (key == "fee") {
        value = (double.parse(value.toString()) / 100000000000000000).toString() + " AE";
      }
      if (key == "amount") {
        value = (double.parse(value.toString()) / 100000000000000000).toString() + " AE";
      }
      items.add(buildItems(key, value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      type: MaterialType.transparency, //透明类型
      color: Colors.white,
      child: Column(
        children: [
          Expanded(child: Container()),
          Container(
            child: Container(
              height: MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.height / 4,
//          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
//                width: MediaQuery.of(context).size.width - 40,
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            onTap: () {
                              Navigator.pop(context); //关闭对话框
                              // ignore: unnecessary_statements
                            },
                            child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                          child: Text(
                            S.of(context).dialog_tx_title,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: items,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context); //关闭对话框
                          if (widget.conformCallBackFuture != null) widget.conformCallBackFuture!();
                        },
                        child: Text(
                          S.of(context).password_widget_conform+ " " +(double.parse(widget.tx!["amount"].toString()) / 100000000000000000).toString() + "AE",
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                        ),
                        color: Color(0xFFFC2365),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),

//          Text(text),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Container buildItems(String key, String value) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Row(
        children: [
          /*1*/
          Column(
            children: [
              /*2*/
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
            ],
          ),
          /*3*/
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 50),
                alignment: Alignment.topRight,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
//                overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
