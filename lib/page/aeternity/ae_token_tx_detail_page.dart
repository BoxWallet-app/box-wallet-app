import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';



class AeTokenTxDetailPage extends StatefulWidget {
  final RecordData recordData;

  const AeTokenTxDetailPage({Key key, this.recordData}) : super(key: key);

  @override
  _AeTokenTxDetailPageState createState() => _AeTokenTxDetailPageState();
}

class _AeTokenTxDetailPageState extends State<AeTokenTxDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;
  List<Widget> items = []; //先建一个数组用于存放循环生成的widget

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingType = LoadingType.finish;
    items.add(
      Container(
        height: 20.0,
      ),
    );

    items.add(new Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 18, bottom: 20),
      child: Text(
        "Basic data",
        style: TextStyle(
          fontSize: 20,
          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
        ),
      ),
    ));
//    netAensInfo();
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 0, right: 0),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );
    var item = buildItem("Tx", widget.recordData.hash);

    items.add(item);
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 18, right: 18),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );
    var itemType = buildItem("Type", widget.recordData.tx["type"]);

    items.add(itemType);
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 18, right: 18),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );

    var itemFee = buildItem2("Fee + Amount", getFeeWidget());

    items.add(itemFee);
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 18, right: 18),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );

    var item2 = buildItem("Conform Height", (AeHomePage.height - widget.recordData.blockHeight).toString());
    items.add(item2);
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 0, right: 0),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );
    items.add(
      Container(
          child: Container(
            color: Color(0xFFfafafa),
          ),
          padding: EdgeInsets.only(left: 0, right: 0),
          height: 30.0,
          color: Color(0xFFfafafa)),
    );

    items.add(new Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 18, bottom: 20),
      child: Text(
        "All the data",
        style: TextStyle(
          fontSize: 20,
          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
        ),
      ),
    ));
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 0, right: 0),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );
    widget.recordData.tx.forEach(
      (key, value) {
        var payload = widget.recordData.tx['payload'].toString();
        if (payload != "" && payload != null && payload != "null" && payload.length >= 11) {
          try {
            widget.recordData.tx['payload'] = Utils.formatPayload(payload);
          } catch (e) {
            widget.recordData.tx['payload'] = payload;
          }
        }

        var item = buildItem(key.toString(), value.toString());
        items.add(item);
        items.add(
          Container(
              child: Container(
                color: Color(0xFFEEEEEE),
              ),
              padding: EdgeInsets.only(left: 18, right: 18),
              height: 1.0,
              color: Color(0xFFFFFFFF)),
        );
      },
    );
    items.add(
      Container(
          child: Container(
            color: Color(0xFFEEEEEE),
          ),
          padding: EdgeInsets.only(left: 0, right: 0),
          height: 1.0,
          color: Color(0xFFFFFFFF)),
    );
    items.add(
      Container(
        color: Color(0xFFfafafa),
        height: 50.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          MaterialButton(
            minWidth: 10,
            child: new Text(''),
            onPressed: () {},
          ),
        ],
        title: Text(
          widget.recordData.hash.toString(),
          style: TextStyle(
            fontSize: 18,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: items),
      ),
    );
  }

  Text getFeeWidget() {
    if (widget.recordData.tx['type'].toString() == "SpendTx") {
      // ignore: unrelated_type_equality_checks

      if (widget.recordData.tx['recipient_id'].toString() == AeHomePage.address) {
        return Text(
          "+" + ((widget.recordData.tx['amount'].toDouble() + widget.recordData.tx['fee'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
        );
      } else {
        return Text(
          "-" + (((widget.recordData.tx['amount'].toDouble() + widget.recordData.tx['fee'].toDouble()) / 1000000000000000000)).toString() + " AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
        );
      }
    } else {
      return Text(
        "-" + (widget.recordData.tx['fee'].toDouble() / 1000000000000000000).toString() + " AE",
        style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
      );
    }
  }

  Widget buildItem(String key, String value) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));

          Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
        },
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
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                    ),
                  ),
                  margin: const EdgeInsets.only(left: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem2(String key, Widget text) {
    return Material(
      color: Colors.white,
      child: InkWell(
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
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
    );
  }
}
