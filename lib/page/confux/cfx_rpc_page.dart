import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/manager/plugin_manager.dart';
import 'package:box/page/confux/cfx_home_page.dart';
import 'package:box/page/confux/cfx_transfer_confirm_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';
import '../select_chain_page.dart';

class CfxRpcPage extends StatefulWidget {
  final String url;

  const CfxRpcPage({Key key, this.url}) : super(key: key);

  @override
  _CfxRpcPageState createState() => _CfxRpcPageState();
}

class _CfxRpcPageState extends State<CfxRpcPage> {
  InAppWebViewController _webViewController;
  bool isFinish = true;
  String sign = "";

  double progress = 0;

  String title = "";

  String textContent = 'Flutter端初始文字';

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        // useShouldOverrideUrlLoading: true,
        // mediaPlaybackRequiresUserGesture: false,
        // cacheEnabled: false,
        // clearCache: true,
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
    String confluxJs = await rootBundle.loadString("assets/conflux.js");
    confluxJs = confluxJs.replaceAll("cfx:xxxxxxxx", CfxHomePage.address);
    return confluxJs;
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
                  return InAppWebView(
                    initialOptions: options,
                    initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                    initialUserScripts: Platform.isIOS
                        ? UnmodifiableListView<UserScript>([
                            UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
                            UserScript(source: snapshot.data, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
                          ])
                        : UnmodifiableListView<UserScript>([]),
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
                          handlerName: "signMessage",
                          callback: (List<dynamic> arguments) {
                            print("signMessage" + arguments.toString());
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

                            print(arguments.toString());
                            print(map['from']);
                            print(map['to']);
                            print(map['value'] != null ? map['value'] : "0");
                            print(map['data']);

                            BoxApp.getGasCFX((data) {
                              var split = data.split("#");
                              print(data);
                              map['storageLimit'] = split[2];
                              map['gasPrice'] = "1";
                              map['gas'] = split[0];
                              showMaterialModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  enableDrag: false,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => CfxTransferConfirmPage(
                                        data: map,
                                        cfxTransferConfirmPageCallBackFuture: (signingKey) async {
                                          if(signingKey == ""){
                                            Map<String, String> params = new Map();
                                            params['id'] = arguments[0].toString();
                                            params['jsonrpc'] = "2.0";
                                            var json = jsonEncode(params);
                                            await _webViewController.evaluateJavascript(source: "window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + ");");
                                            return;
                                          }
                                          BoxApp.signTransactionCFX((hash) async {
                                            print(hash);

                                            Map<String, String> params = new Map();
                                            params['id'] = arguments[0].toString();
                                            params['jsonrpc'] = "2.0";
                                            params['result'] = hash;
                                            // params['result'] = "false";
                                            var json = jsonEncode(params);
                                            await _webViewController.evaluateJavascript(source: "window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + ");");

                                            return;
                                          }, (error) {
                                            print(error.toString());
                                            return;
                                          }, signingKey, map['storageLimit'] != null ? (int.parse(map['storageLimit'])).toString() : "0", map['gas'] != null ? (int.parse(map['gas'])).toString() : "0", map['gasPrice'] != null ? (int.parse(map['gasPrice'])).toString() : "0", map['value'] != null ? ((map['value'])).toString() : "0", map['to'], map['data']);
                                          return;
                                        },
                                      ));

                              // showGeneralDialog(
                              //     context: context,
                              //     // ignore: missing_return
                              //     pageBuilder: (context, anim1, anim2) {},
                              //     barrierColor: Colors.grey.withOpacity(.4),
                              //     barrierDismissible: true,
                              //     barrierLabel: "",
                              //     transitionDuration: Duration(milliseconds: 0),
                              //     transitionBuilder: (_, anim1, anim2, child) {
                              //       final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                              //       return Transform(
                              //         transform: Matrix4.translationValues(0.0, 0, 0.0),
                              //         child: Opacity(
                              //           opacity: anim1.value,
                              //           // ignore: missing_return
                              //           child: PayPasswordWidget(
                              //             title: S.of(context).password_widget_input_password,
                              //             dismissCallBackFuture: (String password) {
                              //               return;
                              //             },
                              //             passwordCallBackFuture: (String password) async {
                              //               var signingKey = await BoxApp.getSigningKey();
                              //               var address = await BoxApp.getAddress();
                              //               final key = Utils.generateMd5Int(password + address);
                              //               var aesDecode = Utils.aesDecode(signingKey, key);
                              //
                              //               // if (aesDecode == "") {
                              //               //   showErrorDialog(context, null);
                              //               //   return;
                              //               // }
                              //               // ignore: missing_return
                              //               BoxApp.signTransactionCFX((hash) async {
                              //                 print(hash);
                              //
                              //                 Map<String, String> params = new Map();
                              //                 params['id'] = arguments[0].toString();
                              //                 params['jsonrpc'] = "2.0";
                              //                 params['result'] = hash;
                              //                 var json = jsonEncode(params);
                              //                 await _webViewController.evaluateJavascript(source: "window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + ");");
                              //
                              //                 return;
                              //               }, (error) {
                              //                 print(error.toString());
                              //                 return;
                              //               }, aesDecode, (int.parse(map['storageLimit'])).toString(), (int.parse(map['gas'])).toString(), (int.parse(map['gasPrice'])).toString(), map['value'] != null ? (int.parse(map['value'])).toString() : "0", map['to'], map['data']);
                              //               // showChainLoading();
                              //             },
                              //           ),
                              //         ),
                              //       );
                              //     });
                              return;
                            }, map['from'], map['to'], map['value'] != null ? map['value'] : "0", map['data']);
                          });
                      _webViewController.addJavaScriptHandler(
                          handlerName: "requestAccounts",
                          callback: (List<dynamic> arguments) async {
                            print("requestAccounts" + arguments.toString());
                            Map<String, String> params = new Map();
                            params['id'] = arguments[0].toString();
                            params['jsonrpc'] = "2.0";
                            params['result'] = CfxHomePage.address;
                            var json = jsonEncode(params);
                            await _webViewController.evaluateJavascript(source: "window.conflux.callbacks.get(" + arguments[0].toString() + ")(null, " + json + ");");
                            return "";
                          });
                    },
                    onLoadStart: (controller, url) async {
                      print("onLoadStart");
                      setState(() {
                        isFinish = false;
                      });

                      if (Platform.isAndroid) {
                        var js = await _loadFuture();
                        await _webViewController.evaluateJavascript(source: js);
                      }
                    },
                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      var uri = navigationAction.request.url;
                      print(uri.scheme);
                      if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {}
                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) {
                      print("onLoadStop");
                      setState(() {
                        isFinish = true;
                      });
                    },
                    onLoadResource: (controller, url) async {
                      print("onLoadResource");
                    },
                    onLoadError: (controller, url, code, message) {
                      print("onLoadError" + message);
                    },
                    onProgressChanged: (controller, pro) {
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
          isFinish == false
              ? LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width,
                  lineHeight: 2.0,
                  backgroundColor: Colors.transparent,
                  percent: progress,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  progressColor: Colors.blue,
                )
              : Container(),
        ],
      ),
    );
  }
}
