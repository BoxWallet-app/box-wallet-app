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

class AensDetailPage extends StatefulWidget {
  final String name;

  const AensDetailPage({Key key, this.name}) : super(key: key);

  @override
  _AensDetailPageState createState() => _AensDetailPageState();
}

class _AensDetailPageState extends State<AensDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    netAensInfo();
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
        title: Text(
          _aensInfoModel.data == null ? "" : _aensInfoModel.data.name,
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
            buildItem("域名", _aensInfoModel.data == null ? "" : _aensInfoModel.data.name),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("TxHash", _aensInfoModel.data == null ? "" : _aensInfoModel.data.thHash),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem("价格(ae)", _aensInfoModel.data == null ? "" : Utils.formatPrice(_aensInfoModel.data.currentPrice)),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


            buildItem("当前高度", _aensInfoModel.data == null ? "" : _aensInfoModel.data.currentHeight.toString()),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildItem(getTypeKey(), getTypeValue()),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),


            buildItem("所有者", _aensInfoModel.data == null ? "" : _aensInfoModel.data.owner),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),

            buildBtnAdd(context),

            buildBtnUpdate(context)
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

  Container buildBtnUpdate(BuildContext context) {
    if (_aensInfoModel.data == null) {
      return Container();
    }

    if (_aensInfoModel.data.owner != BoxApp.getAddress()) {
      return Container();
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ArgonButton(
        height: 50,
        roundLoadingShape: true,
        width: MediaQuery.of(context).size.width * 0.8,
        onTap: (startLoading, stopLoading, btnState) {
          netUpdate(context, startLoading, stopLoading);
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
    );
  }

  Future<void> netUpdate(BuildContext context, Function startLoading, Function stopLoading) async {
    //隐藏键盘
    startLoading();
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(seconds: 1), () {
      AensUpdaterDao.fetch(_aensInfoModel.data.name).then((AensUpdateModel model) {
        stopLoading();
        if (model.code == 200) {
          showFlush(context);
        } else {
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text("更新失败"),
              content: Text(model.msg),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    "确定",
                    style: TextStyle(color: Color(0xFFFC2365)),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        }
      }).catchError((e) {
        stopLoading();
        Fluttertoast.showToast(msg: "网络错误", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      });
    });
  }

  Future<void> netRegister(BuildContext context, Function startLoading, Function stopLoading) async {
    //隐藏键盘
    startLoading();
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(seconds: 1), () {
      AensRegisterDao.fetch(_aensInfoModel.data.name).then((AensRegisterModel model) {
        stopLoading();
        if (model.code == 200) {
          showFlush(context);
        } else {
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text("加价失败"),
              content: Text(model.msg),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    "确定",
                    style: TextStyle(color: Color(0xFFFC2365)),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        }
      }).catchError((e) {
        stopLoading();
        Fluttertoast.showToast(msg: "网络错误", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      });
    });
  }

  void showFlush(BuildContext context) {
    flush = Flushbar<bool>(
      title: "广播成功",
      message: "正在同步节点信息,预计5分钟后同步成功!",
      backgroundGradient: LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
      backgroundColor: Color(0xFFFC2365),
      blockBackgroundInteraction: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      //                        flushbarStyle: FlushbarStyle.GROUNDED,

      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true); // result = true
        },
        child: Text(
          "确定",
          style: TextStyle(color: Colors.white),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Color(0x88000000),
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
      });
  }

  Container buildBtnAdd(BuildContext context) {
    if (_aensInfoModel.data == null) {
      return Container();
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: ArgonButton(
        height: 50,
        roundLoadingShape: true,
        width: MediaQuery.of(context).size.width * 0.8,
        onTap: (startLoading, stopLoading, btnState) {
          netRegister(context, startLoading, stopLoading);
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
        color: Color(0xFFFC2365),
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
