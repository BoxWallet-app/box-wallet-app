import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:box/dao/aeternity/block_top_dao.dart';
import 'package:box/dao/aeternity/name_reverse_dao.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/aeternity/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/page/aeternity/ae_records_page.dart';
import 'package:box/page/aeternity/ae_vegas_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'ae_aens_page.dart';
import 'ae_swap_page.dart';
import 'ae_token_list_page.dart';
import 'ae_token_receive_page.dart';
import 'ae_token_send_one_page.dart';
import 'ae_tx_detail_page.dart';
import 'ae_wetrue_web_page.dart';
import 'aens_market_orders_page.dart';

class AeHomePage extends StatefulWidget {
  static var token = "loading...";
  static String? tokenABC = "loading...";
  static int? height = 0;
  static String? address = "";

  @override
  _AeHomePageState createState() => _AeHomePageState();
}

class _AeHomePageState extends State<AeHomePage> with AutomaticKeepAliveClientMixin {
  PriceModel? priceModel;
  static var contentText = "";
  WalletTransferRecordModel? walletRecordModel;
  var page = 1;
  BlockTopModel? blockTopModel;
  SwapModel? swapModels;
  double? premium;
  String _aens = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventBus.on<LanguageEvent>().listen((event) {
      netData();
      setState(() {});
    });
    eventBus.on<AccountUpdateEvent>().listen((event) {
      priceModel = null;
      walletRecordModel = null;
      blockTopModel = null;
      _aens = "";
      AeHomePage.token = "loading...";
      AeHomePage.tokenABC = "loading...";
      if (!mounted) return;
      setState(() {});

      netData();
    });
    netData();
  }

  void netNameReverseData() {
    NameReverseDao.fetch().then((String aens) {
      // if (model.isNotEmpty) {
      //   if (model.isNotEmpty) {
      //     model.sort((left, right) => right.expiresAt!.compareTo(left.expiresAt!));
      //   }
      _aens = aens;
      //   print(namesModel);
      setState(() {});
      // } else {}
    }).catchError((e) {
      print(e.toString());
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Future<void> netTopHeightData() async {
    int aeHeight = await CacheManager.instance.getAEHeight();
    if (aeHeight > 0) {
      AeHomePage.height = aeHeight;
      netWalletRecord();
    }

    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        blockTopModel = model;
        AeHomePage.height = blockTopModel!.data!.height;
        CacheManager.instance.setAEHeight(AeHomePage.height!);
//        setState(() {});
        netWalletRecord();
      } else {}
    }).catchError((e) {
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Future<void> netWalletRecord() async {
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var aeRecord = await CacheManager.instance.getAERecord(account!.address!, account.coin!);
    if (aeRecord != null) {
      walletRecordModel = aeRecord;
      if (!mounted) return;
      setState(() {});
    }
    WalletRecordDao.fetch(page).then((WalletTransferRecordModel model) {
      if (model.code == 200) {
        if (page == 1) {
          walletRecordModel = model;
          if (model.data == null || model.data!.length == 0) {
            setState(() {});
            return;
          }
          walletRecordModel = model;
          CacheManager.instance.setAERecord(account.address!, account.coin!, walletRecordModel);
        } else {
          walletRecordModel!.data!.addAll(model.data!);
        }

        setState(() {});
      } else {}
    }).catchError((e) {
      if (!mounted) return;
      setState(() {});
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Future<void> netAccountInfo() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }
    //
    var params = {
      "name": "aeBalance",
      "params": {"address": account.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      AeHomePage.token = Utils.formatBalanceLength(double.parse(balance));
      CacheManager.instance.setBalance(account.address!, account.coin!, AeHomePage.token);
      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> netContractBalance() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getTokenBalance(account!.address!, BoxApp.ABC_CONTRACT_AEX9, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.tokenABC = cacheBalance;
      setState(() {});
    }

    var params = {
      "name": "aeAex9TokenBalance",
      "params": {"ctAddress": BoxApp.ABC_CONTRACT_AEX9, "address": account.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      var address = jsonResponse["result"]["address"];
      var ctAddress = jsonResponse["result"]["ctAddress"];
      if (!mounted) return;
      if (address != account.address) return;
      if (ctAddress != BoxApp.ABC_CONTRACT_AEX9) return;
      AeHomePage.tokenABC = Utils.formatBalanceLength(double.parse(balance));
      CacheManager.instance.setTokenBalance(account.address!, BoxApp.ABC_CONTRACT_AEX9, account.coin!, AeHomePage.tokenABC!);
      setState(() {});
      return;
    }, channelJson);

    // BoxApp.getErcBalanceAE((balance, decimal, address, from, coin) async {
    //   if (!mounted) return;
    //   if (from != account.address) return;
    //   AeHomePage.tokenABC = Utils.formatBalanceLength(double.parse(AmountDecimal.parseUnits(balance, decimal)));
    //   CacheManager.instance.setTokenBalance(account.address!, BoxApp.ABC_CONTRACT_AEX9, account.coin!, AeHomePage.tokenABC!);
    //   setState(() {});
    //   return;
    // }, account.address!, BoxApp.ABC_CONTRACT_AEX9);

//     ContractBalanceDao.fetch(BoxApp.ABC_CONTRACT_AEX9).then((ContractBalanceModel model) {
//       if (model.code == 200) {
//         AeHomePage.tokenABC = model.data.balance;
//         setState(() {});
//       } else {}
//     }).catchError((e) {
// //      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//     });
  }

  List<Widget> icons = [];

  getAddress() async {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? account) {
      AeHomePage.address = account!.address;
      if (!mounted) return;
      setState(() {});
    });
    var aeHomeFunction = await CacheManager.instance.getAeHomeFunction();
    if (aeHomeFunction != "") {
      var homeFunctionDecode = jsonDecode(aeHomeFunction.toString());
      var homeFunction = homeFunctionDecode["data"];

      icons.clear();
      for (var i = 0; i < homeFunction.length; i++) {
        var groupName = createGroupName(BoxApp.language == "cn" ? homeFunction[i]["cn_name"] : homeFunction[i]["en_name"]);
        var child = createChild(homeFunction[i]["info"]);

        icons.add(groupName);
        icons.add(child);
      }
      setState(() {});
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String language = BoxApp.language;
    String platform = Platform.isIOS ? "iOS" : "android";
    String url = "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/api/home-function/" + packageInfo.version.replaceAll(".", "") + "/$language-$platform.json";
    print(url);
    Response homeFunctionResponse = await Dio().get(url);

    var homeFunctionDecode = jsonDecode(homeFunctionResponse.toString());

    CacheManager.instance.setAeHomeFunction(url, homeFunctionResponse.toString());
    logger.info(homeFunctionDecode);

    var homeFunction = homeFunctionDecode["data"];

    icons.clear();
    for (var i = 0; i < homeFunction.length; i++) {
      var groupName = createGroupName(BoxApp.language == "cn" ? homeFunction[i]["cn_name"] : homeFunction[i]["en_name"]);
      var child = createChild(homeFunction[i]["info"]);

      icons.add(groupName);
      icons.add(child);
    }
    setState(() {});
  }

  void netBaseData() {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    PriceDao.fetch().then((PriceModel model) {
      priceModel = model;
      print("123123123123123" + priceModel.toString());
      getAePrice();
      setState(() {});
    }).catchError((e) {
      print("123123123123123" + e.toString());
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice() {
    if (AeHomePage.token == "loading...") {
      return "";
    }
    if (BoxApp.language == "cn" && priceModel!.aeternity != null) {
      if (priceModel!.aeternity!.cny == null) {
        return "";
      }
      if (double.parse(AeHomePage.token) < 1000) {
        return "¥" + (priceModel!.aeternity!.cny! * double.parse(AeHomePage.token)).toStringAsFixed(4) + " ≈";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "¥" + (priceModel!.aeternity!.cny! * double.parse(AeHomePage.token)).toStringAsFixed(4) + " ≈";
      }
    } else {
      if (priceModel!.aeternity!.usd == null) {
        return "";
      }
      return "\$" + (priceModel!.aeternity!.usd! * double.parse(AeHomePage.token)).toStringAsFixed(4) + " ≈";
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //需要调用super
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
                        borderRadius: BorderRadius.circular(5.0),
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
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
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
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(top: 12, left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                priceModel == null
                                                    ? Container()
                                                    : Container(
                                                        margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
                                                        child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                          getAePrice(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
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
//                                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
//                                                    ),
//                                                  ),
//                                                ),
                                                Expanded(child: Container()),
                                                Text(
                                                  AeHomePage.tokenABC == "loading..." ? "--.--" : AeHomePage.tokenABC! + " ABC",
//                                      "9999999.00000",
                                                  overflow: TextOverflow.ellipsis,

                                                  style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
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
                                    Clipboard.setData(ClipboardData(text: AeHomePage.address));
                                    Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 160,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 20, right: 50),
                                    child: Text(Utils.formatHomeCardAddress(AeHomePage.address), style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xffbd2a67).withAlpha(100), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto")),
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
                                              style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                margin: const EdgeInsets.only(left: 2, right: 20),
                                                child: Text(
                                                  _aens,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20, left: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(child: Container()),
                                            Row(
                                              children: [
                                                Text(
                                                  AeHomePage.token == "loading..."
                                                      ? "--.--"
                                                      : double.parse(AeHomePage.token) > 1000
                                                          ? double.parse(AeHomePage.token).toStringAsFixed(2) + ""
                                                          : double.parse(AeHomePage.token).toStringAsFixed(5) + "",
//                                      "9999999.00000",
                                                  overflow: TextOverflow.ellipsis,

                                                  // style: TextStyle(fontSize: 38, color: Colors.white, fontFamily: "Inter"),
                                                  style: TextStyle(fontSize: 38, color: Colors.white, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: icons,
                            )
                          ],
                        ),
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

  Container createChild(homeFunctionInfo) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 12),

      //边框设置
      decoration: new BoxDecoration(
        border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
        color: Color(0xE6FFFFFF),
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),

      child: Container(
        child: GridView.builder(
          itemBuilder: (BuildContext context, int position) {
            return Material(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                onTap: () {
                  var event = homeFunctionInfo[position]['event'];
                  logger.info(event);
                  if (event == "Spend") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeTokenSendOnePage()));
                    return;
                  }
                  if (event == "Receive") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                    return;
                  }
                  if (event == "Aens") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeAensPage()));
                    return;
                  }
                  if (event == "Tokens") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeTokenListPage()));
                    return;
                  }
                  if (event == "Record") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeRecordsPage()));
                    return;
                  }
                  if (event == "Swap") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeSwapPage()));
                    return;
                  }
                  if (event == "Vegas") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeVegasPage()));
                    return;
                  }
                  if (event == "AensMarket") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AensMarketOrdersPage()));
                    return;
                  }
                  if (event == "WeTrue") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AeWetrueWebPage()));
                    return;
                  }
                  if (event == "AeKnow") {
                    _launchURL("https://aeknow.org");
                    return;
                  }
                  if (event == "Explorer") {
                    _launchURL("https://explorer.aeternity.io");
                    return;
                  }
                  Fluttertoast.showToast(msg: BoxApp.language == "cn" ? "开发中" : "Developing", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);

                  // if (homeFunctionInfo["function" == "spend"]) {}
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  // margin: const EdgeInsets.only(top: 5, bottom: 10),
                  width: (MediaQuery.of(context).size.width - 32) / 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(top: 15),
                        child: CachedNetworkImage(
                          imageUrl: homeFunctionInfo[position]["icon"],
                          fadeOutDuration: const Duration(seconds: 0),
                          fadeInDuration: const Duration(seconds: 0),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(
                          BoxApp.language == "cn" ? homeFunctionInfo[position]["cn_name"] : homeFunctionInfo[position]["en_name"],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homeFunctionInfo.length,
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 100 / 106,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
        ),
      ),
    );
  }

  Container createGroupName(String name) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 0, top: 12, bottom: 0),
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.w500,
          fontSize: 16,
          fontFamily: BoxApp.language == "cn"
              ? "Roboto"
              : BoxApp.language == "cn"
                  ? "Roboto"
                  : "Roboto",
        ),
      ),
    );
  }


  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _onRefresh() async {
    netData();
  }

  void netData() {
    netAccountInfo();
    netContractBalance();
    getAddress();
    netNameReverseData();
    netBaseData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
