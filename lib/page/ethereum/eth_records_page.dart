import 'dart:async';
import 'dart:io';

import 'package:box/dao/conflux/cfx_transfer_dao.dart';
import 'package:box/dao/ethereum/eth_transfer_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';
import 'eth_tx_detail_page.dart';

class EthRecordsPage extends StatefulWidget {
  const EthRecordsPage({Key key}) : super(key: key);

  @override
  _EthRecordsPageState createState() => _EthRecordsPageState();
}

class _EthRecordsPageState extends State<EthRecordsPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  EthTransferModel cfxTransfer;
  int page = 1;
  var address = '';
  Account account;

  @override
  Future<void> initState() {
    super.initState();

    getAddress();
  }

  Future<void> netData() async {
    Account account = await WalletCoinsManager.instance.getCurrentAccount();
    EthTransferModel model = await EthTransferDao.fetch(EthManager.instance.getChainID(account), "", page.toString());
    if (!mounted) {
      return;
    }
    _loadingType = LoadingType.finish;
    if (page == 1) {
      cfxTransfer = model;
    } else {
      if (model.data != null) cfxTransfer.data.addAll(model.data);
    }

    if (cfxTransfer.data == null) {
      _loadingType = LoadingType.no_data;
      setState(() {});
      return;
    }

    setState(() {});
    page++;

    if (model.data == null || model.data.length < 20) {
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
    WalletCoinsManager.instance.getCurrentAccount().then((Account acc) {
      if (!mounted) {
        return;
      }
      this.account = acc;
      this.address = acc.address;
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
          header: BoxHeader(),
          onRefresh: _onRefresh,
          onLoad: netData,
          // header: MaterialHeader(
          // valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
//          controller: _controller,
          child: ListView.builder(
            itemBuilder: buildColumn,
            itemCount: cfxTransfer == null ? 0 : cfxTransfer.data.length,
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
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if (Platform.isIOS) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EthTxDetailPage(recordData: cfxTransfer.data[index])));
            } else {
              Navigator.push(context, SlideRoute(EthTxDetailPage(recordData: cfxTransfer.data[index])));
            }
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
                          cfxTransfer.data[index].hash,
                          strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          style: TextStyle(color: Colors.black.withAlpha(56),  fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        ),
                        width: MediaQuery.of(context).size.width - 40 - 36,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text(
                          DateTime.fromMicrosecondsSinceEpoch(cfxTransfer.data[index].timestamp * 1000000).toLocal().toString().substring(0, DateTime.fromMicrosecondsSinceEpoch(cfxTransfer.data[index].timestamp * 1000000).toLocal().toString().length - 4),
                          style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 13,  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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

    if(cfxTransfer.data[index].status == 0){
      return S.current.record_status_error_full;
    }
    if (cfxTransfer.data[index].from.toString().toLowerCase().contains(address.toLowerCase())) {
      return S.current.cfx_home_page_transfer_send;
    } else {
      return S.current.cfx_home_page_transfer_receive;
    }
  }

  Text getFeeWidget(int index) {
    if(cfxTransfer.data[index].status == 0){
      return  Text(
        cfxTransfer.data[index].errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }

    if (cfxTransfer.data[index].to.toString().toLowerCase().contains(address.toLowerCase())) {
      return Text(
        "+ " + (Utils.cfxFormatAsFixed(cfxTransfer.data[index].value, 6)) + " " + this.account.coin,
        style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    } else {
      return Text(
        "- " + (Utils.cfxFormatAsFixed(cfxTransfer.data[index].value, 6)) + " " + this.account.coin,
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
