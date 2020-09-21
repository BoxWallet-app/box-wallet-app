import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_info_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/aens_update_dao.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/aens_update_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TxDetailPage extends StatefulWidget {
  final RecordData recordData;

  const TxDetailPage({Key key, this.recordData}) : super(key: key);

  @override
  _TxDetailPageState createState() => _TxDetailPageState();
}

class _TxDetailPageState extends State<TxDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;
  List<Widget> items = []; //先建一个数组用于存放循环生成的widget

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingType = LoadingType.finish;
//    netAensInfo();
    var item = buildItem("tx", widget.recordData.hash);
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

    widget.recordData.tx.forEach(
      (key, value) {
        var payload = widget.recordData.tx['payload'].toString();
        if (payload != "" && payload != null && payload.length >= 11) {
          try{
            print("substring->" + payload);
            var substring = payload.substring(3);
            print("substring->" + substring);
            var base64decode = Utils.base64Decode(substring);
//
//        print("substring->"+substring);
//        var base64decode = Utils.base64Decode(substring);
            print("base64decode->" + base64decode);
            substring = base64decode.substring(0, base64decode.length - 4);
            widget.recordData.tx['payload'] = substring;
          }catch(e){
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

        height: 50.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
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
            fontFamily: "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: items),
      ),
    );
  }

  String getTypeValue() {
    if (_aensInfoModel.data == null) {
      return "-";
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return Utils.formatHeight(context, _aensInfoModel.data.currentHeight, _aensInfoModel.data.overHeight);
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return Utils.formatHeight(context, _aensInfoModel.data.currentHeight, _aensInfoModel.data.endHeight);
    }

    return "-";
  }

  String getTypeKey() {
    if (_aensInfoModel.data == null) {
      return "距离过期";
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return "距离过期";
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return "距离结束";
    }

    return "距离过期";
  }

  Container buildItem(String key, String value) {
    return Container(
      color: Colors.white,
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
                  key,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Ubuntu",
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
                  fontFamily: "Ubuntu",
                ),
              ),
              margin: const EdgeInsets.only(left: 30.0),
            ),
          ),
        ],
      ),
    );
  }
}
