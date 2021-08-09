import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:box/widget/tx_conform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class CfxRpcPage extends StatefulWidget {
  const CfxRpcPage({Key key}) : super(key: key);

  @override
  _CfxRpcPageState createState() => _CfxRpcPageState();
}

class _CfxRpcPageState extends State<CfxRpcPage> {
  InAppWebViewController _webViewController;
  bool isFinish = true;
  String sign = "";

  double progress = 0;

  String title = "";

  // final GlobalKey webViewKey = GlobalKey();


  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      // useShouldOverrideUrlLoading: true,
      // mediaPlaybackRequiresUserGesture: false,
      cacheEnabled: false,
      clearCache: true,
    ),

  );

  PullToRefreshController pullToRefreshController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

//异步加载方法
  Future<String> _loadFuture() async {
    return await rootBundle.loadString("assets/conflux.js");
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
          title,
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
                // _webViewController.goBack();
                _webViewController.reload();
              } else {
                Navigator.of(context).pop();
              }
            });
//              Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
            width: 50,
            child: IconButton(
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
          ),
        ],
      ),
      backgroundColor: Color(0xFFffffff),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
            child: FutureBuilder<String>(
                future: _loadFuture(), //异步加载方法
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                  if (snapshot == null || snapshot.data == null) {
                    return Text("");
                  }
                  print("加载了");
                  return InAppWebView(
                    // key: webViewKey,
                    initialOptions: options,
                    // pullToRefreshController: pullToRefreshController,
                    // initialUrlRequest: URLRequest(url: Uri.parse("http://localhost:8080/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("http://10.53.5.66:9999/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://moondex.io/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://stampers.app/#/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://guguo.io/home")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://moonswap.fi/dapp")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://app.moonswap.fi/#/")),
                    initialUrlRequest: URLRequest(url: Uri.parse("https://moonswap.fi/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://app.tspace.io/#/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("http://nft.tspace.io/exchange_list")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://fccfx.confluxscan.io/")),
                    // initialUrlRequest: URLRequest(url: Uri.parse("https://www.boxnft.io/#/")),
                    // pullToRefreshController: pullToRefreshController,
                   initialUserScripts:   Platform.isIOS ?UnmodifiableListView<UserScript>([
                      UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
                      UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
                    ]):UnmodifiableListView<UserScript>([
                   ]),
                    onTitleChanged: (controller, t) {
                      title = t;
                      print(title);
                      setState(() {});
                    },
                    onWebViewCreated: (controller) {
                      _webViewController = controller;

                      _webViewController.addJavaScriptHandler(
                          handlerName: "signTypedMessage",
                          callback: (List<dynamic> arguments) {
                            print("signTypedMessage" + arguments.toString());
                          });
                      _webViewController.addJavaScriptHandler(
                          handlerName: "postMessage",
                          callback: (List<dynamic> arguments) {
                            print("postMessage" + arguments.toString());
                          });
                      _webViewController.addJavaScriptHandler(
                          handlerName: "signTransaction",
                          callback: (List<dynamic> arguments) {
                            // ignore: unnecessary_statements
                            LinkedHashMap<String, dynamic> map = arguments[1];
                            print("signTransaction" + jsonEncode(arguments));
                            print("signTransaction" + (int.parse(map['value']) / 1000000000000000000).toString());
                            print("signTransaction" + (int.parse(map['value'])).toRadixString(10));
                          });
                      _webViewController.addJavaScriptHandler(
                          handlerName: "requestAccounts",
                          callback: (List<dynamic> arguments) async {
                            print("requestAccounts" + arguments.toString());

                            Map<String, String> params = new Map();
                            params['id'] = arguments[0].toString();
                            params['jsonrpc'] = "2.0";
                            params['result'] = "cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts";
                            var json = jsonEncode(params);
                            print(json);
                            String jsStr = "javascript:(function () {var event; var data = {'data': '" +
                                jsonEncode(params) +
                                "'};  try { event = new MessageEvent('message', data); } catch(e){ event = document.createEvent('MessageEvent'); event.initMessageEvent('message', true, true, data.data, data.orgin, data.lastEventId, data.source);} document.dispatchEvent(event);})()";

                            String result3 = await _webViewController.evaluateJavascript(source: "JSON.stringify(window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + "))");
                            print("window.conflux "+result3);

                            // await _webViewController.evaluateJavascript(source:"javascript:"+jsStr);
                            await _webViewController.evaluateJavascript(source: "window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + ");");

                            String result1 = await _webViewController.evaluateJavascript(source: "JSON.stringify(window.conflux)");

                            print("window.conflux "+result1);
                            return "";
                          });
                    },
                    onLoadStart: (controller, url)  async {
                      // setState(() {});
                      // inject javascript file from an url
                      // await controller.injectJavascriptFileFromUrl(urlFile:Uri.parse("http://10.53.5.66:9999/js/conflux.js"));
                      // wait for jquery to be loaded
                      // await Future.delayed(Duration(milliseconds: 1000));
                      // String result3 = await controller.evaluateJavascript(source:"\$('body').html();");
                      // print(result3); // prints the body html
                      print("onLoadStart");

                      if(Platform.isAndroid){
                        var js = await _loadFuture();
                        await _webViewController.evaluateJavascript(source: js);
                      }

                      // await _webViewController.injectJavascriptFileFromAsset(assetFilePath: "assets/conflux.js");
                      // String result3 = await _webViewController.evaluateJavascript(source: "JSON.stringify(window.conflux)");
                      // print(result3);
                      // controller.injectJavascriptFileFromUrl(urlFile: Uri.parse("http://10.53.5.66:9999/js/conflux.js"));
                      // String source = await rootBundle.loadString( "assets/conflux.js");
                      // source = source.replaceAll("window.flutter_inappwebview.callHandler('getChainAddress','17')", "'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts'");
                      // print(source);
                      // await _webViewController.evaluateJavascript(source: source);
                      // await _webViewController.evaluateJavascript(source: "var config = {address: 'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts', chainId: '1029', rpcUrl: 'https://mainnet-rpc.conflux-chain.org.cn/v2'};const provider = new window.ConfluxPortal(config);window.conflux = provider;window.conflux.on = () => {};window.confluxJS.provider = provider;window.confluxJS.setProvider = function () {};window.confluxJS.defaultAccount = config.address;window.confluxJS.chainId = parseInt(config.chainId);window.confluxJS.networkId = parseInt(config.chainId);").then((value) => {print(value)});

                      // String source = await rootBundle.loadString( "assets/conflux.js");
                      // source = source.replaceAll("window.flutter_inappwebview.callHandler('getChainAddress','17')", "'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts'");
                      // await _webViewController.evaluateJavascript(source: source);
                      // await controller.evaluateJavascript(source: "var config = {address: 'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts', chainId: '1029', rpcUrl: 'https://mainnet-rpc.conflux-chain.org.cn/v2'};const provider = new window.ConfluxPortal(config);window.conflux = provider;window.conflux.on = () => {};window.confluxJS.provider = provider;window.confluxJS.setProvider = function () {};window.confluxJS.defaultAccount = config.address;window.confluxJS.chainId = parseInt(config.chainId);window.confluxJS.networkId = parseInt(config.chainId);").then((value) => {print(value)});

                      // await controller.evaluateJavascript(source: "var config = {address: 'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts', chainId: '1029', rpcUrl: 'https://mainnet-rpc.conflux-chain.org.cn/v2'};const provider = new window.ConfluxPortal(config);window.conflux = provider;window.conflux.on = () => {};window.confluxJS.provider = provider;window.confluxJS.setProvider = function () {};window.confluxJS.defaultAccount = config.address;window.confluxJS.chainId = parseInt(config.chainId);window.confluxJS.networkId = parseInt(config.chainId);").then((value) => {print(value)});
                    },
                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      var uri = navigationAction.request.url;

                      if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                        // if (await canLaunch(url)) {
                        //   // Launch the App
                        //   await launch(
                        //     url,
                        //   );
                        //   // and cancel the request
                        //   return NavigationActionPolicy.CANCEL;
                        // }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) {
                      print(url);
                      print("onLoadStop");
                      // _webViewController.addUserScript(userScript:  UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END));
                      // await _webViewController.injectJavascriptFileFromAsset(assetFilePath: "assets/conflux.js");
                      // String result3 = await _webViewController.evaluateJavascript(source: "JSON.stringify(window.conflux)");
                      // print(result3);
                      // controller.injectJavascriptFileFromUrl(urlFile: Uri.parse("http://10.53.5.66:9999/js/conflux.js"));
                      // String source = await rootBundle.loadString( "assets/conflux.js");
                      // source = source.replaceAll("window.flutter_inappwebview.callHandler('getChainAddress','17')", "'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts'");
                      // print(source);
                      // await _webViewController.evaluateJavascript(source: source);
                      // await _webViewController.evaluateJavascript(source: "var config = {address: 'cfx:aajmbd017x2dw07dxbnsw5grrc4gdd48pautvt8pts', chainId: '1029', rpcUrl: 'https://mainnet-rpc.conflux-chain.org.cn/v2'};const provider = new window.ConfluxPortal(config);window.conflux = provider;window.conflux.on = () => {};window.confluxJS.provider = provider;window.confluxJS.setProvider = function () {};window.confluxJS.defaultAccount = config.address;window.confluxJS.chainId = parseInt(config.chainId);window.confluxJS.networkId = parseInt(config.chainId);").then((value) => {print(value)});
                    },
                    onLoadResource: (controller, url) async {
                      print("onLoadResource");
                      // await controller.injectJavascriptFileFromAsset(assetFilePath: "assets/conflux.js");
                      // await controller.injectJavascriptFileFromAsset(assetFilePath: "assets/conflux.js");
                    },
                    onLoadError: (controller, url, code, message) {
                      print("onLoadError" + message);
                    },
                    onProgressChanged: (controller, pro) {
                      // print("progress:" + progress.toString());

                      progress = (pro / 100);
                      setState(() {});
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {},
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  );
                }),
          ),
          new LinearPercentIndicator(
            width: MediaQuery.of(context).size.width,
            lineHeight: 2.0,
            backgroundColor: Colors.transparent,
            percent: progress,
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            progressColor: Colors.blue,
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
