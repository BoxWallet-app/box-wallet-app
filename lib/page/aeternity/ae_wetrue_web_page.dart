import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class AeWetrueWebPage extends StatefulWidget {
  const AeWetrueWebPage({Key key}) : super(key: key);

  @override
  _AeWetrueWebPageState createState() => _AeWetrueWebPageState();
}

class _AeWetrueWebPageState extends State<AeWetrueWebPage> {
  WebViewController _webViewController;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _commentFocus = FocusNode();
  double progress = 0;
  bool isPageFinish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
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
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "WETRUE WEB PAGE",
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
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
//                      padding: EdgeInsets.only(left: 10, right: 10),
            //边框设置
            decoration: new BoxDecoration(
              color: Color(0xFFedf3f7),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: TextField(
              controller: _textEditingController,
              focusNode: _commentFocus,
              inputFormatters: [],
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Color(0xFFeeeeee),
                  ),
                ),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0xFFFC2365)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: "https://",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withAlpha(180),
                ),
              ),
              cursorColor: Color(0xFFFC2365),
              cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: FlatButton(
                onPressed: () {
                  var url = _textEditingController.text;
                  _webViewController.loadUrl(url);
                },
                child: Text(
                  "访问",
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                ),
                color: Color(0xFFFC2365),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          if (!isPageFinish)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width,
                lineHeight: 5.0,
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
                initialUrl: "",
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (url) {
                  isPageFinish = true;
                  setState(() {});
                },
                onProgress: (progress) {
                  this.progress = (progress / 100);
                  setState(() {});
                },
                onWebViewCreated: (WebViewController webViewController) async {
                  this._webViewController = webViewController;
                },

                onPageStarted: (url){
                  isPageFinish = false;
                },
                javascriptChannels: [
                  JavascriptChannel(
                      name: 'WETURE_COMM_JS',
                      onMessageReceived: (JavascriptMessage message) {
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return new AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              title: new Text("WETURE_COMM_JS"),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text(message.message),
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
                          if (val) {}
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
}
