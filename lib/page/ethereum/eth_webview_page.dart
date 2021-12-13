import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/native_webview.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../main.dart';
import 'eth_home_page.dart';

class EthWebViewPage extends StatefulWidget {
  const EthWebViewPage({Key key}) : super(key: key);

  @override
  _EthWebViewPageState createState() => _EthWebViewPageState();
}

class _EthWebViewPageState extends State<EthWebViewPage> {
  WebViewController _webViewController;
  double progress = 0;
  String title = "";
  String url = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar: AppBar(
//        brightness: Brightness.dark,
        //设置为白色字体
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,

        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 17,
                  ),
                  onPressed: () async {
                    Future<bool> canGoBack = _webViewController.canGoBack();
                    canGoBack.then((str) {
                      if (str) {
                        _webViewController.goBack();
                        // _webViewController.reload();
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () async {
                  Future<bool> canGoBack = _webViewController.canGoBack();
                  canGoBack.then((str) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.transparent,
                  size: 22,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () async {
                  Future<bool> canGoBack = _webViewController.canGoBack();
                  canGoBack.then((str) {
                    _webViewController.loadUrl(url);
                  });
                },
              ),
            ],
          ),
        ),
//         actions: <Widget>[
//           Container(
//             width: 50,
//             child: IconButton(
//               icon: Icon(
//                 Icons.close,
//                 color: Colors.black,
//                 size: 20,
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
// //              Navigator.pop(context);
//               },
//             ),
//           ),
//
//         ],
      ),
      body: Column(
        children: [
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width,
            lineHeight: 2.0,
            backgroundColor: Colors.transparent,
            percent: progress,
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            progressColor: Colors.blue,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
              child: WebView(
                chainID: "56",
                rpcUrl: "https://bsc.mytokenpocket.vip",
                address: "0x990457A97C140DB61c1E8944212752Ee1bC3d288",
                coinName: "OKT",
                initialUrl: "https://pancakeswap.finance/swap?utm_source=tokenpocket",
                // chainID: "66",
                // rpcUrl: "https://okchain.mytokenpocket.vip",
                // address: "0x990457A97C140DB61c1E8944212752Ee1bC3d288",
                // coinName: "TEST",
                // initialUrl: "https://kswap.finance/?utm_source=moonswap&current_lang=en-en&theme=dark",

                onPostMessage: (webViewController, coinName, message) {
                  print("FLUTTER:" + message);
                  final responseJson = jsonDecode(message);
                  Map<String, dynamic> data = responseJson;
                  var addr = "0x990457A97C140DB61c1E8944212752Ee1bC3d288";
                  var id = data["id"];
                  var setAddress = "window.ethereum.setAddress(\"$addr\");";
                  var callback = "window.ethereum.sendResponse($id, [\"$addr\"])";
                  webViewController.evaluateJavascript(setAddress);
                  webViewController.evaluateJavascript(callback);
                },
                onPageFinished: (webViewController, url) {
                  print("onPageFinished");
                  // this.title = title;
                  this.url = url;
                  setState(() {});
                },
                onPageStarted: (webViewController, url) {
                  print("onPageStarted");
                },
                onProgressChanged: (webViewController, progress) {
                  print(progress);
                  this.progress = (progress / 100);
                  setState(() {});
                },

                onWebViewCreated: (WebViewController webViewController) async {
                  this._webViewController = webViewController;
                  print("onWebViewCreated");
                },


              ),
            ),
          ),
        ],
      ),
    );
  }
}
