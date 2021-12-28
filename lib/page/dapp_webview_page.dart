import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:box/dao/ethereum/eth_fee_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/ethereum/eth_fee_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:native_webview/native_webview.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../main.dart';
import 'confux/cfx_transfer_confirm_page.dart';
import 'ethereum/eth_home_page.dart';
import 'ethereum/eth_transfer_confirm_page.dart';

class DappWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const DappWebViewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _DappWebViewPageState createState() => _DappWebViewPageState();
}

class _DappWebViewPageState extends State<DappWebViewPage> {
  WebViewController _webViewController;
  double progress = 0;
  bool isPageFinish = false;
  String address = "";
  String rpcUrl = "";
  String chainID = "";
  String coinName = "";
  String title = "";
  String url = "";
  Account account;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    url = widget.url;
    title = widget.title;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  Icons.replay,
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
          if (chainID == "")
            Container()
          else
            Expanded(
              child: WebView(
                chainID: chainID,
                rpcUrl: rpcUrl,
                address: address,
                coinName: coinName,
                initialUrl: widget.url,
                onPostMessage: (webViewController, coinName, message) async {
                  if (account.coin == "CFX") {
                    await cfxToDapp(message, webViewController, context);
                  } else {
                    await ethToDapp(message, webViewController, context);
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
          Padding(
            padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
            child: Container(
              padding:  EdgeInsets.all(7),
              alignment: Alignment.center,
              child: Text(
                this.url,
                textAlign:TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xff666666),
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> cfxToDapp(String message, WebViewController webViewController, BuildContext context) async {
     final responseJson = jsonDecode(message);
    Map<String, dynamic> data = responseJson;
    if (data["type"] == "requestAccounts") {
      var id = data["resolver"];
      Map<String, dynamic> params = new Map<String, dynamic>();
      params['id'] = id;
      params['jsonrpc'] = "2.0";
      params['result'] = address;
      var json = jsonEncode(params);
      await webViewController.evaluateJavascript("window.conflux.callbacks.get(" + id.toString() + ")(null, " + json + ");");
    }
    if (data["type"] == "signTypedMessage") {
      var id = data["resolver"];
      Map<String, String> params = new Map();
      params['id'] = id;
      params['jsonrpc'] = "2.0";
      params['result'] = "";
      var json = jsonEncode(params);
      await _webViewController.evaluateJavascript("window.conflux.callbacks.get(" + id.toString() + ")(null, " + json + ");");
    }
    if (data["type"] == "signTransaction") {
      var id = data["resolver"];
      LinkedHashMap<String, dynamic> map = data["payload"];
      EasyLoading.show();
      BoxApp.getGasCFX((data) {
        EasyLoading.dismiss(animation: true);
        var split = data.split("#");
        map['storageLimit'] = split[2];
        map['gasPrice'] = "1000000000";
        map['gas'] = split[0];
        print(split);
        showMaterialModalBottomSheet(
            expand: true,
            context: context,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (context) => CfxTransferConfirmPage(
                  data: map,
                  cfxTransferConfirmPageCallBackFuture: (signingKey) async {
                    if (signingKey == "") {
                      Map<String, dynamic> params = new Map();
                      params['id'] = id;
                      params['jsonrpc'] = "2.0";
                      Map<String, dynamic> error = new Map();
                      error['code'] = 4001;
                      error['message'] = "Refuse to trade";
                      params["error"] = error;
                      var json = jsonEncode(params);
                      await _webViewController.evaluateJavascript("window.conflux.callbacks.get(" + id.toString() + ")(null, " + json + ");");
                      return;
                    }

                    BoxApp.signTransactionCFX((hash) async {
                      Map<String, dynamic> params = new Map();
                      params['id'] = id;
                      params['jsonrpc'] = "2.0";
                      params['result'] = hash;
                      var json = jsonEncode(params);
                      await _webViewController.evaluateJavascript("window.conflux.callbacks.get(" + id.toString() + ")(null, " + json + ");");
                      return;
                    }, (error) async {
                      Map<String, dynamic> params = new Map();
                      params['id'] = id;
                      params['jsonrpc'] = "2.0";
                      Map<String, dynamic> errorData = new Map();
                      errorData['code'] = 4001;
                      errorData['message'] = "Refuse to trade";
                      params["error"] = errorData;
                      var json = jsonEncode(params);
                      await _webViewController.evaluateJavascript("window.conflux.callbacks.get(" + id.toString() + ")(null, " + json + ");");
                      showErrorDialog(context, error);
                      return;
                    }, signingKey, map['storageLimit'] != null ? (int.parse(map['storageLimit'])).toString() : "0", map['gas'] != null ? (int.parse(map['gas'])).toString() : "0", map['gasPrice'] != null ? (int.parse(map['gasPrice'])).toString() : "0",
                        map['value'] != null ? ((map['value'])).toString() : "0", map['to'], map['data']);
                    return;
                  },
                ));

        // sh
        return;
      }, map['from'], map['to'], map['value'] != null ? map['value'] : "0", map['data']);
    }
  }

  Future<void> ethToDapp(String message, WebViewController webViewController, BuildContext context) async {
    final responseJson = jsonDecode(message);
    Map<String, dynamic> data = responseJson;

    if (data["name"] == "requestAccounts") {
      var id = data["id"];
      var setAddress = "window.ethereum.setAddress(\"$address\");";
      var callback = "window.ethereum.sendResponse($id, [\"$address\"])";
      webViewController.evaluateJavascript(setAddress);
      webViewController.evaluateJavascript(callback);
    }
    if (data["name"] == "signTransaction") {
      var id = data["id"];
      var object = data["object"];
      var objectData = object["data"];
      // var objectGas = object["gas"];
      var objectTo = object["to"];
      var objectFrom = object["from"];
      var objectValue = object["value"];
      if (objectValue == null) {
        objectValue = "0";
        object["value"] = objectValue;
      }
      EasyLoading.show();
      BoxApp.getGasEth((gasLimit) async {
        object["gasLimit"] = gasLimit;
        EasyLoading.dismiss(animation: true);
        Account account = await WalletCoinsManager.instance.getCurrentAccount();
        showMaterialModalBottomSheet(
            expand: true,
            context: context,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (context) => EthTransferConfirmPage(
              data: object,
              account: account,
              ethTransferConfirmPageCallBackFuture: (signingKey,fee) async {
                if (signingKey == "") {
                  String e = "error";
                  var callback = "window.ethereum.sendError($id, [\"$e\"])";
                  webViewController.evaluateJavascript(callback);
                  return;
                }

                Account account = await WalletCoinsManager.instance.getCurrentAccount();
                EthFeeModel ethFeeModel = await EthFeeDao.fetch(EthManager.instance.getChainID(account));

                BoxApp.signTransactionETH((signData) {
                  print("signData：" + signData);
                  var callback = "window.ethereum.sendResponse($id, [\"$signData\"])";
                  webViewController.evaluateJavascript(callback);
                  return;
                }, (error) {
                  String e = error;
                  var callback = "window.ethereum.sendError($id, [\"$e\"])";
                  webViewController.evaluateJavascript(callback);
                  showErrorDialog(context, error);
                  return;
                }, signingKey, gasLimit, fee , objectValue, objectTo, objectData, rpcUrl);
                // }, signingKey, gasLimit, ethFeeModel.data.feeList[1].fee, objectValue, objectTo, objectData, rpcUrl);
                return;
              },
            ));



        return;
      }, objectFrom, objectTo, objectValue, objectData, rpcUrl);
    }
  }

  getData() async {
    account = await WalletCoinsManager.instance.getCurrentAccount();
    coinName = account.coin;
    address = account.address;
    if (coinName == "CFX") {
      rpcUrl = await BoxApp.getCfxNodeUrl();
      chainID = "1029";
    } else {
      rpcUrl = await EthManager.instance.getNodeUrl(account);
      print(rpcUrl);
      chainID = EthManager.instance.getDappChainID(account);
    }
    print(chainID);
    setState(() {});
  }

  void showErrorDialog(BuildContext buildContext, String content) {
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
          content: Text(content),
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
}
