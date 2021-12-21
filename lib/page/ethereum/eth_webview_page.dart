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
          width: MediaQuery
              .of(context)
              .size
              .width,
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              lineHeight: 2.0,
              backgroundColor: Colors.transparent,
              percent: progress,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              progressColor: Colors.blue,
            ),
          if (chainID == "") Container() else
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQueryData
                    .fromWindow(window)
                    .padding
                    .bottom),
                child: WebView(
                  chainID: chainID,
                  rpcUrl: rpcUrl,
                  address: address,
                  coinName: coinName,
                  initialUrl: widget.url,
                  onPostMessage: (webViewController, coinName, message) async {
                    print("FLUTTER:" + message);
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
                      var objectGas = object["gas"];
                      var objectTo = object["to"];
                      var objectFrom = object["from"];
                      var objectValue = object["value"];
                      if (objectValue == null) {
                        objectValue = "0";
                      }

                      print(id);
                      print(objectData);
                      print(objectGas);
                      print(objectTo);
                      print(objectFrom);
                      BoxApp.getGasEth((data) {


                        showGeneralDialog(useRootNavigator: false,
                            context: context,
                            // ignore: missing_return
                            pageBuilder: (context, anim1, anim2) {},
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
                                    title: S
                                        .of(context)
                                        .password_widget_input_password,
                                    dismissCallBackFuture: (String password) {
                                      return;
                                    },
                                    passwordCallBackFuture: (String password) async {
                                      var signingKey = await BoxApp.getSigningKey();
                                      var address = await BoxApp.getAddress();
                                      final key = Utils.generateMd5Int(password + address);
                                      var aesDecode = Utils.aesDecode(signingKey, key);
                                      // if (aesDecode == "") {
                                      //   showErrorDialog(context,null);
                                      //   return;
                                      // }
                                      // if (widget.cfxTransferConfirmPageCallBackFuture != null) {
                                      //   widget.cfxTransferConfirmPageCallBackFuture(aesDecode);
                                      // }
                                      Account account = await WalletCoinsManager.instance.getCurrentAccount();
                                      EthFeeModel ethFeeModel = await EthFeeDao.fetch(EthManager.instance.getChainID(account));

                                      print(aesDecode);
                                      print(data);
                                      print(ethFeeModel.data.feeList[1].fee);
                                      print(objectValue);
                                      print(objectTo);
                                      print(objectData);
                                      print(rpcUrl);

                                      BoxApp.signTransactionETH((signData) {
                                        print("signData："+signData);
                                        var callback = "window.ethereum.sendResponse($id, [\"$signData\"])";
                                        webViewController.evaluateJavascript(callback);
                                        return;
                                      }, (error) {
                                        print(error);
                                        return;
                                      },
                                          aesDecode,
                                          data,
                                          ethFeeModel.data.feeList[1].fee,
                                          objectValue,
                                          objectTo,
                                          objectData,
                                          rpcUrl);

                                    },
                                  ),
                                ),
                              );
                            });

                        return;
                      }, objectFrom, objectTo, objectValue, objectData, rpcUrl);
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
