import 'dart:ui';

import 'package:box/dao/conflux/cfx_transfer_hash_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/conflux/cfx_transaction_hash_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cfx_home_page.dart';

class CfxTxDetailPage extends StatefulWidget {
  final String hash;

  const CfxTxDetailPage({Key key, this.hash}) : super(key: key);

  @override
  _CfxTxDetailPageState createState() => _CfxTxDetailPageState();
}

class _CfxTxDetailPageState extends State<CfxTxDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;
  List<Widget> baseItems = []; //先建一个数组用于存放循环生成的widget
  List<Widget> allItems = []; //先建一个数组用于存放循环生成的widget
  CfxTransactionHashModel cfxTransactionHashModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    netTopHeightData();
  }

  void addData() {
    baseItems.clear();
    var height = buildItem2(
      S.current.cfx_tx_detail_page_height,
      Container(
        height: 30,
        child: Row(
          children: [
            Expanded(child: Container()),
            Container(
              alignment: Alignment.centerRight,
              child: new Text(
                cfxTransactionHashModel.epochHeight.toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
              margin: const EdgeInsets.only(left: 30.0),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.only(left: 10, right: 10,top:5,bottom: 5),
              decoration: new BoxDecoration(
                color: Colors.green,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(15.0)),

                //设置四周边框
              ),
              child: Text(
                cfxTransactionHashModel.confirmedEpochCount.toString() + " "+S.current.cfx_tx_detail_page_height_confirm,
                maxLines: 1,
                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );

    baseItems.add(height);
    var hash = buildItem(S.current.cfx_tx_detail_page_hash, cfxTransactionHashModel.hash.toString());

    baseItems.add(hash);
    //
    // var itemType = buildItem("类型", widget.recordData.tx["type"]);
    //
    // baseItems.add(itemType);

    var itemCount = buildItem2(S.current.cfx_tx_detail_page_count, getCfxWidget(14));

    baseItems.add(itemCount);

    var itemFee = buildItem2(S.current.cfx_tx_detail_page_fee, getFeeWidget(14));

    baseItems.add(itemFee);

    var senderId = buildItem(S.current.cfx_tx_detail_page_from, Utils.cfxFormatTypeAddress(cfxTransactionHashModel.from));
    baseItems.add(senderId);

    var recipientId = buildItem(S.current.cfx_tx_detail_page_to, Utils.cfxFormatTypeAddress(cfxTransactionHashModel.to));
    baseItems.add(recipientId);

    var time = buildItem(
      S.current.cfx_tx_detail_page_time,
      DateTime.fromMicrosecondsSinceEpoch(cfxTransactionHashModel.timestamp * 1000000).toLocal().toString().substring(0, DateTime.fromMicrosecondsSinceEpoch(cfxTransactionHashModel.timestamp * 1000000).toLocal().toString().length - 4),
    );
    baseItems.add(time);
    baseItems.add(Container(
      height: MediaQueryData.fromWindow(window).padding.bottom + 30,
      width: 1,
    ));
  }

  void netTopHeightData() {
    CfxTransactionHashDao.fetch(widget.hash).then((CfxTransactionHashModel model) {
      cfxTransactionHashModel = model;
      addData();
      _loadingType = LoadingType.finish;
      setState(() {});
    }).catchError((e) {
      _loadingType = LoadingType.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 隐藏阴影
        elevation: 0,
        backgroundColor: Color(0xFFfafbfc),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                _launchURL("https://confluxscan.io/transaction/" + widget.hash);
              },
              child: Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(15),
                child: Image(
                  width: 36,
                  height: 36,
                  color: Colors.black,
                  image: AssetImage('images/ic_browser.png'),
                ),
              ),
            ),
          ),
        ],
        title: Text(
         S.current.cfx_tx_detail_page_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: LoadingWidget(
        type: _loadingType,
        onPressedError: () {
          netTopHeightData();
        },
        child: cfxTransactionHashModel == null
            ? Container()
            : SingleChildScrollView(
                // child: Column(children: items),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      alignment: Alignment.center,
                      child: getCfxWidget(34),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        color: Color(0xFF000000),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Material(
                        child: Column(
                          children: baseItems,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Text getCfxWidget(double size) {
    if (Utils.cfxFormatTypeAddress(cfxTransactionHashModel.to) == CfxHomePage.address) {
      return Text(
        "+" + double.parse(((double.parse(cfxTransactionHashModel.value)) / 1000000000000000000).toString()).toStringAsFixed(6) + " CFX",
        style: TextStyle(color: Colors.red, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    } else {
      return Text(
        "-" + double.parse((((double.parse(cfxTransactionHashModel.value)) / 1000000000000000000)).toString()).toStringAsFixed(6) + " CFX",
        style: TextStyle(color: Colors.green, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }
  }

  Text getFeeWidget(double size) {
    var decimal = Decimal.parse('1000000000000000000');
    var decimal2 = Decimal.parse(int.parse(cfxTransactionHashModel.gas).toString());
    var decimal3 = decimal2 / decimal;
    var storageLimit = Decimal.parse((int.parse(cfxTransactionHashModel.storageLimit).toString()));
    var formatGas = double.parse(decimal3.toString()) + (double.parse(storageLimit.toString())/1024);
    return Text(
      Decimal.parse(formatGas.toString()).toString() + " Cfx",
      style: TextStyle(color: Colors.black, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    );
  }

  Widget buildItem(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Material(
        color: Color(0xFFffffff),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));

            Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                      value,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
    );
  }

  Widget buildItem2(String key, Widget text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Material(
        color: Color(0xFFffffff),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          child: Container(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                /*1*/
                Column(
                  children: [
                    /*2*/
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    ),
                  ],
                ),
                /*3*/
                Expanded(
                  child: Container(alignment: Alignment.centerRight, child: text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
