import 'package:box/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

typedef ConformCallBackFuture = Future Function();
typedef DismissCallBackFuture = Future Function();

class ChainLoadingWidget extends StatefulWidget {
  late String status = "loading...";
  late String content = "";

  ChainLoadingWidget(String content) {
    this.content = content;
  }

  @override
  _ChainLoadingWidgetState createState() => _ChainLoadingWidgetState();
}

class _ChainLoadingWidgetState extends State<ChainLoadingWidget> with TickerProviderStateMixin {
  AnimationController? _controller;
  String text = 'Loading...';
  List<Widget> items = [];

  @override
  void dispose() {
    _controller!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  void updateStatus(String status) {}

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x00000000),
      child: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 0,
            child: Container(
              margin: EdgeInsets.only(left: 18, right: 18, bottom: MediaQuery.of(context).padding.bottom > 0 ? 0 : 18),
              width: MediaQuery.of(context).size.width - 36,
              height: MediaQuery.of(context).size.height / 3,
//          margin: EdgeInsets.only(top: 200),
              decoration: ShapeDecoration(
                color: Color(0xffFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
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
                        'images/chain_loading.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller!
                            ..duration = Duration(milliseconds: 3000)
                            ..repeat();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 18),
                    child: Text(
                      widget.content,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
