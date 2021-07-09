import 'dart:convert';
import 'dart:ui';

import 'package:box/widget/tx_conform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class ForumPage extends StatefulWidget {
  final url;
  final title;
  final signingKey;
  final address;

  const ForumPage({Key key, this.url, this.title, this.signingKey, this.address}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  WebViewController _webViewController;
  bool isFinish = false;
  String sign = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        brightness: Brightness.dark,
        //设置为白色字体
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
      backgroundColor: Color(0xFFffffff),
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
                _webViewController.evaluateJavascript("initWallet('"+ widget.signingKey + "','" + widget.address + "','" + widget.url + "');");
                setState(() {});
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: 'onSignData_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      Map<String, dynamic> tx = jsonDecode(message.message);
                      showGeneralDialog(
                          context: context,
                          pageBuilder: (context, anim1, anim2) {},
                          barrierColor: Colors.grey.withOpacity(.4),
                          barrierDismissible: true,
                          barrierLabel: "",
                          transitionDuration: Duration(milliseconds: 0),
                          transitionBuilder: (context, anim1, anim2, child) {
                            final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                            return TxConformWidget(
                                tx: tx,
                                conformCallBackFuture: () {
                                  _webViewController.evaluateJavascript("sign(true,'" + sign + "');");
                                  return;
                                },
                                dismissCallBackFuture: () {
                                  _webViewController.evaluateJavascript("sign(false);");
                                  return;
                                });
                          });
                    }),
                JavascriptChannel(
                    name: 'onSign_JS',
                    onMessageReceived: (JavascriptMessage message) {
                      sign = message.message;
                    }),
              ].toSet(),
              //JS执行模式 是否允许JS执行
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "http://127.0.0.1:9999/sdk/index.html",
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
                  color: Colors.white,
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
