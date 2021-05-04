import 'dart:io';
import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/dao/name_reverse_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/name_reverse_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/setting_page_v2.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/page/tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'home_page.dart';

class MyOraclePage extends StatefulWidget {
  @override
  _MyOraclePageState createState() => _MyOraclePageState();
}

class _MyOraclePageState extends State<MyOraclePage> with AutomaticKeepAliveClientMixin  {
  DateTime lastPopTime;
  PriceModel priceModel;
  List<NameReverseModel> namesModel;
  WalletTransferRecordModel walletRecordModel;
  var page = 1;
  BlockTopModel blockTopModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    netNameReverseData();
    netBaseData();
    netAccountInfo();
    getAddress();
    netTopHeightData();
    netWalletRecord();
  }

  Future<void> _onRefresh() async {
    page = 1;
    netNameReverseData();
    netBaseData();
    netAccountInfo();
    getAddress();
    netTopHeightData();
    netWalletRecord();
  }
  void netTopHeightData() {
    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        blockTopModel = model;
//        setState(() {});
        HomePage.height = blockTopModel.data.height;
        netWalletRecord();
      } else {}
    }).catchError((e) {
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netWalletRecord() {
    WalletRecordDao.fetch(page).then((WalletTransferRecordModel model) {
      if (model.code == 200) {
        if (page == 1) {
          page++;
          walletRecordModel = model;
          if (model.data == null || model.data.length == 0) {
//            _easyRefreshController.finishRefresh();
//            _easyRefreshController.finishLoad();
            setState(() {});
            return;
          }
          walletRecordModel = model;
        } else {
          walletRecordModel.data.addAll(model.data);
        }

        setState(() {});
      } else {}
    }).catchError((e) {
      setState(() {});
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      HomePageV2.address = address;
      setState(() {});
    });
  }

  void netBaseData() {
    var type = "usd";
//    if (BoxApp.language == "cn") {
//      type = "cny";
//    } else {
//      type = "usd";
//    }
    PriceDao.fetch(type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Container getRecordContainer(BuildContext context) {
//    if (walletRecordModel == null) {
//      return Container(
//        width: MediaQuery.of(context).size.width,
//        height: 50,
//      );
//    }
    return Container(
      alignment: Alignment.centerLeft,

      margin: EdgeInsets.only(top: 12, bottom: MediaQuery.of(context).padding.bottom),
      //边框设置
      decoration: new BoxDecoration(
        color: Color(0x00000000),
        //设置四周圆角 角度
//        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0x00000000),
        child: InkWell(
//          borderRadius: BorderRadius.all(Radius.circular(15)),
          splashColor: Color(0x00000000),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
          },
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
//                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: Image(
                              width: 56,
                              height: 56,
                              image: AssetImage("images/home_record.png"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              S.of(context).home_page_transaction,
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 23,
                      child: Container(
                        width: 25,
                        height: 25,
                        margin: const EdgeInsets.only(top: 23),
                        padding: const EdgeInsets.only(left: 0),
                        //边框设置
                        decoration: new BoxDecoration(
//                          color: Color(0xFFF5F5F5),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (walletRecordModel != null)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 16, top: 0),
                  child: Text(
                    S.of(context).home_page_transaction_conform,
                    style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF).withAlpha(200), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                  ),
                  height: 23,
                ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    if (walletRecordModel == null)
                      Container(
                        height: 150,
                        child: new Center(
                          child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
                          ),
                        ),
                      ),
                    if (walletRecordModel != null && walletRecordModel.data.length == 0)
                      Container(
                          child: Center(
                              child: Container(
                        width: MediaQuery.of(context).size.width,
//                                color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                S.of(context).home_no_record,
                                style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFFFFFFF).withAlpha(200)),
                              ),
                            ),
                          ],
                        ),
                      ))),
                    getItem(context, 0),
                    getItem(context, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getItem(BuildContext context, int index) {
    if (walletRecordModel == null || walletRecordModel.data.length <= index || blockTopModel == null) {
      return Container();
    }
    return Material(
      color: Color(0x00000000),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 20, top: 10, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //边框设置

                child: Text(
                  (blockTopModel.data.height - walletRecordModel.data[index].blockHeight).toString(),
                  style: TextStyle(color: Color(0xFFFC2365), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                ),
                alignment: Alignment.center,
                height: 23,
                width: 40,
              ),
              Container(
                margin: EdgeInsets.only(left: 18),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 65 - 40,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                getTxType(index),
                                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                        style: TextStyle(color: Colors.white.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                      ),
                      width: MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                        DateTime.fromMicrosecondsSinceEpoch(walletRecordModel.data[index].time * 1000).toLocal().toString(),
                        style: TextStyle(color: Colors.white.withAlpha(56), fontSize: 13, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
    );
  }

  getTxType(int index) {
    if (BoxApp.language == "cn") {
      switch (walletRecordModel.data[index].tx['type']) {
        case "SpendTx":
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

      if (walletRecordModel.data[index].tx['recipient_id'].toString() == HomePageV2.address) {
        return Text(
          "+" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      } else {
        return Text(
          "-" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      }
    } else {
      return Text(
        "-" + (walletRecordModel.data[index].tx['fee'].toDouble() / 1000000000000000000).toString() + " AE",
        style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }
  }

  void netNameReverseData() {
    NameReverseDao.fetch().then((List<NameReverseModel> model) {
      if (model.isNotEmpty) {
        if (model.isNotEmpty) {
          model.sort((left, right) => right.expiresAt.compareTo(left.expiresAt));
        }
        namesModel = model;
        setState(() {});
      } else {}
    }).catchError((e) {
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice() {
    if (HomePageV2.token == "loading...") {
      return "";
    }
    if (priceModel.aeternity.usd == null) {
      return "";
    }
    return " \$" + (priceModel.aeternity.usd * double.parse(HomePageV2.token)).toStringAsFixed(2) + " ≈ ";
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        // HomePage.token = "8888.88888";
        HomePageV2.token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "再按一次退出", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            exit(0);
          }
        },

        child: Scaffold(
          backgroundColor: Color(0xff303749),
          resizeToAvoidBottomInset: false,
          body: EasyRefresh(
            header: AEHeader(),
            onRefresh: _onRefresh,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                              Color(0xff20242F),
                              Color(0xff20242F),
                            ]),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            height: 35,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                              color: Color(0xff20242F),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            height: 40,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 12, left: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(child: Container()),
                                        priceModel == null
                                            ? Container()
                                            : Container(
                                                margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
                                                child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                  getAePrice(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                                ),
                                              ),
                                        Container(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: HomePageV2.address));
                            Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 160,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 20, right: 50),
                            child: Text(Utils.formatHomeCardAddress(HomePageV2.address), style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xff798297), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 87,
                            height: 58,
                            child: Image(
                              image: AssetImage("images/card_top.png"),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 120,
                            height: 46,
                            child: Image(
                              image: AssetImage("images/card_bottom.png"),
                            ),
                          ),
                        ),
                        Container(
                          height: 130,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 20, left: 18),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      S.of(context).home_page_my_count + " (AE）",
                                      style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      margin: const EdgeInsets.only(left: 2, right: 20),
                                      child: Text(
                                        namesModel == null ? "" : namesModel[0].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13, color: Colors.white70, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20, left: 15),
                                child: Row(
                                  children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
//                                          Container(
//                                            width: 36.0,
//                                            height: 36.0,
//                                            decoration: BoxDecoration(
//                                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                                              borderRadius: BorderRadius.circular(36.0),
//                                              image: DecorationImage(
//                                                image: AssetImage("images/apple-touch-icon.png"),
////                                                        image: AssetImage("images/apple-touch-icon.png"),
//                                              ),
//                                            ),
//                                          ),
//                                          Container(
//                                            padding: const EdgeInsets.only(left: 8, right: 18),
//                                            child: Text(
//                                              "AE",
//                                              style: new TextStyle(
//                                                fontSize: 20,
//                                                color: Colors.white,
////                                            fontWeight: FontWeight.w600,
//                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                              ),
//                                            ),
//                                          ),
                                    Expanded(child: Container()),

                                    Row(
                                      children: [
//                                              priceModel == null
//                                                  ? Container()
//                                                  : Container(
//                                                margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
//                                                child: Text(
////                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
//                                                  getAePrice(),
//                                                  overflow: TextOverflow.ellipsis,
//                                                  style: TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                                                ),
//                                              ),

                                        Text(
                                          HomePageV2.token == "loading..."
                                              ? "loading..."
                                              : double.parse(HomePageV2.token) > 1000
                                                  ? double.parse(HomePageV2.token).toStringAsFixed(2) + ""
                                                  : double.parse(HomePageV2.token).toStringAsFixed(5) + "",
//                                      "9999999.00000",
                                          overflow: TextOverflow.ellipsis,

                                          style: TextStyle(fontSize: 38, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),

//                                    Container(
//                                      alignment: Alignment.topLeft,
//                                      margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
//                                      child: Text(
//                                        HomePageV2.address,
//                                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                                        style: TextStyle(fontSize: 13, letterSpacing: 1.0, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.3),
//                                      ),
//                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).home_send_receive,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu",
                            ),
                          ),
                        ),
                        Container(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,

                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    //边框设置
                    decoration: new BoxDecoration(
                      color: Color(0x00000000),
                      //设置四周圆角 角度
//        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0x00000000),
                      child: InkWell(
//          borderRadius: BorderRadius.all(Radius.circular(15)),
                        splashColor: Color(0x00000000),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                        },
                        child: Column(
                          children: [
                            Container(
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
//                      padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(top: 10, left: 10),
                                          child: Image(
                                            width: 56,
                                            height: 56,
                                            image: AssetImage("images/home_send_token.png"),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(
                                            S.of(context).home_page_function_send,
                                            style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 23,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      margin: const EdgeInsets.only(top: 23),
                                      padding: const EdgeInsets.only(left: 0),
                                      //边框设置
                                      decoration: new BoxDecoration(
//                          color: Color(0xFFF5F5F5),
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,

                    margin: EdgeInsets.only(top: 12, bottom: 0),
                    //边框设置
                    decoration: new BoxDecoration(
                      color: Color(0x00000000),
                      //设置四周圆角 角度
//        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0x00000000),
                      child: InkWell(
//          borderRadius: BorderRadius.all(Radius.circular(15)),
                        splashColor: Color(0x00000000),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                        },
                        child: Column(
                          children: [
                            Container(
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
//                      padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(top: 10, left: 10),
                                          child: Image(
                                            width: 56,
                                            height: 56,
                                            image: AssetImage("images/home_receive_token.png"),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(
                                            S.of(context).home_page_function_receive,
                                            style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 23,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      margin: const EdgeInsets.only(top: 23),
                                      padding: const EdgeInsets.only(left: 0),
                                      //边框设置
                                      decoration: new BoxDecoration(
//                          color: Color(0xFFF5F5F5),
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  getRecordContainer(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
