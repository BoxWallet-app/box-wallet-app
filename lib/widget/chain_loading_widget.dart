import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'numeric_keyboard.dart';

//第一种自定义回调方法
typedef ConformCallBackFuture = Future Function();
typedef DismissCallBackFuture = Future Function();

// ignore: must_be_immutable
class ChainLoadingWidget extends StatefulWidget {
  final String status = "";
  _TxConformWidgetWidgetState txConformWidgetWidgetState;

  @override
  _TxConformWidgetWidgetState createState() => _TxConformWidgetWidgetState();
}

class _TxConformWidgetWidgetState extends State<ChainLoadingWidget> {
  String text = 'Loading...';
  List<Widget> items = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // ignore: missing_return
    BoxApp.getStatus((status) {
      print(status);
      if (status == "sucess" || status == "error") {
        Navigator.pop(context); //关闭对话框
        return;
      }
      switch (status) {
        case "broadcast":
          text = "Is being Broadcast";
          break;
        case "aensPreclaim":
          text = "Declaring domain name";
          break;
          case "aensBid":
          text = "Bid domain name";
          break;
        case "aensUpdate":
          text = "Update domain name";
          break;
        case "aensClaim":
          text = "Binding domain name";
          break;
        case "contractEncodeCall":
          text = "Compiling the contract";
          break;
        case "contractCall":
          text = "Contract in progress";
          break;
        case "decode":
          text = "Decoding contract information";
          break;
      }

      setState(() {});
    });
  }

  void updateStatus(String status) {}

  @override
  Widget build(BuildContext context) {
    return Material(
//          type: MaterialType.transparency, //透明类型
      color: Color(0x00000000),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
//          margin: EdgeInsets.only(top: 200),
              decoration: ShapeDecoration(
                color: Color(0xffFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SpinKitRing(
                      color: Color(0xFFFC2365),
                      lineWidth: 5,
                      size: 50.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 18),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Ubuntu",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
