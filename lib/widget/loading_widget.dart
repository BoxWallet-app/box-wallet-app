import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

enum LoadingType { loading, error, finish, no_data }

class LoadingWidget extends StatefulWidget {
  final Widget child;
  final LoadingType type;
  final VoidCallback onPressedError;

  const LoadingWidget({Key key, this.type, this.onPressedError, this.child}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case LoadingType.loading:
        return _loadingView;
        break;
      case LoadingType.error:
        return _error(widget.onPressedError);
        break;
      case LoadingType.finish:
        return widget.child;
      case LoadingType.no_data:
        return _noData;
//        return _error(widget.onPressedError);;
        break;
    }
  }

  Widget get _loadingView {
//    return Center(
//      child: CircularProgressIndicator(
//        valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365)),
//      ),
//    );

    return Center(
      child: Container(
        width: 60,
        height: 60,
        child: Lottie.asset(
          'images/loading.json',
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
    );
  }

  Widget _error(onPressedError) {
    if (onPressedError == null) {}
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 198,
            height: 164,
            image: AssetImage('images/no_net.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              S.of(context).loading_widget_no_net,
              style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFF000000)),

            ),
          ),

          Container(
            height: 35,
            width: 120,
            margin: EdgeInsets.only(top: 20, bottom: MediaQueryData.fromWindow(window).padding.bottom + 50),
            child: FlatButton(
              onPressed: () {
                onPressedError.call();
              },
              child: Text(
                S.of(context).loading_widget_no_net_try,
                maxLines: 1,
                style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFFF22B79)),
              ),
              color: Color(0xFFE61665).withAlpha(16),
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    ));
  }

  Widget get _noData {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 198,
            height: 164,
            image: AssetImage('images/no_data.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).loading_widget_no_data,
              style: TextStyle(
                fontSize: 15,
                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
