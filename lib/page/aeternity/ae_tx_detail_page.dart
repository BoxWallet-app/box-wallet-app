import 'dart:ui';

import 'package:box/dao/aeternity/block_top_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AeTxDetailPage extends StatefulWidget {
  final RecordData recordData;

  const AeTxDetailPage({Key key, this.recordData}) : super(key: key);

  @override
  _AeTxDetailPageState createState() => _AeTxDetailPageState();
}

class _AeTxDetailPageState extends State<AeTxDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;
  List<Widget> baseItems = []; //先建一个数组用于存放循环生成的widget
  List<Widget> allItems = []; //先建一个数组用于存放循环生成的widget

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingType = LoadingType.finish;

    var height = buildItem2(S.current.ae_tx_detail_page_height,  Container(
      height: 30,
      margin: const EdgeInsets.only(top: 0),
      child: Row(
        children: [
          Expanded(child: Container()),
          Container(
            alignment: Alignment.centerRight,
            child: new Text(
              widget.recordData.blockHeight.toString(),
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
            padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
            decoration: new BoxDecoration(
              color:Colors.green,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
            child: Text(
              (AeHomePage.height - widget.recordData.blockHeight).toString()+" "+S.current.ae_tx_detail_page_height_confirm,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: BoxApp.language == "cn"
                      ? "Ubuntu"
                      : "Ubuntu",
                  color: Color(0xFFFFFFFF)),
            ),
          ),

        ],
      ),
    ),);

    baseItems.add(height);
    var hash = buildItem(S.current.ae_tx_detail_page_hash, widget.recordData.hash);

    baseItems.add(hash);

    var itemType = buildItem(S.current.ae_tx_detail_page_type, widget.recordData.tx["type"]);

    baseItems.add(itemType);

    var itemFee = buildItem2(S.current.ae_tx_detail_page_count, getFeeWidget(14));

    baseItems.add(itemFee);

    if (widget.recordData.tx["type"] == "SpendTx") {
      var senderId = buildItem(S.current.ae_tx_detail_page_from, widget.recordData.tx["sender_id"]);
      baseItems.add(senderId);

      var recipientId = buildItem(S.current.ae_tx_detail_page_to, widget.recordData.tx["recipient_id"]);
      baseItems.add(recipientId);
    } else {
      var senderId = buildItem(S.current.ae_tx_detail_page_from, AeHomePage.address);
      baseItems.add(senderId);
    }
    var time = buildItem(S.current.cfx_tx_detail_page_time,    DateTime.fromMicrosecondsSinceEpoch(
        widget.recordData.time * 1000)
        .toLocal()
        .toString());

    baseItems.add(time);

    if(null!=widget.recordData.tx['payload']){
      var payload = widget.recordData.tx['payload'].toString();
      if (payload != "" && payload != null && payload != "null" && payload.length >= 11) {
        try {

          if (payload.contains("ba_")) {
            payload = payload.substring(3);
          }
          BoxApp.aeDecodePayload((data) {

            var item = buildItem(S.current.ae_tx_detail_page_payload, data);
            baseItems.add(item);
            baseItems.add(Container(height:  MediaQueryData.fromWindow(window).padding.bottom+30,width: 1,));

            baseItems.add(
              Container(
                color: Color(0xFFfafafa),
                height: 50.0,
              ),
            );
            setState(() {

            });
            return;
          }, payload);
        } catch (e) {
        }
      }else{
        baseItems.add(Container(height:  MediaQueryData.fromWindow(window).padding.bottom+30,width: 1,));

        baseItems.add(
          Container(
            color: Color(0xFFfafafa),
            height: 50.0,
          ),
        );
      }


    }

    netTopHeightData();
  }

  void netTopHeightData() {
    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        AeHomePage.height = model.data.height;
        setState(() {});
      } else {}
    }).catchError((e) {});
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
        IconButton(
        splashRadius:40,
        icon: Icon(
          Icons.more_horiz,
          color: Color(0xFF000000),
          size: 22,
        ),
        onPressed: () async {
          _launchURL("https://www.aeknow.org/block/transaction/" + widget.recordData.hash.toString());
        },
      ),
        ],
        title: Text(
          S.current.ae_tx_detail_page_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // child: Column(children: items),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              alignment: Alignment.center,
              child: getFeeWidget(34),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Material(
                child: Column(
                  children: baseItems,
                ),
              ),
            ),

          ],
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

  Text getFeeWidget(double size) {
    if (widget.recordData.tx['type'].toString() == "SpendTx") {
      // ignore: unrelated_type_equality_checks

      if (widget.recordData.tx['recipient_id'].toString() == AeHomePage.address) {
        return Text(
          "+" + double.parse(((widget.recordData.tx['amount'].toDouble()) / 1000000000000000000).toString()).toStringAsFixed(6) + " AE",
          style: TextStyle(color: Colors.red, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      } else {
        return Text(
          "-" + double.parse((((widget.recordData.tx['amount'].toDouble() + widget.recordData.tx['fee'].toDouble()) / 1000000000000000000)).toString()).toStringAsFixed(8) + " AE",
          style: TextStyle(color: Colors.green, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      }
    } else {
      if (widget.recordData.tx['type'].toString() == "NameClaimTx") {
        return Text(
          "-" + double.parse(((widget.recordData.tx['fee'].toDouble() + widget.recordData.tx['name_fee'].toDouble()) / 1000000000000000000).toString()).toStringAsFixed(8) + " AE",
          style: TextStyle(color: Colors.green, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      }

      return Text(
        "-" + double.parse((widget.recordData.tx['fee'].toDouble() / 1000000000000000000).toString()).toStringAsFixed(6) + " AE",

        style: TextStyle(color: Colors.green, fontSize: size, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }
  }

  Widget buildItem(String key, String value) {
    return Padding(

      padding: const EdgeInsets.only(top:12.0),
      child: Material(
        color: Color(0xFFffffff),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));

            Fluttertoast.showToast(msg: S
                .of(context)
                .token_receive_page_copy_sucess,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
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
      padding: const EdgeInsets.only(top:12.0),
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
