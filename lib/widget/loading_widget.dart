import 'package:box/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

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
    super.dispose();
    _controller.dispose();
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
        break;
    }
  }

  Widget get _loadingView {
//    return Center(
//      child: CircularProgressIndicator(
//        valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365)),
//      ),
//    );

    return  Center(
      child: Container(
        width: 60,
        height: 60,
        child:Lottie.asset(
          'images/animation_khzuiqgg.json',
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            _controller
              ..duration = Duration(milliseconds: 1500)
              ..repeat();
          },
        ),
      ),
    );
  }

  Widget _error(onPressedError) {
    if (onPressedError == null) {
    }
    return Center(
        child: Container(
      height: 120,
      child: Column(
        children: <Widget>[
          Text(  S.of(context).loading_widget_no_net,),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: MaterialButton(
              child: Text(
                S.of(context).loading_widget_no_net_try,
                style: new TextStyle(fontSize: 17, color: Colors.white),
              ),
              color: Color(0xFFFC2365),
              height: 40,
              minWidth: 120,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              onPressed: () {
                onPressedError.call();
              },
            ),
          )
        ],
      ),
    ));
  }

  Widget get _noData {
    return Center(child: Text(S.of(context).loading_widget_no_data));
  }
}
