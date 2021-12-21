import 'dart:io';
import 'dart:ui';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_balance_dao.dart';
import 'package:box/dao/conflux/cfx_transfer_dao.dart';
import 'package:box/dao/ethereum/eth_activity_coin_dao.dart';
import 'package:box/dao/ethereum/eth_fee_dao.dart';
import 'package:box/dao/ethereum/eth_transfer_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import 'eth_in_webview_page.dart';
import 'eth_records_page.dart';
import 'eth_token_list_page.dart';
import 'eth_token_receive_page.dart';
import 'eth_token_send_one_page.dart';
import 'eth_tx_detail_page.dart';
import 'eth_webview_page.dart';

class EthHomePage extends StatefulWidget {
  static var token = "loading...";
  static var tokenABC = "0.000000";
  static var height = 0;
  static var address = "";

  static Account account;

  @override
  _EthHomePageState createState() => _EthHomePageState();
}

class _EthHomePageState extends State<EthHomePage> with AutomaticKeepAliveClientMixin {
  PriceModel priceModel;
  EthTransferModel ethTransfer;
  static var price = "";
  var domain = "";
  var page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventBus.on<LanguageEvent>().listen((event) {
      netBaseData();
      getAddress();
      netCfxBalance();
      netCfxTransfer();
    });
    eventBus.on<AccountUpdateEvent>().listen((event) {
      if (!mounted) return;
      priceModel = null;
      ethTransfer = null;
      EthHomePage.token = "loading...";
      EthHomePage.tokenABC = "0.000000";
      price = "";
      domain = "";
      setState(() {});
      netBaseData();
      getAddress();
      netCfxBalance();
      netCfxTransfer();
    });
    netBaseData();
    getAddress();
    netCfxBalance();
    netCfxTransfer();
  }

  Future<void> netCfxBalance() async {
    var address = await BoxApp.getAddress();

    Account account = await WalletCoinsManager.instance.getCurrentAccount();
    var nodeUrl = await EthManager.instance.getNodeUrl(account);
    BoxApp.getBalanceETH((balance) async {
      if (!mounted) return;
      if (balance == "account error") {
        EthHomePage.token = "0.0000";
      } else {
        EthHomePage.token = Utils.formatBalanceLength(double.parse(balance));
      }

      setState(() {});

      var ethActivityCoinModel = await EthActivityCoinDao.fetch(EthManager.instance.getChainID(account));
      if (ethActivityCoinModel != null && ethActivityCoinModel.data != null && ethActivityCoinModel.data.length > 0) {
        price = await EthManager.instance.getRateFormat(ethActivityCoinModel.data[0].priceUsd.toString(), EthHomePage.token);
      }
      setState(() {});

      return;
    }, address, nodeUrl);
  }

  Future<void> netCfxTransfer() async {
    Account account = await WalletCoinsManager.instance.getCurrentAccount();
    EthTransferDao.fetch(EthManager.instance.getChainID(account), "", page.toString()).then((EthTransferModel model) {
      ethTransfer = model;
      setState(() {});
    }).catchError((e) {});
  }

  getDomainName(String address) {
    domain = "";
    BoxApp.getAddressToNameCFX((name) {
      if ("ERROR" != name) {
        domain = name;
      }
      setState(() {});
      return;
    }, address);
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account account) {
      if (!mounted) {
        return;
      }

      EthHomePage.account = account;
      EthHomePage.address = account.address;
      getDomainName(EthHomePage.address);
      setState(() {});
    });
  }

  void netBaseData() {
//     var type = "usd";
//     if (BoxApp.language == "cn") {
//       type = "cny";
//     } else {
//       type = "usd";
//     }
//     PriceDao.fetch("conflux-token", type).then((PriceModel model) {
//       priceModel = model;
//       setState(() {});
//     }).catchError((e) {
// //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//     });
  }

  String getAePrice() {
    if (EthHomePage.token == "loading...") {
      return "";
    }
    if (BoxApp.language == "cn" && priceModel.conflux != null) {
      if (priceModel.conflux.cny == null) {
        return "";
      }
      if (double.parse(EthHomePage.token) < 1000) {
        return "¥" + (priceModel.conflux.cny * double.parse(EthHomePage.token)).toStringAsFixed(4) + " ≈";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "¥" + (priceModel.conflux.cny * double.parse(EthHomePage.token)).toStringAsFixed(4) + " ≈";
      }
    } else {
      if (priceModel.conflux.usd == null) {
        return "";
      }
      return "\$" + (priceModel.conflux.usd * double.parse(EthHomePage.token)).toStringAsFixed(4) + " ≈";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EasyRefresh(
      header: BoxHeader(),
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
//                                    color: Color(0xFF000000).withAlpha(20),
//                                    offset: Offset(0.0, 55.0), //阴影xy轴偏移量
//                                    blurRadius: 50.0, //阴影模糊程度
//                                    spreadRadius: 0.1 //阴影扩散程度
//                                    )
                        ],
                      ),
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Container(
                              height: 120,
                              margin: const EdgeInsets.only(left: 16, right: 16),
                              decoration: new BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: getAccountCardBottomBg().withAlpha(40),
                                      offset: Offset(0.0, 55.0),
                                      //阴影xy轴偏移量
                                      blurRadius: 50.0,
                                      //阴影模糊程度
                                      spreadRadius: 0.1 //阴影扩散程度
                                      )
                                ],
                              ),
                            ),
                          ],
                        ),

                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment:  CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 160,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    border: new Border.all(color: getAccountCardBottomBg().withAlpha(100), width: 1),
                                    gradient: LinearGradient(begin: Alignment.centerLeft, colors: getAccountCardBg()),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 32,
                                    height: 35,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                      color: getAccountCardBottomBg(),
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
                                                price == ""
                                                    ? Container()
                                                    : Container(
                                                        margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
                                                        child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                          price,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                                                  EthHomePage.tokenABC == "loading..."
                                                      ? "loading..."
                                                      : double.parse(EthHomePage.tokenABC) > 1000
                                                          ? double.parse(EthHomePage.tokenABC).toStringAsFixed(2) + " ABC"
                                                          : double.parse(EthHomePage.tokenABC).toStringAsFixed(2) + " ABC",
//                                      "9999999.00000",
                                                  overflow: TextOverflow.ellipsis,

                                                  style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                                    Clipboard.setData(ClipboardData(text: EthHomePage.address));
                                    Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 160,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 20, right: 50),
                                    child: Text(Utils.formatHomeCardAddressCFX(EthHomePage.address), style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: getAccountCardBottomBg(), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
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
                                        margin: const EdgeInsets.only(top: 20, left: 18),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              S.of(context).home_page_my_count + " (" + getAccountCoinName() + "）",
                                              style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              margin: const EdgeInsets.only(left: 2, right: 20),
                                              child: Text(
                                                domain,
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

                                                // if (EthHomePage.token == "loading...")
                                                //   AnimatedFlipCounter(
                                                //     value:  EthHomePage.token == "loading..."
                                                //         ? 0.000000
                                                //         : double.parse(EthHomePage.token),
                                                //     fractionDigits: 6, // decimal precisio
                                                //     duration : EthHomePage.token == "loading..."?const Duration(milliseconds: 0):const Duration(milliseconds: 800),// n
                                                //     suffix: "",
                                                //     textStyle: TextStyle(fontSize: 38, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                                //   ),
                                                // if (EthHomePage.token != "loading...")
                                                  Text(
                                                    EthHomePage.token == "loading..." ? "--.--" : EthHomePage.token,
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
                              margin: EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
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
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Colors.white,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        onTap: () {
                                          // if (Platform.isIOS) {
                                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => EthWebViewPage(title: "test",url:"https://www.cherryswap.net",)));
                                          // } else {
                                          //   Navigator.push(context, SlideRoute(EthWebViewPage(title: "test",url:"https://kswap.finance/?utm_source=moonswap&current_lang=en-en&theme=dark",)));
                                          // }

                                          // if (Platform.isIOS) {
                                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => EthInWebViewPage()));
                                          // } else {
                                          //   Navigator.push(context, SlideRoute(EthInWebViewPage()));
                                          // }

                                          if (Platform.isIOS) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EthTokenSendOnePage()));
                                          } else {
                                            Navigator.push(context, SlideRoute(EthTokenSendOnePage()));
                                          }
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
                                                      margin: const EdgeInsets.only(top: 10),
                                                      child: Image(
                                                        width: 56,
                                                        height: 56,
                                                        image: AssetImage("images/home_send_token.png"),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left: 5),
                                                        child: Text(
                                                          S.of(context).home_page_function_send,
                                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
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
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Colors.white,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        onTap: () {
                                          if (Platform.isIOS) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EthTokenReceivePage()));
                                          } else {
                                            Navigator.push(context, SlideRoute(EthTokenReceivePage()));
                                          }
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
                                                      margin: const EdgeInsets.only(top: 10),
                                                      child: Image(
                                                        width: 56,
                                                        height: 56,
                                                        image: AssetImage("images/home_receive_token.png"),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left: 5),
                                                        child: Text(
                                                          S.of(context).home_page_function_receive,
                                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
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
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  onTap: () {
                                    if (Platform.isIOS) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EthTokenListPage()));
                                    } else {
                                      Navigator.push(context, SlideRoute(EthTokenListPage()));
                                    }
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
                                                margin: const EdgeInsets.only(top: 10),
                                                child: Image(
                                                  width: 56,
                                                  height: 56,
                                                  image: AssetImage("images/home_token.png"),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    S.of(context).home_token,
                                                    style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
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
                                            padding: const EdgeInsets.only(left: 0),
                                            //边框设置
                                            decoration: new BoxDecoration(
                                              color: Color(0xFFfafbfc),
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
                                ),
                              ),
                            ),
                            getRecordContainer(context),
                          ],
                        ),

                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment:  CrossAxisAlignment.center,
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
    ));
  }

  List<Color> getAccountCardBg() {
    if (EthHomePage.account == null) {
      return [];
    }
    if (EthHomePage.account.coin == "BNB") {
      return [
        Color(0xFFE1A200),
        Color(0xFFE6A700),
      ];
    }
    if (EthHomePage.account.coin == "OKT") {
      return [
        Color(0xFF0062DB),
        Color(0xFF1F94FF),
      ];
    }
    if (EthHomePage.account.coin == "HT") {
      return [
        Color(0xFF112FD0),
        Color(0xFF112FD0),
      ];
    }
    if (EthHomePage.account.coin == "ETH") {
      return [
        Color(0xFF5F66A3),
        Color(0xFF5F66A3),
      ];
    }
    return [
      Color(0xFFFFFFFF),
      Color(0xFFFFFFFF),
    ];
  }

  Color getAccountCardBottomBg() {
    if (EthHomePage.account == null) {
      return Color(0xFFFFFFFF);
    }
    if (EthHomePage.account.coin == "BNB") {
      return Color(0xFFCD8E00);
    }
    if (EthHomePage.account.coin == "OKT") {
      return Color(0xFF0060C2);
    }
    if (EthHomePage.account.coin == "HT") {
      return Color(0xFF0F28B1);
    }
    if (EthHomePage.account.coin == "ETH") {
      return Color(0xFF4F5588);
    }
    return Color(0xFFFFFFFF);
  }

  String getAccountCoinName() {
    if (EthHomePage.account == null) {
      return "";
    }
    return EthHomePage.account.coin;
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
            if (Platform.isIOS) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EthRecordsPage()));
            } else {
              Navigator.push(context, SlideRoute(EthRecordsPage()));
            }
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
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
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
                          color: Color(0xFFfafbfc),
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
              if (ethTransfer != null && ethTransfer.data != null)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15, top: 0),
                  child: Text(
                    S.of(context).cfx_home_page_transfer_random,
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                  ),
                  height: 23,
                ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    if (ethTransfer == null)
                      Container(
                        height: 150,
                        child: new Center(
                          child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(getAccountCardBottomBg()),
                          ),
                        ),
                      ),
                    if (ethTransfer != null && ethTransfer.data == null)
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
                                style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
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
            if (Platform.isIOS) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EthRecordsPage()));
            } else {
              Navigator.push(context, SlideRoute(EthRecordsPage()));
            }
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
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
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
                          color: Color(0xFFfafbfc),
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
          // Navigator.push(context, SlideRoute( AeTxDetailPage(recordData: walletRecordModel.data[index])));
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
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "100000000.00",
                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
    if (ethTransfer == null || ethTransfer.data == null || ethTransfer.data.length <= index) {
      return Container();
    }
    if (index == 0) {}

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (Platform.isIOS) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EthTxDetailPage(recordData: ethTransfer.data[index])));
          } else {
            Navigator.push(context, SlideRoute(EthTxDetailPage(recordData: ethTransfer.data[index])));
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 10, bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //边框设置

                child: Text(
                  cfxEpochNumber(index),
                  softWrap: true,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: getAccountCardBottomBg(), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                      width: MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
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
                        ethTransfer.data[index].hash,
                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        style: TextStyle(color: Colors.black.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                      ),
                      width: MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                        DateTime.fromMicrosecondsSinceEpoch(ethTransfer.data[index].timestamp * 1000000).toLocal().toString().substring(0, DateTime.fromMicrosecondsSinceEpoch(ethTransfer.data[index].timestamp * 1000000).toLocal().toString().length - 4),
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

    if (ethTransfer.data[index].from.toString().toLowerCase().contains(EthHomePage.address.toLowerCase())) {
      return S.current.cfx_home_page_transfer_send;
    } else {
      return S.current.cfx_home_page_transfer_receive;
    }
  }

  String cfxEpochNumber(int index) {
    var nonce = int.parse(ethTransfer.data[index].nonce);
    print(nonce);
    if (nonce > 9999) {
      return (nonce / 1000).toStringAsFixed(0) + "K";
    } else {
      return nonce.toString();
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
    if (ethTransfer.data[index].to.toLowerCase() == EthHomePage.address.toLowerCase()) {
      return Text(
        "+ " + (Utils.cfxFormatAsFixed(ethTransfer.data[index].value, 0)) + " " + EthHomePage.account.coin,
        style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    } else {
      return Text(
        "- " + (Utils.cfxFormatAsFixed(ethTransfer.data[index].value, 0)) + " " + EthHomePage.account.coin,
        style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
      );
    }
  }

  Future<void> _onRefresh() async {
    netBaseData();
    getAddress();
    netCfxBalance();
    netCfxTransfer();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
