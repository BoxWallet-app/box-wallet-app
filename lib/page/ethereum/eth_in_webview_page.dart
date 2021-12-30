// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:box/page/confux/cfx_home_page.dart';
// import 'package:box/page/confux/cfx_transfer_confirm_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
//
// import '../../main.dart';
//
// class EthInWebViewPage extends StatefulWidget {
//   final String url;
//
//   const EthInWebViewPage({Key key, this.url}) : super(key: key);
//
//   @override
//   _EthInWebViewPageState createState() => _EthInWebViewPageState();
// }
//
// class _EthInWebViewPageState extends State<EthInWebViewPage> {
//   InAppWebViewController _webViewController;
//   bool isFinish = true;
//   String sign = "";
//
//   double progress = 0;
//
//   String title = "";
//
//   String textContent = 'Flutter端初始文字';
//
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//     crossPlatform: InAppWebViewOptions(
//         // useShouldOverrideUrlLoading: true,
//         // mediaPlaybackRequiresUserGesture: false,
//         // cacheEnabled: false,
//         clearCache: true,
//         ),
//   );
//
//   PullToRefreshController pullToRefreshController;
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
// //异步加载方法
//   Future<String> _loadFuture() async {
//     String confluxJs = await rootBundle.loadString("assets/trust-min.js");
//     return confluxJs;
//   }
//
//
//
//   var chainId = 66;
//   // var chainId = 56;
//   var rpcUrl = "https://okchain.mytokenpocket.vip";
//   // var rpcUrl = "https://bsc-dataseed2.binance.org";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
// //        brightness: Brightness.dark,
//         //设置为白色字体
//         backgroundColor: Color(0xFFfafbfc),
//         elevation: 0,
//         // 隐藏阴影
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         titleSpacing: 0.0,
//
//         title: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Row(
//             children: [
//               Container(
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.black,
//                     size: 17,
//                   ),
//                   onPressed: () async {
//                     Future<bool> canGoBack = _webViewController.canGoBack();
//                     canGoBack.then((str) {
//                       if (str) {
//                         _webViewController.goBack();
//                         // _webViewController.reload();
//                       } else {
//                         Navigator.of(context).pop();
//                       }
//                     });
//                   },
//                 ),
//               ),
//
//               IconButton(
//                 icon: Icon(
//                   Icons.close,
//                   color: Colors.black,
//                   size: 20,
//                 ),
//                 onPressed: () async {
//                   Future<bool> canGoBack = _webViewController.canGoBack();
//                   canGoBack.then((str) {
//                     Navigator.of(context).pop();
//                   });
//                 },
//               ),
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.transparent,
//                   size: 22,
//                 ),
//
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.refresh,
//                   color: Colors.black,
//                   size: 20,
//                 ),
//                 onPressed: () async {
//                   Future<bool> canGoBack = _webViewController.canGoBack();
//                   canGoBack.then((str) {
//                     _webViewController.reload();
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Color(0xFFffffff),
//       body: Stack(
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
//             child: FutureBuilder<String>(
//                 future: _loadFuture(), //异步加载方法
//                 builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   if (snapshot == null || snapshot.data == null) {
//                     return Container();
//                   }
//                   return InAppWebView(
//                     initialOptions: options,
//                     // initialUrlRequest: URLRequest(url: Uri.parse("https://www.cherryswap.net/#/swap?locale=zh-CN&utm_source=imtoken")),
//                     initialUrlRequest: URLRequest(url: Uri.parse("https://app.kswap.finance/#/swap")),
//                     // initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
//                     initialUserScripts:UnmodifiableListView<UserScript>([
//                       UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
//                       UserScript(source: """
//                   (function() {
//                       var config = {
//                           chainId: $chainId,
//                           rpcUrl: "$rpcUrl",
//                           isDebug: true
//                       };
//                       window.ethereum = new trustwallet.Provider(config);
//                       window.web3 = new trustwallet.Web3(window.ethereum);
//                       trustwallet.postMessage = (json) => {
//                           window._tw_.postMessage(JSON.stringify(json));
//                       }
//                   })();
//               """, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
//                       UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
//                       UserScript(source: """
//                   (function() {
//                       var config = {
//                           chainId: $chainId,
//                           rpcUrl: "$rpcUrl",
//                           isDebug: true
//                       };
//                       window.ethereum = new trustwallet.Provider(config);
//                       window.web3 = new trustwallet.Web3(window.ethereum);
//                       trustwallet.postMessage = (json) => {
//                           window._tw_.postMessage(JSON.stringify(json));
//                       }
//                   })();
//               """, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
//                     ]),
//                     onTitleChanged: (controller, t) {
//                       title = t;
//                       setState(() {});
//                     },
//                     onWebViewCreated: (controller) {
//                       _webViewController = controller;
//                     },
//                     onLoadStart: (controller, url) async {
//                       setState(() {
//                         isFinish = false;
//                       });
//
//                     },
//                     androidOnPermissionRequest: (controller, origin, resources) async {
//                       return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
//                     },
//                     shouldOverrideUrlLoading: (controller, navigationAction) async {
//                       var uri = navigationAction.request.url;
//                       if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {}
//                       return NavigationActionPolicy.ALLOW;
//                     },
//                     onLoadStop: (controller, url) async {
//                       setState(() {
//                         isFinish = true;
//                       });
//
//                       var chainId = 66;
//                       // var chainId = 56;
//                       var rpcUrl = "https://okchain.mytokenpocket.vip";
//                       // var rpcUrl = "https://bsc-dataseed2.binance.org";
//               //         await _webViewController.evaluateJavascript(source:"""
//               //     (function() {
//               //         var config = {
//               //             chainId: $chainId,
//               //             rpcUrl: "$rpcUrl",
//               //             isDebug: true
//               //         };
//               //         window.ethereum = new trustwallet.Provider(config);
//               //         window.web3 = new trustwallet.Web3(window.ethereum);
//               //         trustwallet.postMessage = (json) => {
//               //             window._tw_.postMessage(JSON.stringify(json));
//               //         }
//               //     })();
//               // """);
//                       // await _webViewController.evaluateJavascript(source: "window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + ");");
//
//                     },
//                     onLoadResource: (controller, url) async {},
//                     onLoadError: (controller, url, code, message) {
//                     },
//                     onProgressChanged: (controller, pro) {
//                       progress = (pro / 100);
//                       setState(() {});
//                     },
//                     onUpdateVisitedHistory: (controller, url, androidIsReload) {},
//                     onConsoleMessage: (controller, consoleMessage) {
//                       //print(consoleMessage);
//                     },
//                   );
//                 }),
//           ),
//           isFinish == false
//               ? LinearPercentIndicator(
//                   width: MediaQuery.of(context).size.width,
//                   lineHeight: 2.0,
//                   backgroundColor: Colors.transparent,
//                   percent: progress,
//                   padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                   progressColor: Colors.blue,
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
