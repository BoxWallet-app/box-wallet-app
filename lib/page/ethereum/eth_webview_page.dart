import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';
import 'eth_home_page.dart';

class EthWebViewPage extends StatefulWidget {
  const EthWebViewPage({Key key}) : super(key: key);

  @override
  _EthWebViewPageState createState() => _EthWebViewPageState();
}

class _EthWebViewPageState extends State<EthWebViewPage> {
  WebViewController webViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "test",
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
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
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
            child: WebView(
              initialUrl: "https://app.kswap.finance/#/swap",
              // initialUrl: "https://www.cherryswap.net/#/swap?locale=zh-CN&utm_source=imtoken",
              // initialUrl: "https://pancakeswap.finance/swap",
              // initialUrl: "https://js-eth-sign.surge.sh/",
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) async {
                print(url);
                await installJS();
              },

              onProgress: (progress) {
                print(progress);
                this.progress = (progress / 100);
                setState(() {});
              },

              onWebViewCreated: (WebViewController webViewController) async {
                this.webViewController = webViewController;
                print("onWebViewCreated");
                installJS();
              },
              javascriptChannels: {
                JavascriptChannel(
                    name: '_tw_',
                    onMessageReceived: (JavascriptMessage message) async {
                      print(message.message);
                      final responseJson = jsonDecode(message.message);
                      Map<String, dynamic> data = responseJson;
                      var addr = "0x990457A97C140DB61c1E8944212752Ee1bC3d288";
                      var id = data["id"];
                      var setAddress = "window.ethereum.setAddress(\"$addr\");";
                      var callback = "window.ethereum.sendResponse($id, [\"$addr\"])";
                      await webViewController.evaluateJavascript(setAddress);
                      await webViewController.evaluateJavascript(callback);
                    }),
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> installJS() async {
    String confluxJs = await rootBundle.loadString("assets/trust-min.js");

    await webViewController.runJavascript(confluxJs);

    var chainId = 66;
    // var chainId = 56;
    var rpcUrl = "https://okchain.mytokenpocket.vip";
    // var rpcUrl = "https://bsc-dataseed2.binance.org";
    await webViewController.runJavascript("""
      (function() {
          var config = {
              chainId: $chainId,
              rpcUrl: "$rpcUrl",
              isDebug: true
          };
          window.ethereum = new trustwallet.Provider(config);
          window.web3 = new trustwallet.Web3(window.ethereum);
          trustwallet.postMessage = (json) => {
              window._tw_.postMessage(JSON.stringify(json));
          }
      })();
                  """);

  }
}
