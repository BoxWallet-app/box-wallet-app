import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  WebViewController _webViewController;
  bool isFinish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        //设置为白色字体
        backgroundColor: Colors.black,
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "Team Forum",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: "Ubuntu",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 17,
          ),
          onPressed: () {
            Future<bool> canGoBack = _webViewController.canGoBack();
            canGoBack.then((str) {
              print(str);
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
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
//              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
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
              initialUrl: "https://forum.aeternity.com/",
              navigationDelegate: (NavigationRequest request) {
                //路由委托（可以通过在此处拦截url实现JS调用Flutter部分）；
//                  if (!request.url.startsWith('https://forum.aeternity.com')) {
//                    Fluttertoast.showToast(msg: "Blocking access", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//                    return NavigationDecision.prevent;///阻止路由替换，不能跳转，因为这是js交互给我们发送的消息
//                  }
                return NavigationDecision.navigate;

                ///允许路由替换
              },
            ),
          ),
          isFinish == false
              ? Container(
                  color: Colors.black,
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
