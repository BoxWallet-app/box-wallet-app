import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/contract_info_dao.dart';
import 'package:box/dao/name_reverse_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/swap_dao.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/name_reverse_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/swap_model.dart';
import 'package:box/model/wallet_coins_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';
import 'token_list_page.dart';
import 'token_receive_page.dart';
import 'token_send_one_page.dart';
import 'tx_detail_page.dart';

class HomePageV2 extends StatefulWidget {
  static var token = "loading...";
  static var tokenABC = "loading...";
  static var height = 0;
  static var address = "";

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2>
    with AutomaticKeepAliveClientMixin {
  PriceModel priceModel;
  static var contentText = "";
  WalletTransferRecordModel walletRecordModel;
  var page = 1;
  BlockTopModel blockTopModel;
  SwapModel swapModels;
  double premium;
  List<NameReverseModel> namesModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventBus.on<LanguageEvent>().listen((event) {
      netBaseData();
      netAccountInfo();
      netContractBalance();
      getAddress();
      netTopHeightData();
      netSwapDao();
      netNameReverseData();
    });
    eventBus.on<AccountUpdateEvent>().listen((event) {
      priceModel = null;
      walletRecordModel = null;
      blockTopModel = null;
      namesModel = null;
      HomePageV2.token = "loading...";
      HomePageV2.tokenABC = "loading...";
      setState(() {

      });
      netBaseData();
      netAccountInfo();
      netContractBalance();
      getAddress();
      netTopHeightData();
      netSwapDao();
      netNameReverseData();
    });
    netBaseData();
    netAccountInfo();
    netContractBalance();
    getAddress();
    netTopHeightData();
    netSwapDao();
    netNameReverseData();
  }

