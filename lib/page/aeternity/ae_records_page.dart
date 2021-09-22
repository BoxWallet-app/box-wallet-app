import 'dart:async';

import 'package:animations/animations.dart';
import 'package:box/dao/aeternity/wallet_record_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/page/aeternity/ae_tx_detail_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';
import 'ae_home_page.dart';

class AeRecordsPage extends StatefulWidget {
  const AeRecordsPage({Key key}) : super(key: key);

  @override
  _AeRecordsPageState createState() => _AeRecordsPageState();
}

class _AeRecordsPageState extends State<AeRecordsPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  WalletTransferRecordModel walletRecordModel;
  int page = 1;
  var address = '';

  @override
  Future<void> initState() {
    super.initState();

    getAddress();
  }

  Future<void> netData() async {
    WalletTransferRecordModel model = await WalletRecordDao.fetch(page);
    if (!mounted) {
      return;
    }
    _loadingType = LoadingType.finish;
    if (page == 1) {
      walletRecordModel = model;
    } else {
      walletRecordModel.data.addAll(model.data);
    }
    setState(() {});
    if (walletRecordModel.data.length == 0) {
      _loadingType = LoadingType.no_data;
    }
    page++;

    if (model.data.length < 20) {
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
      netData();
      setState(() {
        this.address = address;
      });
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
            itemCount: walletRecordModel == null ? 0 : walletRecordModel.data.length,
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
        child: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,

          transitionDuration:  Duration(milliseconds: 500),
          closedElevation: 0,
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          closedBuilder: (BuildContext context, void Function() action) {
            ///条目显示的一张图片
            return InkWell(
              onTap: action,
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
                                      getTxType(index),
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
                              walletRecordModel.data[index].hash,
                              strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                              style: TextStyle(color: Colors.black.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                            width: MediaQuery.of(context).size.width - 40 - 36,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text(
                              DateTime.fromMicrosecondsSinceEpoch(walletRecordModel.data[index].time * 1000).toLocal().toString(),
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
            );
          },

            ///openBuilder配置的Widget的背景色
            openColor: Colors.white,
            openElevation: 1.0,
            openShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ///点击打开的页面
          openBuilder: (BuildContext context, void Function({Object returnValue}) action) {
            return AeTxDetailPage(recordData: walletRecordModel.data[index]);
          },
        ),
      ),
    );
  }

  getTxType(int index) {
    if (BoxApp.language == "cn") {
      switch (walletRecordModel.data[index].tx['type']) {
        case "SpendTx":
          if ("ak_dMyzpooJ4oGnBVX35SCvHspJrq55HAAupCwPQTDZmRDT5SSSW" == walletRecordModel.data[index].tx['recipient_id']) {
            return "WeTrue调用";
          }
          return "转账";
        case "OracleRegisterTx":
          return "预言机注册";
        case "OracleExtendTx":
          return "预言机扩展";
        case "OracleQueryTx":
          return "预言机查询";
        case "OracleResponseTx":
          return "预言机响应";
        case "NamePreclaimTx":
          return "域名声明";
        case "NameClaimTx":
          return "域名注册";
        case "NameUpdateTx":
          return "域名更新";
        case "NameTransferTx":
          return "域名转移";
        case "NameRevokeTx":
          return "域名销毁";
        case "GAAttachTx":
          return "GA账户附加";
        case "GAMetaTx":
          return "GA账户变换";
        case "ContractCallTx":
          return "合约调用";
        case "ContractCreateTx":
          return "合约创建";
        case "ChannelCreateTx":
          return "状态通道创建";
        case "ChannelDepositTx":
          return "状态通道存款";
        case "ChannelDepositTx":
          return "状态通道撤销";
        case "ChannelCloseMutualTx":
          return "状态通道关闭";
        case "ChannelSnapshotSoloTx":
          return "状态通道Settle";
      }
      return walletRecordModel.data[index].tx['type'];
    }
    return walletRecordModel.data[index].tx['type'];
  }

  Text getFeeWidget(int index) {
    if (walletRecordModel.data[index].tx['type'].toString() == "SpendTx") {
      // ignore: unrelated_type_equality_checks

      if (walletRecordModel.data[index].tx['recipient_id'].toString() == AeHomePage.address) {
        return Text(
          "+" + double.parse(((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString()).toStringAsFixed(8) + " AE",
          style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      } else {
        return Text(
          "-" + double.parse((((walletRecordModel.data[index].tx['amount'].toDouble() + walletRecordModel.data[index].tx['fee'].toDouble()) / 1000000000000000000)).toString()).toStringAsFixed(8) + " AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      }
    } else {
      if (walletRecordModel.data[index].tx['type'].toString() == "NameClaimTx") {
        return Text(
          "-" + double.parse(((walletRecordModel.data[index].tx['fee'].toDouble() + walletRecordModel.data[index].tx['name_fee'].toDouble()) / 1000000000000000000).toString()).toStringAsFixed(8) + " AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      }

      return Text(
        "-" + double.parse((walletRecordModel.data[index].tx['fee'].toDouble() / 1000000000000000000).toString()).toStringAsFixed(8) + " AE",
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
