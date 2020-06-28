import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_info_dao.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AensDetailPage extends StatefulWidget {
  final String name;

  const AensDetailPage({Key key, this.name}) : super(key: key);
  @override
  _AensDetailPageState createState() => _AensDetailPageState();
}

class _AensDetailPageState extends State<AensDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AensInfoDao.fetch(widget.name).then((AensInfoModel model) {
      print(model.data.name);
      _aensInfoModel = model;
      _loadingType = LoadingType.finish;
      setState(() {});
    }).catchError((e) {
      _loadingType = LoadingType.error;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text(
          'AENS详情',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: LoadingWidget(
        type: _loadingType,
        child: Column(
          children: <Widget>[
            buildItem("域名", _aensInfoModel.data == null ? "" : _aensInfoModel.data.name),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("TxHash", _aensInfoModel.data == null ? "" : _aensInfoModel.data.thHash),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("价格(ae)", _aensInfoModel.data == null ? "" : Utils.formatPrice(_aensInfoModel.data.currentPrice)),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


            buildItem("距离过期", _aensInfoModel.data == null ? "" : _aensInfoModel.data.currentHeight.toString()),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("当前高度", _aensInfoModel.data == null ? "" : _aensInfoModel.data.currentHeight.toString()),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
//
//            buildItem("创建高度", _aensInfoModel.data == null ? "" : _aensInfoModel.data.startHeight.toString()),
//            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
//
//            buildItem("结束高度", _aensInfoModel.data == null ? "" : _aensInfoModel.data.endHeight.toString()),
//            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
//
//            buildItem("到期高度", _aensInfoModel.data == null ? "" : _aensInfoModel.data.overHeight.toString()),
//            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("所有者", _aensInfoModel.data == null ? "" : _aensInfoModel.data.owner),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            Container(
              margin: const EdgeInsets.only(top: 30),
              child: ArgonButton(
                height: 50,
                roundLoadingShape: true,
                width: MediaQuery.of(context).size.width * 0.8,
                onTap: (startLoading, stopLoading, btnState) {
//                  netRegister(context, startLoading, stopLoading);
                },
                child: Text(
                  "加 价",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitRing(
                    lineWidth: 4,
                    color: Colors.white,
                    // size: loaderWidth ,
                  ),
                ),
                borderRadius: 30.0,
                color: Color(0xFFE71766),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ArgonButton(
                height: 50,
                roundLoadingShape: true,
                width: MediaQuery.of(context).size.width * 0.8,
                onTap: (startLoading, stopLoading, btnState) {
//                  netRegister(context, startLoading, stopLoading);
                },
                child: Text(
                  "更 新",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitRing(
                    lineWidth: 4,
                    color: Colors.white,
                    // size: loaderWidth ,
                  ),
                ),
                borderRadius: 30.0,
                color: Color(0xff6F53A1),
              ),
            )
          ],
        ),
      ),
    );
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