  void netNameReverseData() {
    NameReverseDao.fetch().then((List<NameReverseModel> model) {
      if (model.isNotEmpty) {
        if (model.isNotEmpty) {
          model
              .sort((left, right) => right.expiresAt.compareTo(left.expiresAt));
        }
        namesModel = model;
        setState(() {});
      } else {}
    }).catchError((e) {
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netTopHeightData() {
    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        blockTopModel = model;
        HomePageV2.height = blockTopModel.data.height;
//        setState(() {});
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
          walletRecordModel = model;
          if (model.data == null || model.data.length == 0) {
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

  void netContractBalance() {
    ContractBalanceDao.fetch(BoxApp.ABC_CONTRACT_AEX9)
        .then((ContractBalanceModel model) {
      if (model.code == 200) {
        HomePageV2.tokenABC = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account account) {
      print(account.address);
      HomePageV2.address = account.address;
      setState(() {});
    });
  }

  void netBaseData() {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    PriceDao.fetch(type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice() {
    if (HomePageV2.token == "loading...") {
      return "";
    }
    if (BoxApp.language == "cn" && priceModel.aeternity != null) {
      if (priceModel.aeternity.cny == null) {
        return "";
      }
      if (double.parse(HomePageV2.token) < 1000) {
        return "¥" +
            (priceModel.aeternity.cny * double.parse(HomePageV2.token))
                .toStringAsFixed(4) +
            " ≈";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "¥" +
            (priceModel.aeternity.cny * double.parse(HomePageV2.token))
                .toStringAsFixed(4) +
            " ≈";
      }
    } else {
      if (priceModel.aeternity.usd == null) {
        return "";
      }
      return "\$" +
          (priceModel.aeternity.usd * double.parse(HomePageV2.token))
              .toStringAsFixed(4) +
          " ≈";
    }
  }

  void netSwapDao() {
    SwapDao.fetch(BoxApp.ABC_CONTRACT_AEX9.replaceAll("ct_", "ak_"))
        .then((SwapModel model) {
      if (model != null) {
        if (model.data.isNotEmpty) {
          model.data.sort(
              (left, right) => left.getPremium().compareTo(right.getPremium()));
        }
        premium = (double.parse(model.data[0].ae) /
            (double.parse(model.data[0].count)));
        setState(() {});
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: EasyRefresh(
      header: AEHeader(),
      onRefresh: _onRefresh,
      child: Container(
        child: Column(
          children: [
            // Container(
            //   height: 8,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
//                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        boxShadow: [
//                                BoxShadow(
//                                    color: Color(0xFFFC2365).withAlpha(20),
//                                    offset: Offset(0.0, 55.0), //阴影xy轴偏移量
//                                    blurRadius: 50.0, //阴影模糊程度
//                                    spreadRadius: 0.1 //阴影扩散程度
//                                    )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFFC2365).withAlpha(20),
                                    offset: Offset(0.0, 55.0),
                                    //阴影xy轴偏移量
                                    blurRadius: 50.0,
                                    //阴影模糊程度
                                    spreadRadius: 0.1 //阴影扩散程度
                                    )
                              ],
                            ),
                          ),
//                          Container(
//                            height: 90,
//                            margin: const EdgeInsets.only(left: 16, right: 16),
//                            decoration: new BoxDecoration(
//                              boxShadow: [
//                                BoxShadow(
//                                    color: Color(0xFF3C5DE3).withAlpha(20),
//                                    offset: Offset(0.0, 55.0), //阴影xy轴偏移量
//                                    blurRadius: 50.0, //阴影模糊程度
//                                    spreadRadius: 0.1 //阴影扩散程度
//                                    )
//                              ],
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      colors: [
                                        Color(0xFFE51363),
                                        Color(0xFFFF428F),
                                      ]),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  height: 35,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(15.0)),
                                    color: Color(0xffd12869),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 12, left: 15),
                                          child: Row(
                                            children: <Widget>[
                                              priceModel == null
                                                  ? Container()
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5,
                                                              left: 2,
                                                              top: 2),
                                                      child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                        getAePrice(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            letterSpacing: 1.0,
                                                            fontFamily:
                                                                BoxApp.language ==
                                                                        "cn"
                                                                    ? "Ubuntu"
                                                                    : "Ubuntu"),
                                                      ),
                                                    ),

//                            buildTypewriterAnimatedTextKit(),

//                                                Container(
//                                                  width: 36.0,
//                                                  height: 36.0,
//                                                  decoration: BoxDecoration(
//                                                    border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                                                    borderRadius: BorderRadius.circular(36.0),
//                                                    image: DecorationImage(
//                                                      image: AssetImage("images/logo.png"),
////                                                        image: AssetImage("images/apple-touch-icon.png"),
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  padding: const EdgeInsets.only(left: 8, right: 18),
//                                                  child: Text(
//                                                    "ABC",
//                                                    style: new TextStyle(
//                                                      fontSize: 20,
//                                                      color: Colors.white,
////                                            fontWeight: FontWeight.w600,
//                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                                    ),
//                                                  ),
//                                                ),
                                              Expanded(child: Container()),
                                              Text(
                                                HomePageV2.tokenABC ==
                                                        "loading..."
                                                    ? "loading..."
                                                    : double.parse(HomePageV2
                                                                .tokenABC) >
                                                            1000
                                                        ? double.parse(HomePageV2
                                                                    .tokenABC)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            " ABC"
                                                        : double.parse(HomePageV2
                                                                    .tokenABC)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            " ABC",
//                                      "9999999.00000",
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    letterSpacing: 1.0,
                                                    fontFamily:
                                                        BoxApp.language == "cn"
                                                            ? "Ubuntu"
                                                            : "Ubuntu"),
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
                                  Clipboard.setData(
                                      ClipboardData(text: HomePageV2.address));
                                  Fluttertoast.showToast(
                                      msg: S
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
                                  width: MediaQuery.of(context).size.width,
                                  height: 160,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 20, right: 50),
                                  child: Text(
                                      Utils.formatHomeCardAddress(
                                          HomePageV2.address),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffbd2a67),
                                          letterSpacing: 1.3,
                                          fontFamily: BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu")),
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
//                              Positioned(
//                                left: 60,
//                                bottom: 20,
//                                child: Container(
//                                  width: 15,
//                                  height: 15,
//                                  child: Image(
//                                    color: Colors.white.withAlpha(60),
//                                    image: AssetImage("images/index_bg4.png"),
//                                  ),
//                                ),
//                              ),
//                              Positioned(
//                                right: (MediaQuery.of(context).size.width - 32) / 3,
//                                top: 23,
//                                child: Container(
//                                  width: 25,
//                                  height: 25,
//                                  child: Image(
//                                    color: Colors.white.withAlpha(60),
//                                    image: AssetImage("images/index_bg2.png"),
//                                  ),
//                                ),
//                              ),
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
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 18),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            S.of(context).home_page_my_count +
                                                " (AE）",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white70,
                                                fontFamily:
                                                    BoxApp.language == "cn"
                                                        ? "Ubuntu"
                                                        : "Ubuntu"),
                                          ),
                                          Expanded(child: Container()),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 2, right: 20),
                                            child: Text(
                                              namesModel == null
                                                  ? ""
                                                  : namesModel[0].name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white70,
                                                  letterSpacing: 1.0,
                                                  fontFamily:
                                                      BoxApp.language == "cn"
                                                          ? "Ubuntu"
                                                          : "Ubuntu"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 15),
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
                                                    : double.parse(HomePageV2
                                                                .token) >
                                                            1000
                                                        ? double.parse(
                                                                    HomePageV2
                                                                        .token)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            ""
                                                        : double.parse(
                                                                    HomePageV2
                                                                        .token)
                                                                .toStringAsFixed(
                                                                    5) +
                                                            "",
//                                      "9999999.00000",
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                    fontSize: 38,
                                                    color: Colors.white,
                                                    letterSpacing: 1.0,
                                                    fontFamily:
                                                        BoxApp.language == "cn"
                                                            ? "Ubuntu"
                                                            : "Ubuntu"),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
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
//                              Positioned(
//                                right: 0,
//                                top: 0,
//                                child: GestureDetector(
//                                  onTap: (){
//                                    Clipboard.setData(ClipboardData(text: namesModel[0].name));
//                                    Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//
//                                  },
//                                  child: Material(
//                                    color: Colors.transparent,
//                                    child: Container(
//                                      width: 80,
//                                      height: 80,
//
//                                    ),
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                          Container(
                            height: 48,
                            margin: EdgeInsets.only(
                                left: 5, right: 0, top: 0, bottom: 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).home_send_receive,
                              style: TextStyle(
                                color: Color(0xFF000000),
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
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 90,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 0),
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    color: Color(0xE6FFFFFF),
                                    //设置四周圆角 角度
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TokenSendOnePage()));
                                      },
                                      child: Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Image(
                                                      width: 56,
                                                      height: 56,
                                                      image: AssetImage(
                                                          "images/home_send_token.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .home_page_function_send,
                                                        style: new TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                BoxApp.language ==
                                                                        "cn"
                                                                    ? "Ubuntu"
                                                                    : "Ubuntu",
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
//                                            Positioned(
//                                              right: 23,
//                                              child: Container(
//                                                width: 25,
//                                                height: 25,
//                                                padding: const EdgeInsets.only(left: 0),
//                                                //边框设置
//                                                decoration: new BoxDecoration(
//                                                  color: Color(0xFFF5F5F5),
//                                                  //设置四周圆角 角度
//                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                                                ),
//                                                child: Icon(
//                                                  Icons.arrow_forward_ios,
//                                                  size: 15,
//                                                  color: Color(0xFFCCCCCC),
//                                                ),
//                                              ),
//                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 12,
                              ),
                              Expanded(
                                child: Container(
                                  height: 90,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 0),
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    color: Color(0xE6FFFFFF),
                                    //设置四周圆角 角度
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TokenReceivePage()));
                                      },
                                      child: Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Image(
                                                      width: 56,
                                                      height: 56,
                                                      image: AssetImage(
                                                          "images/home_receive_token.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .home_page_function_receive,
                                                        style: new TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                BoxApp.language ==
                                                                        "cn"
                                                                    ? "Ubuntu"
                                                                    : "Ubuntu",
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
//                                            Positioned(
//                                              right: 23,
//                                              child: Container(
//                                                width: 25,
//                                                height: 25,
//                                                padding: const EdgeInsets.only(left: 0),
//                                                //边框设置
//                                                decoration: new BoxDecoration(
//                                                  color: Color(0xFFF5F5F5),
//                                                  //设置四周圆角 角度
//                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                                                ),
//                                                child: Icon(
//                                                  Icons.arrow_forward_ios,
//                                                  size: 15,
//                                                  color: Color(0xFFCCCCCC),
//                                                ),
//                                              ),
//                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 90,
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 12),
                            //边框设置
                            decoration: new BoxDecoration(
                              color: Color(0xE6FFFFFF),
                              //设置四周圆角 角度
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TokenListPage()));
                                },
                                child: Container(
                                  height: 90,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: Image(
                                                width: 56,
                                                height: 56,
                                                image: AssetImage(
                                                    "images/home_token.png"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  S.of(context).home_token,
                                                  style: new TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          BoxApp.language ==
                                                                  "cn"
                                                              ? "Ubuntu"
                                                              : "Ubuntu",
                                                      color: Colors.black),
                                                ),
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
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          //边框设置
                                          decoration: new BoxDecoration(
                                            color: Color(0xFFF5F5F5),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                            color: Color(0xFFCCCCCC),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          getRecordContainer(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 8,
            ),
          ],
        ),
      ),
    )));
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
      margin: EdgeInsets.only(
          top: 12, bottom: MediaQuery.of(context).padding.bottom),
      //边框设置
      decoration: new BoxDecoration(
        color: Color(0xE6FFFFFF),
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          splashColor: Colors.white,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecordsPage()));
          },
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Image(
                              width: 56,
                              height: 56,
                              image: AssetImage("images/home_record.png"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              S.of(context).home_page_transaction,
                              style: new TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu",
                                  color: Colors.black),
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
                          color: Color(0xFFF5F5F5),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (walletRecordModel != null)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15, top: 0),
                  child: Text(
                    S.of(context).home_page_transaction_conform,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontFamily:
                            BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFFF22B79)),
                          ),
                        ),
                      ),
                    if (walletRecordModel != null &&
                        walletRecordModel.data.length == 0)
                      Container(
                          child: Center(
                              child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              width: 198,
                              height: 164,
                              image: AssetImage('images/no_record.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                S.of(context).home_no_record,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: BoxApp.language == "cn"
                                        ? "Ubuntu"
                                        : "Ubuntu",
                                    color: Color(0xFF000000)),
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

  Container getTokensContainer(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 12),
      //边框设置
      decoration: new BoxDecoration(
        color: Color(0xE6FFFFFF),
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecordsPage()));
          },
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Image(
                              width: 56,
                              height: 56,
                              image: AssetImage("images/home_financial.png"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              "AEX9 Tokens",
                              style: new TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu",
                                  color: Colors.black),
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
                          color: Color(0xFFF5F5F5),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    getTokensItem(context, 0),
                    getTokensItem(context, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTokensItem(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 18, top: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 75,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "USDT",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    fontFamily: BoxApp.language == "cn"
                                        ? "Ubuntu"
                                        : "Ubuntu"),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "100000000.00",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu"),
                            ),
                          ),
                        ],
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

  Widget getItem(BuildContext context, int index) {
    if (walletRecordModel == null || walletRecordModel.data.length <= index) {
      return Container();
    }
    if (index == 0) {
      print(walletRecordModel.data[index].hash);
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 10, bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //边框设置

                child: Text(
                  (blockTopModel.data.height -
                          walletRecordModel.data[index].blockHeight)
                      .toString(),
                  style: TextStyle(
                      color: Color(0xFFFC2365),
                      fontSize: 14,
                      fontFamily:
                          BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                      width:
                          MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                getTxType(index),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: BoxApp.language == "cn"
                                        ? "Ubuntu"
                                        : "Ubuntu"),
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
                        strutStyle: StrutStyle(
                            forceStrutHeight: true,
                            height: 0.8,
                            leading: 1,
                            fontFamily:
                                BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        style: TextStyle(
                            color: Colors.black.withAlpha(56),
                            letterSpacing: 1.0,
                            fontSize: 13,
                            fontFamily:
                                BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                      ),
                      width:
                          MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                        DateTime.fromMicrosecondsSinceEpoch(
                                walletRecordModel.data[index].time * 1000)
                            .toLocal()
                            .toString(),
                        style: TextStyle(
                            color: Colors.black.withAlpha(56),
                            fontSize: 13,
                            letterSpacing: 1.0,
                            fontFamily:
                                BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
          if ("ak_dMyzpooJ4oGnBVX35SCvHspJrq55HAAupCwPQTDZmRDT5SSSW" ==
              walletRecordModel.data[index].tx['recipient_id']) {
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

      if (walletRecordModel.data[index].tx['recipient_id'].toString() ==
          HomePageV2.address) {
        return Text(
          "+" +
              ((walletRecordModel.data[index].tx['amount'].toDouble()) /
                      1000000000000000000)
                  .toString() +
              " AE",
          style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      } else {
        return Text(
          "-" +
              ((walletRecordModel.data[index].tx['amount'].toDouble()) /
                      1000000000000000000)
                  .toString() +
              " AE",
          style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
        );
      }
    } else {
      return Text(
        "-" +
            (walletRecordModel.data[index].tx['fee'].toDouble() /
                    1000000000000000000)
                .toString() +
            " AE",
        style: TextStyle(
            color: Colors.black.withAlpha(56),
            fontSize: 14,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }
  }

  Future<void> _onRefresh() async {
    netBaseData();
    netAccountInfo();
    netContractBalance();
    getAddress();
    netTopHeightData();
    netSwapDao();
    netNameReverseData();
    eventBus.fire(DefiEvent());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
