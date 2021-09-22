import 'dart:async';

import 'package:box/dao/conflux/cfx_transfer_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';
import 'cfx_tx_detail_page.dart';

class CfxRecordsPage extends StatefulWidget {
  const CfxRecordsPage({Key key}) : super(key: key);

  @override
  _CfxRecordsPageState createState() => _CfxRecordsPageState();
}

class _CfxRecordsPageState extends State<CfxRecordsPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  CfxTransfer cfxTransfer;
  int page = 1;
  var address = '';

  @override
  Future<void> initState() {
    super.initState();

    getAddress();
  }

  void netCfxTransfer() {
    CfxTransferDao.fetch(page.toString(), "").then((CfxTransfer model) {
      cfxTransfer = model;
      setState(() {});
    }).catchError((e) {
      // print(e);
    });
  }

  Future<void> netData() async {
    CfxTransfer model = await CfxTransferDao.fetch(page.toString(), "");
    if (!mounted) {
      return;
    }
    _loadingType = LoadingType.finish;
    if (page == 1) {
      cfxTransfer = model;
    } else {
      cfxTransfer.list.addAll(model.list);
    }
    setState(() {});
    if (cfxTransfer.list.length == 0) {
      _loadingType = LoadingType.no_data;
    }
    page++;

    if (model.list.length < 20) {
      _controller.finishLoad(noMore: true);
    }

//    WalletRecordDao.fetch(page).then((WalletTransferRecordModel model) {
//
//
//      if (model.code == 200) {
//
//      }
//

//      _controller.finishRefresh();
//      _controller.finishLoad();
//    }).catchError((e) {
//      if (page == 1 &&
//          (walletRecordModel == null || walletRecordModel.data == null)) {
//        setState(() {
//          _loadingType = LoadingType.error;
//        });
//      } else {
//        Fluttertoast.showToast(
//            msg: "error",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.black,
//            textColor: Colors.white,
//            fontSize: 16.0);
//      }
//      print("error:" + e.toString());
//    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      this.address = address;
      netData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
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
        title: Text(
          S.of(context).home_page_transaction,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: LoadingWidget(
        child: EasyRefresh(
          onRefresh: _onRefresh,
          onLoad: netData,
          // header: MaterialHeader(
          // valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
//          controller: _controller,
          child: ListView.builder(
            itemBuilder: buildColumn,
            itemCount: cfxTransfer == null ? 0 : cfxTransfer.list.length,
          ),
        ),
        type: _loadingType,
        onPressedError: () {
          setState(() {
            _loadingType = LoadingType.loading;
          });
          _onRefresh();
        },
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if (index < list.length) {
    return buildColumn(context, index);
  }

  Widget buildColumn(BuildContext context, int position) {
    return getItem(context, position);
  }

  Widget getItem(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 18, right: 18),

      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Navigator.push(context, SlideRoute( CfxTxDetailPage(hash: cfxTransfer.list[index].hash)));
          },
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 40 - 36,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  getCfxMethod(index),
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: getFeeWidget(index),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          cfxTransfer.list[index].hash,
                          strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          style: TextStyle(color: Colors.black.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        ),
                        width: MediaQuery.of(context).size.width - 40 - 36,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text(
                          DateTime.fromMicrosecondsSinceEpoch(cfxTransfer.list[index].timestamp * 1000000).toLocal().toString().substring(0, DateTime.fromMicrosecondsSinceEpoch(cfxTransfer.list[index].timestamp * 1000000).toLocal().toString().length - 4),
                          style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 13, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getCfxMethod(int index) {
    // if(cfxTransfer.list[index].method == "0x"){
    //   return "Spend";
    // }
    // if (cfxTransfer.list[index].method.length > 10) {
    //   return cfxTransfer.list[index].method.substring(0, 10) + "...";
    // } else {
    //   return cfxTransfer.list[index].method;
    // }
    var split = address.split(":");
    if (cfxTransfer.list[index].from.toString().toLowerCase().contains(split[1])) {
      return S.current.cfx_home_page_transfer_send;
    } else {
      return S.current.cfx_home_page_transfer_receive;
    }
  }

  Text getFeeWidget(int index) {
    // return Text(
    //   "-" + "" + " CFX",
    //   style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    // );
    // if (walletRecordModel.data[index].tx['type'].toString() == "SpendTx") {
    //   // ignore: unrelated_type_equality_checks
    //
    var split = address.split(":");
    if (cfxTransfer.list[index].to.toString().toLowerCase().contains(split[1])) {
      return Text(
        "+ " + (Utils.cfxFormatAsFixed(cfxTransfer.list[index].value, 0)) + " CFX",
        style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    } else {
      return Text(
        "- " + (Utils.cfxFormatAsFixed(cfxTransfer.list[index].value, 0)) + " CFX",
        style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }
  }

  Future<void> _onRefresh() async {
    page = 1;
    await netData();
  }

  Future<void> _onLoad() async {
    await netData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
