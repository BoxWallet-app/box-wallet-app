import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/dao/conflux/cfx_web_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/manager/plugin_manager.dart';
import 'package:box/manager/web_manager.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/conflux/cfx_dapp_list_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/model/conflux/cfx_web_list_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';

import '../main.dart';
import 'confux/cfx_rpc_page.dart';
import 'confux/cfx_token_record_page.dart';
import 'dapp_webview_page.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key key}) : super(key: key);

  @override
  _CfxWebPathState createState() => _CfxWebPathState();
}

class _CfxWebPathState extends State<WebPage> {
  var loadingType = LoadingType.finish;
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  CfxTokensListModel tokenListModel;
  CfxWebListModel cfxWebListModel;

  List<String> urls = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textEditingControllerNode.addListener(() {
      setState(() {});
    });

    _onRefresh();
  }

  Future<void> _onRefresh() async {
    var address = await BoxApp.getAddress();
    urls = await WebManager.instance.getUrls(address);
    urls.reversed;
    setState(() {});
    CfxWebListDao.fetch(BoxApp.language).then((CfxWebListModel model) {
      cfxWebListModel = model;
      setState(() {});
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
        },
        child: Column(
          children: [
            Container(
              height: MediaQueryData.fromWindow(window).padding.top + 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 18),
                          decoration: new BoxDecoration(
                            // boxShadow: [BoxShadow(color: Colors.grey.withAlpha(50), blurRadius: 100.0)],
                            color: Colors.white,
                            border: new Border.all(color: Color(0xFF000000).withAlpha(20), width: 1),
                            borderRadius: new BorderRadius.circular((100.0)),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: new BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  controller: _textEditingControllerNode,
                                  focusNode: focusNodeNode,
                                  inputFormatters: [
                                    // WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                                  ],
                                  maxLines: 1,

                                  style: TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
                                    fontSize: 16,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    color: Colors.black,
                                  ),

                                  decoration: InputDecoration(

                                    hintText: S.of(context).input_search_hint,
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.search,
                                        size: 18,
                                        color: Color(0xff999999),
                                      ),
                                    ),
                                    suffixIcon: _textEditingControllerNode.text != ""
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Color(0xff999999),
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _textEditingControllerNode.clear();
                                            },
                                          )
                                        : Container(
                                            width: 1,
                                          ),
                                    contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                      ),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Color(0x00000000)),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF666666).withAlpha(85),
                                    ),
                                  ),
                                  cursorColor: Color(0xFFFC2365),
                                  cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Text(
                      S.of(context).CfxWebPage_dismiss,
                      style: TextStyle(
                        fontSize: 14,

                        //字体间距

                        //词间距
                        color: Color(0xFF666666),
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (_textEditingControllerNode.text != "")
              Container(
                margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Material(
                  color: Color(0xFFE61665).withAlpha(16),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Text(
                        S.of(context).web_go + _textEditingControllerNode.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE61665),
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    ),
                    onTap: () async {
                      String url = _textEditingControllerNode.text;
                      if (!url.contains("https://")) {
                        EasyLoading.showToast(S.of(context).input_error_msg, duration: Duration(seconds: 2));
                        return;
                      }

                      showGeneralDialog(
                          useRootNavigator: false,
                          context: context,
                          pageBuilder: (context, anim1, anim2) {},
                          //barrierColor: Colors.grey.withOpacity(.4),
                          barrierDismissible: true,
                          barrierLabel: "",
                          transitionDuration: Duration(milliseconds: 0),
                          transitionBuilder: (context, anim1, anim2, child) {
                            final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                            return Transform(
                                transform: Matrix4.translationValues(0.0, 0, 0.0),
                                child: Opacity(
                                    opacity: anim1.value,
                                    // ignore: missing_return
                                    child: Material(
                                      type: MaterialType.transparency, //透明类型
                                      child: Center(
                                        child: Container(
                                          height: 470,
                                          width: MediaQuery.of(context).size.width - 40,
                                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          decoration: ShapeDecoration(
                                            color: Color(0xffffffff),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width - 40,
                                                alignment: Alignment.topLeft,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.all(Radius.circular(60)),
                                                    onTap: () async {
                                                      Navigator.pop(context); //关闭对话框
                                                    },
                                                    child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 20, right: 20),
                                                child: Text(
                                                  S.of(context).dialog_privacy_hint,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 270,
                                                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    child: Text(
                                                      S.of(context).cfx_dapp_mag1 + " " + url + " " + S.of(context).cfx_dapp_mag2,
                                                      style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 30, bottom: 20),
                                                child: TextButton(
                                                  //定义一下文本样式
                                                  style: ButtonStyle(
                                                    //更优美的方式来设置
                                                    shape: MaterialStateProperty.all(StadiumBorder()),
                                                    //设置水波纹颜色
                                                    overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                                                    //背景颜色
                                                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                      //设置按下时的背景颜色
                                                      if (states.contains(MaterialState.pressed)) {
                                                        return Color(0xFFFC2365).withAlpha(200);
                                                      }
                                                      //默认不使用背景颜色
                                                      return Color(0xFFFC2365);
                                                    }),
                                                    //设置按钮内边距
                                                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                                                  ),

                                                  child: Text(
                                                    S.of(context).dialog_privacy_confirm,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context); //关闭对话框
                                                    var address = await BoxApp.getAddress();
                                                    List<String> urls = await WebManager.instance.getUrls(address);

                                                    if (!urls.contains(url)) {
                                                      urls.add(url);
                                                    }

                                                    await WebManager.instance.updateUrls(address, urls);
                                                    _onRefresh();
                                                    Navigator.push(
                                                        navigatorKey.currentState.overlay.context,
                                                        MaterialPageRoute(
                                                            builder: (context) => DappWebViewPage(
                                                                  url: url,
                                                                  title: url,
                                                                )));
                                                  },
                                                ),
                                              ),

                                              //          Text(text),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )));
                          });
                    },
                  ),
                ),
              ),
            if (cfxWebListModel != null)
              Container(
                height: 48,
                margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).CfxWebPage_dismiss_tab1,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: BoxApp.language == "cn"
                        ? "Ubuntu"
                        : BoxApp.language == "cn"
                            ? "Ubuntu"
                            : "Ubuntu",
                  ),
                ),
              ),
            if (cfxWebListModel != null)
              Container(
                margin: const EdgeInsets.only(top: 8, left: 20, bottom: 18),
                child: Row(
                  children: getTabs(cfxWebListModel.data),
                ),
              ),
            if (urls != null && urls.length != 0)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).CfxWebPage_dismiss_tab2,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: BoxApp.language == "cn"
                              ? "Ubuntu"
                              : BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : "Ubuntu",
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    onTap: () {
                      showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return new AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            title: new Text(
                              S.of(context).CfxWebPage_dismiss_tab1,
                            ),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  new Text(S.of(context).dialog_web_clear_content),
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
                        if (val) {
                          var address = await BoxApp.getAddress();
                          await WebManager.instance.updateUrls(address, []);
                          _onRefresh();
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.all(6),
                            child: Image(
                              width: 36,
                              height: 36,
                              color: Color(0xff666666),
                              image: AssetImage('images/web_clear.png'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (urls != null && urls.length != 0)
              Expanded(
                child: Container(
                  child: EasyRefresh(
                    header: BoxHeader(),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
                      itemCount: urls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return itemListView(context, index);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> getTabs(List<CfxWebListModelData> data) {
    List<Widget> tabsWidget = List<Widget>();
    for (var i = 0; i < data.length; i++) {
      tabsWidget.add(InkWell(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        onTap: () async {
          await goWebPage(data[i].url, BoxApp.language == "cn" ? data[i].nameCn : data[i].nameEn);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
          decoration: new BoxDecoration(
            color: Color(0xFF37A1DB).withAlpha(16),
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Text(
            BoxApp.language == "cn" ? data[i].nameCn : data[i].nameEn,
            style: TextStyle(
              fontSize: 14,

              //字体间距

              //词间距
              color: Color(0xFF37A1DB),
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            ),
          ),
        ),
      ));
    }
    return tabsWidget;
  }

  Future<void> goWebPage(url, name) async {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (context, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, 0, 0.0),
              child: Opacity(
                  opacity: anim1.value,
                  // ignore: missing_return
                  child: Material(
                    type: MaterialType.transparency, //透明类型
                    child: Center(
                      child: Container(
                        height: 470,
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: ShapeDecoration(
                          color: Color(0xffffffff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              alignment: Alignment.topLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(60)),
                                  onTap: () async {
                                    Navigator.pop(context); //关闭对话框

                                    // ignore: unnecessary_statements
                                    //                                  widget.dismissCallBackFuture("");
                                  },
                                  child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                S.of(context).dialog_privacy_hint,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                            ),
                            Container(
                              height: 270,
                              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: SingleChildScrollView(
                                child: Container(
                                  child: Text(
                                    S.of(context).cfx_dapp_mag1 + " " + name + " " + S.of(context).cfx_dapp_mag2,
                                    style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30, bottom: 20),
                              child: TextButton(
                                //定义一下文本样式
                                style: ButtonStyle(
                                  //更优美的方式来设置
                                  shape: MaterialStateProperty.all(StadiumBorder()),
                                  //设置水波纹颜色
                                  overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                                  //背景颜色
                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                    //设置按下时的背景颜色
                                    if (states.contains(MaterialState.pressed)) {
                                      return Color(0xFFFC2365).withAlpha(200);
                                    }
                                    //默认不使用背景颜色
                                    return Color(0xFFFC2365);
                                  }),
                                  //设置按钮内边距
                                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                                ),

                                child: Text(
                                  S.of(context).dialog_privacy_confirm,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context); //关闭对话框
                                  var address = await BoxApp.getAddress();
                                  List<String> urls = await WebManager.instance.getUrls(address);

                                  if (!urls.contains(url)) {
                                    urls.add(url);
                                  }

                                  await WebManager.instance.updateUrls(address, urls);
                                  _onRefresh();
                                  Navigator.push(
                                      navigatorKey.currentState.overlay.context,
                                      MaterialPageRoute(
                                          builder: (context) => DappWebViewPage(
                                                url: url,
                                                title: url,
                                              )));
                                },
                              ),
                            ),

                            //          Text(text),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }

  Widget itemListView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () async {
            goWebPage(urls[index], urls[index]);
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              urls[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff666666),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*3*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
