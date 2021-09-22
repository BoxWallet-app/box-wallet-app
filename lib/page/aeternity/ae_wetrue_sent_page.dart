import 'package:box/dao/aeternity/wetrue_config_dao.dart';
import 'package:box/dao/aeternity/wetrue_topic_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/wetrue_config_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../main.dart';
import 'ae_home_page.dart';

class AeWeTrueSendPage extends StatefulWidget {
  @override
  _AeWeTrueSendPageState createState() => _AeWeTrueSendPageState();
}

class _AeWeTrueSendPageState extends State<AeWeTrueSendPage> {
  TextEditingController _textEditingController = TextEditingController();
  WeTrueConfigModel weTrueConfigModel;
  Flushbar flush;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "";
    netWeTrueConfig();
//    _textEditingController.text = "memory pool equip lesson limb naive endorse advice lift result track gravity";
  }

  void netWeTrueConfig() {
    WeTrueConfigDao.fetch().then((WeTrueConfigModel model) {
      weTrueConfigModel = model;
      setState(() {});
    }).catchError((e) {
      //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
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
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                    "WeTrue发帖",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(
                    "该内容将录入到AE区块链中永久保存，上链将会花费矿工费用，请不要上传色情政治等违法信息，共建和谐AE生态。",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        border: Border.all(color: Color(0xFFEEEEEE)),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextField(
                      controller: _textEditingController,

                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      maxLines: 10,

                      decoration: InputDecoration(
                        hintText: '请输入内容 ...',
                        enabledBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000)),
                        ),
// and:
                        focusedBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000)),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 19,
                          fontFamily:
                              BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black.withAlpha(80),
                        ),
                      ),
                      cursorColor: Color(0xFFFC2365),
                      cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                    ),
                  ),
                ),
//              Container(
//                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//                width: MediaQuery.of(context).size.width,
//                child: Wrap(
//                  spacing: 10, //主轴上子控件的间距
//                  runSpacing: 10, //交叉轴上子控件之间的间距
//                  children: childrenFalse,
//                ),
//              ),
                Container(
                  margin: EdgeInsets.only(left: 26, top: 10, right: 26),
                  alignment: Alignment.topRight,
                  child: Text(
                    S.of(context).token_send_two_page_balance +
                        " : " +
                        AeHomePage.token +
                        " AE",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                if (weTrueConfigModel != null)
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 50),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () {
                          clickLogin();
                        },
                        child: Text(
                          weTrueConfigModel == null
                              ? ""
                              : " " +
                                  "发布" +
                                  " ≈ " +
                                  Decimal.parse(
                                          (weTrueConfigModel.data.topicAmount /
                                                  1000000000000000000)
                                              .toString())
                                      .toString() +
                                  " AE",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily:
                                  BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              color: Color(0xffffffff)),
                        ),
                        color: Color(0xFFFC2365),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
              ],
            ),
          )),
        ));
  }

  clickLogin() {
    if (_textEditingController.text == null) {
      return;
    }
    if (_textEditingController.text == "") {
      EasyLoading.showToast('请输入内容', duration: Duration(seconds: 2));
      return;
    }


    String content = Utils.encodeBase64('{"WeTrue":"' +
        weTrueConfigModel.data.weTrue +
        '","type":"topic","source":"Box æpp","content":"' +
        _textEditingController.text.replaceAll("\n", "\\n") +
        '"}');
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
                    // EasyLoading.show();
                    WeTrueTopicDao.fetch(tx).then((bool model) {
                      EasyLoading.dismiss(animation: true);

                    }).catchError((e) {
                      EasyLoading.dismiss(animation: true);

                    });
                    showFlushSucess(context);
                    setState(() {});
                    // ignore: missing_return
                  }, (error) {
                   showErrorDialog(context, error);
                  },
                      aesDecode,
                      address,
                      weTrueConfigModel.data.receivingAccount,
                      Decimal.parse((weTrueConfigModel.data.topicAmount /
                                  1000000000000000000)
                              .toString())
                          .toString(),
                      content);
                  showChainLoading();
                },
              ),
            ),
          );
        });
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
      backgroundGradient:
          LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
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
                S.of(buildContext).dialog_copy,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: tx));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_dismiss,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }
}
