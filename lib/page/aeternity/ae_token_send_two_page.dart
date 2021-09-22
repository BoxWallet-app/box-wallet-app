
import 'package:box/dao/aeternity/account_info_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../main.dart';
import 'ae_home_page.dart';
import 'ae_select_token_list_page.dart';

class AeTokenSendTwoPage extends StatefulWidget {
  final String address;

  AeTokenSendTwoPage({Key key, @required this.address}) : super(key: key);

  @override
  _AeTokenSendTwoPageState createState() => _AeTokenSendTwoPageState();
}

class _AeTokenSendTwoPageState extends State<AeTokenSendTwoPage> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String address = '';
  var loadingType = LoadingType.loading;
  List<Widget> items = List<Widget>();

  String tokenName;
  String tokenCount;
  String tokenImage;
  String tokenContract;

  @override
  void initState() {
    super.initState();
    this.tokenName = "AE";
    this.tokenCount = AeHomePage.token;
    this.tokenImage = "https://ae-source.oss-cn-hongkong.aliyuncs.com/ae.png";
    netAccountInfo();
    getAddress();
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        AeHomePage.token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Color(0xFFFC2365),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 130,
                              color: Color(0xFFFC2365),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                  Color(0xFFFC2365),
                                  Color(0xFFEEEEEE),
                                ]),
                              ),
                              height: 190,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
                              child: Text(
                                S.of(context).token_send_two_page_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    S.of(context).token_send_two_page_from,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    Utils.formatAddress(address),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    S.of(context).token_send_two_page_to,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    getReceiveAddress(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(20),
                              height: 172,
                              //边框设置
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: [
//                                    BoxShadow(
//                                        color: Colors.black12,
//                                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                        blurRadius: 15.0, //阴影模糊程度
//                                        spreadRadius: 1.0 //阴影扩散程度
//                                        )
                                  ]
                                  //设置四周边框
                                  ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).token_send_two_page_number,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 0, right: 18),
                                    child: Stack(
                                      children: <Widget>[
                                        TextField(
//                                          autofocus: true,

                                          controller: _textEditingController,
                                          focusNode: focusNode,
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
                                          ],

                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '',
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 19,
                                              color: Colors.black.withAlpha(80),
                                            ),
                                          ),
                                          cursorColor: Color(0xFFFC2365),
                                          cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 12,
                                          child: Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(top: 0),
                                            child: FlatButton(
                                              onPressed: () {
                                                clickAllCount();
                                              },
                                              child: Text(
                                                S.of(context).token_send_two_page_all,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                                              ),
                                              color: Color(0xFFE61665).withAlpha(16),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            expand: true,
                                            enableDrag: false,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => AeSelectTokenListPage(
                                                  aeCount: AeHomePage.token,
                                                  aeSelectTokenListCallBackFuture: (String tokenName, String tokenCount, String tokenImage, String tokenContract) {
                                                    this.tokenName = tokenName;
                                                    this.tokenCount = tokenCount;
                                                    this.tokenImage = tokenImage;
                                                    this.tokenContract = tokenContract;
                                                    setState(() {});
                                                    return;
                                                  },
                                                )
//
                                            );
                                      },
                                      child: Container(
                                        height: 55,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 18),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 36.0,
                                                    height: 36.0,
                                                    decoration: BoxDecoration(
                                                      border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(36.0),
                                                    ),
                                                    child: tokenImage != null
                                                        ? ClipOval(
                                                            child: Image.network(
                                                              tokenImage,
                                                              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                if (wasSynchronouslyLoaded) return child;

                                                                return AnimatedOpacity(
                                                                  child: child,
                                                                  opacity: frame == null ? 0 : 1,
                                                                  duration: const Duration(seconds: 2),
                                                                  curve: Curves.easeOut,
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : null,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      tokenName == null ? "" : tokenName,
                                                      style: new TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 28,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    tokenCount == null ? "" : tokenCount,
                                                    style: TextStyle(
                                                      color: Color(0xFF666666),
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15,
                                                    color: Color(0xFF666666),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () {
                          netSendV2(context);
                        },
                        child: Text(
                          S.of(context).token_send_two_page_conform,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                        ),
                        color: Color(0xFFFC2365),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
//
  }

  void clickAllCount() {
    if (double.parse(tokenCount) > 1) {
      _textEditingController.text = (double.parse(tokenCount) - 0.1).toString();
    } else {
      _textEditingController.text = tokenCount;
    }

    _textEditingController.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length));
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
      });
    });
  }

  String getReceiveAddress() {
    return Utils.formatAddress(widget.address);
  }

  Future<void> netSendV2(BuildContext context) async {
    if (_textEditingController.text == "") {
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
            title: Text(S.of(context).dialog_hint),
            content: Text("请输入数量"),
            actions: <Widget>[
              TextButton(
                child: new Text(
                  S.of(context).dialog_conform,
                ),
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(false);
                },
              ),
            ],
          );
        },
      ).then((val) {});
      return;
    }
    focusNode.unfocus();
    var senderID = await BoxApp.getAddress();
    if (tokenContract == null || tokenContract == "") {
//      startLoading();
      showGeneralDialog(useRootNavigator:false,
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
                  title: S.of(context).password_widget_input_password,
                  dismissCallBackFuture: (String password) {
                    return;
                  },
                  passwordCallBackFuture: (String password) async {
                    var signingKey = await BoxApp.getSigningKey();
                    var address = await BoxApp.getAddress();
                    final key = Utils.generateMd5Int(password + address);
                    var aesDecode = Utils.aesDecode(signingKey, key);

                    if (aesDecode == "") {
                      showErrorDialog(context, null);
                      return;
                    }
                    // ignore: missing_return
                    BoxApp.spend((tx) {
                      showCopyHashDialog(context, tx);

                      // ignore: missing_return
                    }, (error) {
                      showErrorDialog(context, error);
                    }, aesDecode, address, widget.address, _textEditingController.text, Utils.encodeBase64("Box aepp"));
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    } else {
//      startLoading();
      showGeneralDialog(useRootNavigator:false,
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
                  title: S.of(context).password_widget_input_password,
                  dismissCallBackFuture: (String password) {
                    return;
                  },
                  passwordCallBackFuture: (String password) async {
                    var signingKey = await BoxApp.getSigningKey();
                    var address = await BoxApp.getAddress();
                    final key = Utils.generateMd5Int(password + address);
                    var aesDecode = Utils.aesDecode(signingKey, key);

                    if (aesDecode == "") {
                      showErrorDialog(context, null);
                      return;
                    }
                    // ignore: missing_return
                    BoxApp.contractTransfer((tx) {
                      showCopyHashDialog(context, tx);
                      // ignore: missing_return
                    }, (error) {
                      showErrorDialog(context, error);
                      // ignore: missing_return
                    }, aesDecode, address, tokenContract, widget.address, _textEditingController.text, "full");
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    }
  }

  void showChainLoading() {
    showGeneralDialog(useRootNavigator:false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }

  void showFlushSucess(BuildContext context) {
    flush = Flushbar<bool>(
      title: S.of(context).hint_broadcast_sucess,
      message: S.of(context).hint_broadcast_sucess_hint,
      backgroundGradient: LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
      backgroundColor: Color(0xFFFC2365),
      blockBackgroundInteraction: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      //                        flushbarStyle: FlushbarStyle.GROUNDED,

      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true); // result = true
        },
        child: Text(
          S.of(context).dialog_conform,
          style: TextStyle(color: Colors.white),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(80),
          offset: Offset(0.0, 2.0),
          blurRadius: 13.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
      });
  }

  void showErrorDialog(BuildContext buildContext, String content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
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

  void showCopyHashDialog(BuildContext buildContext, String tx) {
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
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
      if (val) {
        Clipboard.setData(ClipboardData(text: tx));
        showFlushSucess(context);
      } else {
        showFlushSucess(context);
      }
    });
  }
}
