import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'numeric_keyboard.dart';

//第一种自定义回调方法
typedef ConformCallBackFuture = Future Function();
typedef DismissCallBackFuture = Future Function();

class TxConformWidget extends StatefulWidget {
  final int color;
  final ConformCallBackFuture conformCallBackFuture;
  final DismissCallBackFuture dismissCallBackFuture;
  final Map<String, dynamic> tx;

  const TxConformWidget({
    Key key,
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
      widget.dismissCallBackFuture();
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

    widget.tx.forEach((key, value) {
      if (value is int || value is double) {
        if (value > 10000000000) value = value / 1000000000000000000;
      }
      value = value.toString();
      if (key == "Payload") {
        value = Utils.formatPayload(value);
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
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
//          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
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
                    child: Container(width: 50, height: 40, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                  ),
                ),
              ),
              Container(
//                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Text(
                  S.of(context).dialog_tx_title,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height - 120 - 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: items,
                  ),
                ),
              ),

//              Expanded(
//                child: Container(),
//              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 0),
                child: ArgonButton(
                  height: 50,
                  roundLoadingShape: true,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onTap: (startLoading, stopLoading, btnState) {
                    Navigator.pop(context); //关闭对话框
                    if (widget.conformCallBackFuture != null) widget.conformCallBackFuture();
                  },
                  child: Text(
                    S.of(context).password_widget_conform,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Ubuntu",
                    ),
                  ),
                  loader: Container(
                    padding: EdgeInsets.all(10),
                    child: SpinKitRing(
                      lineWidth: 4,
                      color: Colors.white,
                      // size: loaderWidth ,
                    ),
                  ),
                  borderRadius: 30.0,
                  color: Color(widget.color),
                ),
              ),
//          Text(text),
            ],
          ),
        ),
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
                    fontFamily: "Ubuntu",
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
                    fontFamily: "Ubuntu",
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
