import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:box/dao/conflux/cfx_balance_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../main.dart';
import 'cfx_home_page.dart';
import 'cfx_select_token_list_page.dart';

class CfxTokenSendTwoPage extends StatefulWidget {
  final String address;

  final String? tokenName;
  final String? tokenCount;
  final String? tokenImage;
  final String? tokenContract;

  CfxTokenSendTwoPage({Key? key, required this.address, this.tokenName, this.tokenCount, this.tokenImage, this.tokenContract}) : super(key: key);

  @override
  _CfxTokenSendTwoPageState createState() => _CfxTokenSendTwoPageState();
}

class _CfxTokenSendTwoPageState extends State<CfxTokenSendTwoPage> {
  late Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String address = '';
  var loadingType = LoadingType.loading;
  List<Widget> items = <Widget>[];

  String? tokenName;
  String? tokenCount;
  String? amountAll;
  String? tokenImage;
  String? tokenContract;

  @override
  void initState() {
    super.initState();
    this.tokenName = "CFX";
    this.tokenCount = CfxHomePage.token;
    this.tokenImage = "https://ae-source.oss-cn-hongkong.aliyuncs.com/CFX.png";

    if (widget.tokenName != null) {
      this.tokenName = widget.tokenName;
    }
    if (widget.tokenCount != null) {
      this.tokenCount = widget.tokenCount;
    }
    if (widget.tokenImage != null) {
      this.tokenImage = widget.tokenImage;
    }
    if (widget.tokenContract != null) {
      this.tokenContract = widget.tokenContract;
    }

    if (widget.tokenContract == null) {}
    netCfxBalance();
    getAddress();
  }

