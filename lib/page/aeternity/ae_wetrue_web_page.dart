import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class AeWetrueWebPage extends StatefulWidget {
  const AeWetrueWebPage({Key? key}) : super(key: key);

  @override
  _AeWetrueWebPageState createState() => _AeWetrueWebPageState();
}

class _AeWetrueWebPageState extends State<AeWetrueWebPage> {
  late WebViewController _webViewController;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _commentFocus = FocusNode();
  double progress = 0;
  bool isPageFinish = false;
  String title = "WeTrue";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
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
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                    size: 17,
                  ), onPressed: () {  },
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    _webViewController.loadUrl("http://wetrue.io/#/?language=" + BoxApp.language + "&source=box&userAddress=" + AeHomePage.address!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (!isPageFinish)
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width,
                lineHeight: 2.0,
                backgroundColor: Colors.transparent,
                percent: progress,
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                progressColor: Color(0xFFFC2365),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
              child: WebView(
                initialUrl: "http://wetrue.io/#/?language=" + BoxApp.language + "&source=box&userAddress=" + AeHomePage.address!,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (url) {
                  isPageFinish = true;
                  print("onPageFinished");
                  setState(() {});
                  _webViewController.runJavascriptReturningResult("document.title").then((result) {
                    setState(() {
                      title = result.replaceAll("\"", "");
                    });
                  });
                },
                onProgress: (progress) {
                  this.progress = (progress / 100);
                  setState(() {});
                },
                onWebViewCreated: (WebViewController webViewController) async {
                  this._webViewController = webViewController;
                },
                onPageStarted: (url) {
                  isPageFinish = false;
                  setState(() {});
                  // _webViewController.evaluateJavascript("document.title").then((result) {
                  //   if (result != null && result != "")
                  //     setState(() {
                  //       title = result;
                  //     });
                  // });
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'WETRUE_COMM_JS',
                      onMessageReceived: (JavascriptMessage message) {
                        final responseJson = jsonDecode(message.message);
                        Map<String, dynamic> data = responseJson;

                        String? amount = data["amount"];

                        String? receivingAccount = data["receivingAccount"];
                        if (data["name"] == "requestAccounts") {}
                        print(message.message);


                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return new AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              title: new Text(S.of(context).wetrue_dialog_transfer_confirm),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    if (double.parse(AmountDecimal.parseUnits(amount, 18)) > 10)
                                      new Text("WeTrue " +
                                          S.of(context).wetrue_dialog_transfer_confirm_content1 +
                                          " " +
                                          AmountDecimal.parseUnits(amount, 18).toString() +
                                          "(AE) " +
                                          S.of(context).wetrue_dialog_transfer_confirm_content2 +
                                          " " +
                                          Utils.formatAddress(receivingAccount) +
                                          " " +
                                          S.of(context).wetrue_dialog_transfer_confirm_content3),
                                    if (double.parse(AmountDecimal.parseUnits(amount, 18)) <= 10)
                                      new Text("WeTrue " +
                                          S.of(context).wetrue_dialog_transfer_confirm_content1 +
                                          " " +
                                          "AE " +
                                          S.of(context).wetrue_dialog_transfer_confirm_content2 +
                                          " " +
                                          Utils.formatAddress(receivingAccount) +
                                          " " +
                                          S.of(context).wetrue_dialog_transfer_confirm_content3),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text(S.of(context).dialog_dismiss),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop(false);
                                  },
                                ),
                                if (double.parse(AmountDecimal.parseUnits(amount, 18)) > 10)
                                  new TextButton(
                                    child: new Text(S.of(context).dialog_conform + "(" + AmountDecimal.parseUnits(amount, 18).toString() + "AE)"),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(true);

                                    },
                                  ),
                                if (double.parse(AmountDecimal.parseUnits(amount, 18)) <= 10)
                                  new TextButton(
                                    child: new Text(S.of(context).dialog_conform),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(true);
                                    },
                                  ),
                              ],
                            );
                          },
                        ).then((val) async {
                          if (val!)
                            showGeneralDialog(
                                useRootNavigator: false,
                                context: context,
                                // ignore: missing_return
                                pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
                                //barrierColor: Colors.grey.withOpacity(.4),
                                barrierDismissible: true,
                                barrierLabel: "",
                                transitionDuration: Duration(milliseconds: 0),
                                transitionBuilder: (_, anim1, anim2, child) {
                                  final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                                  return Transform(
                                    transform: Matrix4.translationValues(0.0, 0, 0.0),
                                    child: Opacity(
                                      opacity: anim1.value,
                                      // ignore: missing_return
                                      child: PayPasswordWidget(
                                        title: S.of(context).password_widget_input_password,
                                        dismissCallBackFuture: (String password) {
                                          return;
                                        },
                                        passwordCallBackFuture: (String password) async {
                                          var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
                                          var address = await BoxApp.getAddress();
                                          final key = Utils.generateMd5Int(password + address);
                                          var aesDecode = Utils.aesDecode(signingKey, key);
                                          if (aesDecode == "") {
                                            showErrorDialog(context, null);
                                            return;
                                          }
                                          showChainLoading();
                                          BoxApp.spend((tx) {
                                            // showCopyHashDialog(context, tx);
                                            Map<String, dynamic> data = Map();
                                            data["code"] = 200;
                                            data["hash"] = tx;
                                            data["msg"] = "";
                                            _webViewController.evaluateJavascript("receiveWeTrueMessage(" + jsonEncode(data) + ");");
                                            return;
                                          }, (error) {
                                            data["code"] = -1;
                                            data["hash"] = "";
                                            data["msg"] = "error";
                                            _webViewController.evaluateJavascript("receiveWeTrueMessage(" + jsonEncode(data) + ");");
                                            showErrorDialog(context, error);
                                            return;
                                          }, aesDecode, address, data["receivingAccount"], AmountDecimal.parseUnits(amount, 18).toString(), Utils.encodeBase64(jsonEncode(data["payload"])));
                                        },
                                      ),
                                    ),
                                  );
                                });

                          return;
                        });
                      }),
                ].toSet(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCopyHashDialog(BuildContext buildContext, String tx) {
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.current.dialog_hint_hash),
          content: Text(tx),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_copy,
              ),
              onPressed: () {
                Navigator.of(buildContext, rootNavigator: true).pop(true);
              },
            ),
            TextButton(
              child: new Text(
                S.of(context).dialog_dismiss,
              ),
              onPressed: () {
                Navigator.of(buildContext, rootNavigator: true).pop(false);
              },
            ),
          ],
        );
      },
    ).then((val) {
      if (val!) {
        Clipboard.setData(ClipboardData(text: "https://www.aeknow.org/block/transaction/" + tx));
      } else {}
    });
  }

  void showErrorDialog(BuildContext buildContext, String? content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }

  void showChainLoading() {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget("");
        });
  }
}
