import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class WebPage extends StatefulWidget {

  final String url;
  final String title;

  const WebPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  WebViewController _webViewController;
  bool isFinish = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Future<bool> canGoBack = _webViewController.canGoBack();
            canGoBack.then((str) {
              if (str) {
                _webViewController.goBack();
              } else {
                Navigator.of(context).pop();
              }
            });
//              Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
//              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFfafbfc),
//        floatingActionButton: new FloatingActionButton(
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          child: new Icon(Icons.close),
//          elevation: 3.0,
//          highlightElevation: 2.0,
//          backgroundColor: Color(0xFFFC2365),
//        ),
//        floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),

      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only( bottom: MediaQueryData.fromWindow(window).padding.bottom),
            child: WebView(
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              onPageFinished: (String url) {
                isFinish = true;
                setState(() {});
              },
              //JS执行模式 是否允许JS执行
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl:  widget.url,
//                navigationDelegate: (NavigationRequest request) {//路由委托（可以通过在此处拦截url实现JS调用Flutter部分）；
//                  if (!request.url.startsWith('https://wetrue.io')) {
//                    Fluttertoast.showToast(msg: "Blocking access", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//                    return NavigationDecision.prevent;///阻止路由替换，不能跳转，因为这是js交互给我们发送的消息
//                  }
//                  return NavigationDecision.navigate;///允许路由替换
//                },
            ),

          ),
          isFinish == false
              ? Container(
                  color: Color(0xFFfafbfc),
                  child: Center(
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
