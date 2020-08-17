import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_info_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/aens_update_dao.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/aens_update_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TxDetailPage extends StatefulWidget {
  final String name;

  const TxDetailPage({Key key, this.name}) : super(key: key);

  @override
  _TxDetailPageState createState() => _TxDetailPageState();
}

class _TxDetailPageState extends State<TxDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingType = LoadingType.finish;
//    netAensInfo();
  }

  void netAensInfo() {
    AensInfoDao.fetch(widget.name).then((AensInfoModel model) {
      _aensInfoModel = model;
      _loadingType = LoadingType.finish;
      setState(() {});
    }).catchError((e) {
      print(e.toString());
      _loadingType = LoadingType.error;
      setState(() {});
    });
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
            onPressed: () {
            },
          ),
        ],
        title: Text(
          "th_2hjndcgPXGUv8GbgtxiR9o7PfG7rZVNaxrgfcqgBMjnj2xvsyu",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: LoadingWidget(
        type: _loadingType,
        onPressedError: () {
          netAensInfo();
        },
        child: Column(
          children: <Widget>[
            buildItem("时间", "2020-08-05 17:51:02"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("类型", "Spend"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("确认数","2391"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


            buildItem("数量", "+5AE"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("发送者", "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


            buildItem("接收者","ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("TxHash","th_2hjndcgPXGUv8GbgtxiR9o7PfG7rZVNaxrgfcqgBMjnj2xvsyu"),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

          ],
        ),
      ),
    );
  }

  String getTypeValue(){
    if (_aensInfoModel.data == null) {
      return "-";
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return Utils.formatHeight(_aensInfoModel.data.currentHeight, _aensInfoModel.data.overHeight);
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return Utils.formatHeight(_aensInfoModel.data.currentHeight, _aensInfoModel.data.endHeight);
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
