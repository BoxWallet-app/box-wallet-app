import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/aens_info_dao.dart';
import 'package:box/dao/aeternity/name_owner_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/name_owner_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_aens_point_page.dart';
import 'package:box/page/aeternity/ae_aens_transfer_page.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/amount_text_field_formatter.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AensSellPutPage extends BaseWidget {
  final String name;

  AensSellPutPage({
    Key? key,
    required this.name,
  });

  @override
  _AeAensDetailPageState createState() => _AeAensDetailPageState();
}

class _AeAensDetailPageState extends BaseWidgetState<AensSellPutPage> {
  TextEditingController _amountControllerNode = TextEditingController();
  final FocusNode amountFocusNodeNode = FocusNode();

  TextEditingController _dayControllerNode = TextEditingController();
  final FocusNode heightFocusNodeNode = FocusNode();
  var loadingType = LoadingType.loading;
  double nameMaxPrice = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountControllerNode.addListener(() {
      setState(() {});
    });
    aeAensMarketGetNameMaxPrice();
  }

  Future<void> aeAensMarketGetNameMaxPrice() async {
    var params = {
      "name": "aeAensMarketGetNameMaxPrice",
      "params": {"ctAddress": "ct_2WuCtC97tmkBcFG83YhbNf1E8PeBnhrJJ21NCqFgbDA8UB9Bue", "name": widget.name}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      loadingType = LoadingType.finish;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      nameMaxPrice = double.parse(jsonResponse["result"]["amount"]);
      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> aeAensMarketPutName() async {
    var amount = _amountControllerNode.text.toString();
    if (amount == "") {
      Fluttertoast.showToast(msg: "请输入挂单金额", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      return;
    }
    var day = _dayControllerNode.text.toString();
    if (day == "") {
      Fluttertoast.showToast(msg: "请输入挂单时长", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      return;
    }
    var height = double.parse(day) * 480;


    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      var params = {
        "name": "aeAensMarketPutName",
        "params": {"secretKey": privateKey, "ctAddress": "ct_2WuCtC97tmkBcFG83YhbNf1E8PeBnhrJJ21NCqFgbDA8UB9Bue", "name": widget.name, "amount": _amountControllerNode.text, "height": height.toString()}
      };
      var channelJson = json.encode(params);
      showChainLoading("正在添加...");
      setState(() {});
      BoxApp.sdkChannelCall((result) async {
        try {
          await Dio().get("http://47.52.111.71:8000/aens/update?name=" + widget.name);
        } catch (e) {}

        dismissChainLoading();

        if (!mounted) return;
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];

        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S.of(context).dialog_hint, message);
          return;
        }
        showFlushSucess(context, title: "添加成功", message: "成功添加域名" + widget.name);
        eventBus.fire(AensUpdateEvent());
        return;
      }, channelJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "挂单域名",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: LoadingWidget(
          type: loadingType,
          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 12),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              children: [
                                /*1*/
                                Column(
                                  children: [
                                    /*2*/
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "挂单域名",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                /*3*/
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: new Text(
                                      widget.name,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(left: 30.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 12),
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: [
                            /*1*/
                            Column(
                              children: [
                                /*2*/
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "挂单价格",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /*3*/
                            Expanded(
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      // height: 70,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                                      //边框设置
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _amountControllerNode,
                                              focusNode: amountFocusNodeNode,
//              inputFormatters: [
//                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
//              ],
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
                                                CustomTextFieldFormatter(digit: 6),
                                              ],
                                              textAlign: TextAlign.right,
                                              maxLines: 1,
                                              style: TextStyle(
                                                textBaseline: TextBaseline.alphabetic,
                                                fontSize: 18,
                                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "0.00",
                                                // contentPadding: EdgeInsets.only(left: 10.0),
                                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
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
                                                  fontSize: 18,
                                                  color: Color(0x00000000).withAlpha(85),
                                                ),
                                              ),
                                              cursorColor: Color(0xFFFC2365),
                                              cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "AE",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 12),
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: [
                            /*1*/
                            Column(
                              children: [
                                /*2*/
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "挂单天数",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /*3*/
                            Expanded(
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      // height: 70,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                                      //边框设置
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _dayControllerNode,
                                              focusNode: heightFocusNodeNode,
//              inputFormatters: [
//                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
//              ],
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[0-9]")), //只允许输入字母
                                                CustomTextFieldFormatter(digit: 6),
                                              ],
                                              textAlign: TextAlign.right,
                                              maxLines: 1,
                                              style: TextStyle(
                                                textBaseline: TextBaseline.alphabetic,
                                                fontSize: 18,
                                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "0",
                                                // contentPadding: EdgeInsets.only(left: 10.0),
                                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
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
                                                  fontSize: 18,
                                                  color: Color(0x00000000).withAlpha(85),
                                                ),
                                              ),
                                              cursorColor: Color(0xFFFC2365),
                                              cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "天 ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 30),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FlatButton(
                          onPressed: () {
                            aeAensMarketPutName();
                          },
                          child: Text(
                            getConfirmText(),
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                          ),
                          color: Color(0xff6F53A1),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getConfirmText() {
    var amount;
    try {
      amount = double.parse(_amountControllerNode.text);
    } catch (e) {
      amount = 0.0;
    }

    if (amount > nameMaxPrice) {
      return "确认挂单(" + (amount / 100).toString() + "手续费)";
    }

    return "确认挂单";
  }
}