  void netCfxBalance() {
    CfxBalanceDao.fetch().then((CfxBalanceModel model) {
      CfxHomePage.token = Utils.cfxFormatAsFixed(model.balance, 5);
      this.tokenCount = CfxHomePage.token;
      this.amountAll = CfxHomePage.token;
      print(amountAll);
      setState(() {});
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF37A1DB),
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
          ), systemOverlayStyle: SystemUiOverlayStyle.light,
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
                              color: Color(0xFF37A1DB),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                  Color(0xFF37A1DB),
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
                                    Utils.formatAddressCFX(address),
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
                                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
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
                                              borderSide: BorderSide(color: Color(0xFF37A1DB)),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 19,
                                              color: Colors.black.withAlpha(80),
                                            ),
                                          ),
                                          cursorColor: Color(0xFF37A1DB),
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
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF37A1DB)),
                                              ),
                                              color: Color(0xFF37A1DB).withAlpha(16),
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
                                            builder: (context) => CfxSelectTokenListPage(
                                                  aeCount: CfxHomePage.token,
                                                  aeSelectTokenListCallBackFuture: (String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract) {
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
                                                        border: Border(
                                                            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                            top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                            left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                            right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                        borderRadius: BorderRadius.circular(36.0),
                                                      ),
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          tokenImage!,
                                                          errorBuilder: (
                                                            BuildContext context,
                                                            Object error,
                                                            StackTrace? stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: Colors.grey.shade200,
                                                            );
                                                          },
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
                                                      )),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      tokenName == null ? "" : tokenName!,
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
                                              right: 20,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    tokenCount == null ? "" : tokenCount!,
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15,
                                                    color: Color(0xFF333333),
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
                          if (double.parse(this.amountAll!) < 0.002) {
                            return;
                          }
                          netSendV2(context);
                        },
                        child: amountAll == null
                            ? Container(
                                alignment: Alignment.center,
                                child: new Center(
                                  child: new CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                                  ),
                                ),
                                width: 20.0,
                                height: 20.0,
                              )
                            : Text(
                                double.parse(this.amountAll!) > 0.002 ? S.of(context).token_send_two_page_conform : S.of(context).fee_low,
                                maxLines: 1,
                                style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                              ),
                        color: ( amountAll==null || double.parse(this.amountAll!) > 0.002 ) ? Color(0xFF37A1DB) : Color(0xFF999999),
                        // color: Color(0xFF37A1DB),
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
    if (this.tokenContract == "" || this.tokenContract == null) {
      if (double.parse(tokenCount!) == 0) {
        _textEditingController.text = "0";
      } else {
        print(this.tokenCount);
        if (double.parse(this.tokenCount!) > (0.001 * 2)) {
          _textEditingController.text = (double.parse(this.tokenCount!) - ((0.001 * 2))).toStringAsFixed(8);
        } else {
          _textEditingController.text = "0";
        }
      }
    } else {
      if (double.parse(tokenCount!) > 1) {
        _textEditingController.text = (double.parse(tokenCount!)).toStringAsFixed(5);
      } else {
        if (double.parse(tokenCount!) == 0) {
          _textEditingController.text = "0";
        } else {
          _textEditingController.text = (double.parse(tokenCount!)).toStringAsFixed(5);
        }
      }
    }
    _textEditingController.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length));
  }

  getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
      });
    });
  }

  Widget getIconImage(String data, String name) {
    if (data == null) {
      return Container(
        width: 27.0,
        height: 27.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(36.0),
          image: DecorationImage(
            image: AssetImage("images/" + "CFX" + ".png"),
          ),
        ),
      );
    }
    if ("CFX" != name) {
      if (name == "FC") {
        return Container(
          width: 27.0,
          height: 27.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(36.0),
            image: DecorationImage(
              image: AssetImage("images/" + name + ".png"),
            ),
          ),
        );
      }
      String icon = data.split(',')[1]; //
      if (data.contains("data:image/png")) {
        Uint8List bytes = Base64Decoder().convert(icon);
        return Image.memory(bytes, fit: BoxFit.contain);
      }

      if (data.contains("data:image/svg")) {
        Uint8List bytes = Base64Decoder().convert(icon);

        return SvgPicture.memory(
          bytes,
          semanticsLabel: 'A shark?!',
          placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
        );
      }
    }
    return Container(
      width: 27.0,
      height: 27.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(36.0),
        image: DecorationImage(
          image: AssetImage("images/" + "CFX" + ".png"),
        ),
      ),
    );
  }

  String getReceiveAddress() {
    return Utils.formatAddressCFX(widget.address);
  }

  Future<void> netSendV2(BuildContext context) async {
    if (_textEditingController.text == "") {
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Text(S.of(context).dialog_hint),
            content: Text(S.of(context).dialog_amount_null),
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
    if (tokenContract == null || tokenContract == "") {
//      startLoading();
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
                    // ignore: missing_return
                    BoxApp.spendCFX((tx) {
                      showCopyHashDialog(context, tx);

                      // ignore: missing_return
                    }, (error) {
                      showErrorDialog(context, error);
                    }, aesDecode, widget.address, _textEditingController.text);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    } else {
//      startLoading();
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
                    // ignore: missing_return
                    BoxApp.spendErc20CFX((tx) {
                      showCopyHashDialog(context, tx);
                      // ignore: missing_return
                    }, (error) {
                      showErrorDialog(context, error);
                      // ignore: missing_return
                    }, aesDecode, widget.address, tokenContract!, _textEditingController.text);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    }
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
          return ChainLoadingWidget();
        });
  }

  void showFlushSucess(BuildContext context) {
    flush = Flushbar<bool>(
      title: S.of(context).hint_broadcast_sucess,
      message: S.of(context).hint_broadcast_sucess_hint,
      backgroundGradient: LinearGradient(colors: [Color(0xFF37A1DB), Color(0xFF37A1DB)]),
      backgroundColor: Color(0xFF37A1DB),
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

  void showCopyHashDialog(BuildContext buildContext, String tx) {
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.of(buildContext).dialog_hint_hash),
          content: Text(tx),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_copy,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
            ),
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_dismiss,
              ),
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop(false);
              },
            ),
          ],
        );
      },
    ).then((val) {
      if (val!) {
        Clipboard.setData(ClipboardData(text: "https://confluxscan.io/transaction/" + tx));
        showFlushSucess(context);
      } else {
        showFlushSucess(context);
      }
    });
  }
}
