import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum LoadingType { loading, error, finish, no_data }

class LoadingWidget extends StatefulWidget {
  final Widget child;
  final LoadingType type;
  final VoidCallback onPressedError;

  const LoadingWidget({Key key, this.type, this.onPressedError, this.child}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
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
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365)),
      ),
    );
  }

  Widget _error(onPressedError) {
    if (onPressedError == null) {
      print("onPressedError null");
    }
    return Center(
        child: Container(
      height: 120,
      child: Column(
        children: <Widget>[
          Text("Network is abnormal. Please try again"),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: MaterialButton(
              child: Text(
                "Retry",
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
    return Center(child: Text("Temporarily no data"));
  }
}
