import 'dart:convert';
import 'dart:ui';

import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/native_webview.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../main.dart';
import 'eth_home_page.dart';

class EthWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const EthWebViewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _EthWebViewPageState createState() => _EthWebViewPageState();
}

class _EthWebViewPageState extends State<EthWebViewPage> {
  WebViewController _webViewController;
  double progress = 0;
  bool isPageFinish = false;
  String address = "";
  String rpcUrl = "";
  String chainID = "";
  String coinName = "";
  String title = "";
  String url = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    url = widget.url;
    title = widget.title;
    print(url);
    print(title);
    getData();
  }

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
                  Icons.more_horiz,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () async {
                  Future<bool> canGoBack = _webViewController.canGoBack();
                  canGoBack.then((str) {
                    if (url == null) {
                      return;
                    }
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
          if (!isPageFinish)
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width,
              lineHeight: 2.0,
              backgroundColor: Colors.transparent,
              percent: progress,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              progressColor: Colors.blue,
            ),
          chainID == ""
              ? Container()
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
                    child: WebView(
                      chainID: chainID,
                      rpcUrl: rpcUrl,
                      address: address,
                      coinName: coinName,
                      initialUrl: widget.url,
                      onPostMessage: (webViewController, coinName, message) {
                        print("FLUTTER:" + message);
                        final responseJson = jsonDecode(message);
                        Map<String, dynamic> data = responseJson;

                        if (data["name"] == "requestAccounts") {
                          var addr = address;
                          var id = data["id"];
                          var setAddress = "window.ethereum.setAddress(\"$addr\");";
                          var callback = "window.ethereum.sendResponse($id, [\"$addr\"])";
                          webViewController.evaluateJavascript(setAddress);
                          webViewController.evaluateJavascript(callback);
                        }
                      },
                      onPageFinished: (webViewController, url) {
                        // this.title = title;
                        print("onPageFinished");
                        isPageFinish = true;

                        _webViewController.evaluateJavascript("document.title").then((result) {
                          if (result != null && result != "")
                            setState(() {
                              title = result;
                            });
                        });
                        setState(() {});
                      },
                      onPageStarted: (webViewController, url) {
                        print("onPageStarted");
                        if (url != "" && url != null) this.url = url;
                        isPageFinish = false;
                        _webViewController.evaluateJavascript("document.title").then((result) {
                          if (result != null && result != "")
                          setState(() {
                            title = result;
                          });
                        });
                        setState(() {});
                      },
                      onProgressChanged: (webViewController, progress) {
                        this.progress = (progress / 100);
                        setState(() {});
                      },
                      onWebViewCreated: (WebViewController webViewController) async {
                        this._webViewController = webViewController;
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  getData() async {
    Account account = await WalletCoinsManager.instance.getCurrentAccount();
    coinName = account.name;
    address = account.address;
    rpcUrl = await EthManager.instance.getNodeUrl(account);
    chainID = EthManager.instance.getDappChainID(account);
    setState(() {});
  }
}
