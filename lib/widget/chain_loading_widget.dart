import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
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

class _TxConformWidgetWidgetState extends State<ChainLoadingWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  String text = 'Loading...';
  List<Widget> items = [];

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    // ignore: missing_return
    BoxApp.getStatus((status) {
      if (status == "sucess" || status == "error") {
        Navigator.pop(context); //关闭对话框
        return;
      }
      switch (status) {
        case "allowance":
          text = S.of(context).ae_status_allowance;
          break;
        case "change_allowance":
          text = S.of(context).ae_status_change_allowance;
          break;
        case "create_allowance":
          text = S.of(context).ae_status_create_allowance;
          break;
        case "aensPreclaim":
          text = S.of(context).ae_status_aensPreclaim;

          break;
        case "aensBid":
          text = S.of(context).ae_status_aensBid;
          break;
        case "aensUpdate":
          text = S.of(context).ae_status_aensUpdate;
          break;
        case "aensTransfer":
          text = S.of(context).ae_status_aensTransfer;
          break;
        case "aensClaim":
          text = S.of(context).ae_status_aensClaim;
          break;
        case "contractEncodeCall":
          text = S.of(context).ae_status_contractEncodeCall;
          break;
        case "contractCall":
          text = S.of(context).ae_status_contractCall;
          break;
        case "decode":
          text = S.of(context).ae_status_decode;
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
              height: MediaQuery.of(context).size.height / 3,
//          margin: EdgeInsets.only(top: 200),
              decoration: ShapeDecoration(
                color: Color(0xffFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Container(
                      width: 70,
                      height: 70,
                      child: Lottie.asset(
                        'images/lf30_editor_41iiftdt.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          _controller
                            ..duration = Duration(milliseconds: 1000)
                            ..repeat();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 18),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
