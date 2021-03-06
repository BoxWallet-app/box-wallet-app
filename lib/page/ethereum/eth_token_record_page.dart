import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/conflux/cfx_crc20_transfer_dao.dart';
import 'package:box/dao/ethereum/eth_token_price_dao.dart';
import 'package:box/dao/ethereum/eth_transfer_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_crc20_transfer_model.dart';
import 'package:box/model/ethereum/eth_token_price_request_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'eth_home_page.dart';
import 'eth_token_receive_page.dart';
import 'eth_token_send_one_page.dart';

// import 'cfx_home_page.dart';
// import 'cfx_token_receive_page.dart';
// import 'cfx_token_send_one_page.dart';

class EthTokenRecordPage extends StatefulWidget {
  final String? ctId;
  final String? coinName;
  final String? coinImage;
  final String? coinCount;

  const EthTokenRecordPage({Key? key, this.ctId, this.coinName, this.coinCount, this.coinImage}) : super(key: key);

  @override
  _TokenRecordState createState() => _TokenRecordState();
}

class _TokenRecordState extends State<EthTokenRecordPage> {
  var loadingType = LoadingType.finish;
  EthTransferModel? tokenListModel;
  int page = 1;
  String? count;
  String? price;
  EasyRefreshController _controller = EasyRefreshController();
  String? coinCount;
  Account? account;
  int decimal = 18;

  Future<void> _onRefresh() async {
    page = 1;
    netTokenBalance();
    netTokenRecord();
  }

  Future<void> netTokenBalance() async {
    Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
    var nodeUrl = await EthManager.instance.getNodeUrl(account);
    var address = await BoxApp.getAddress();
    BoxApp.getErcBalanceETH((balance, decimal,address,from,coin) async {
      if(from != account.address )return;
      if(address != widget.ctId )return;
      balance = AmountDecimal.parseUnits(balance, decimal);
      this.decimal = decimal;
      coinCount = Utils.formatBalanceLength(double.parse(balance));
      updatePrice();


      setState(() {});
      return;
    }, address, widget.ctId!,account.coin!, nodeUrl);
  }

  Future<void> updatePrice() async {
    account = await WalletCoinsManager.instance.getCurrentAccount();

    var chainID = EthManager.instance.getChainID(account!);
    EthTokenPriceRequestModel tokenPriceRequestModel = new EthTokenPriceRequestModel();
    tokenPriceRequestModel.blockchainId = int.parse(chainID);
    tokenPriceRequestModel.tokenList = [];

    EthTokenPriceRequestItemModel ethTokenPriceRequestItemModel = new EthTokenPriceRequestItemModel();
    ethTokenPriceRequestItemModel.address = widget.ctId;
    ethTokenPriceRequestItemModel.blSymbol = widget.coinName;
    tokenPriceRequestModel.tokenList!.add(ethTokenPriceRequestItemModel);
    var ethTokenPriceModel = await EthTokenPriceDao.fetch(tokenPriceRequestModel);

    if (ethTokenPriceModel.data != null && ethTokenPriceModel.data!.length > 0) {
      price = await EthManager.instance.getRateFormat(ethTokenPriceModel.data![0], widget.coinCount);
    }
    if(!mounted)return;
    setState(() {});
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> netTokenRecord() async {
    // CfxCrc20TransferModel model =
    //     await CfxCrc20TransferDao.fetch(page.toString(), widget.ctId);
    try {
      account = await WalletCoinsManager.instance.getCurrentAccount();
      EthTransferModel model = await EthTransferDao.fetch(EthManager.instance.getChainID(account!), widget.ctId, "");

      if (model.data != null) {
        if (page == 1) {
          tokenListModel = model;
          loadingType = LoadingType.finish;
        } else {
          tokenListModel!.data!.addAll(model.data!);
          loadingType = LoadingType.finish;
        }
        print(tokenListModel!.toJson());
        _controller.finishRefresh();
        _controller.finishLoad();
        if (tokenListModel!.data!.length < 20) {
          _controller.finishLoad(noMore: true);
          _controller.finishLoad(success: true, noMore: true);
        }

        setState(() {});
      } else {
        print(model.toJson());
        tokenListModel = null;
        loadingType = LoadingType.finish;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coinCount = widget.coinCount;
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // ????????????
        title: Text(
          S.of(context).home_page_transaction,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
        actions: <Widget>[
            IconButton(
              splashRadius: 40,
              icon: Icon(
                Icons.info_outline,
                color: Color(0xFF000000),
                size: 22,
              ),
              onPressed: () async {
                var scanUrl = await EthManager.instance.getTokenScanUrl(EthHomePage.account!);
                _launchURL(scanUrl + widget.ctId!);
                return;
              },
            ),
        ],
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: EasyRefresh(
          header: BoxHeader(),
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: itemCount(),
            itemBuilder: (BuildContext context, int index) {
              // print(index);
              if (index == 0) {
                return itemHeaderView(context, index);
              } else {
                return itemView(context, index);
              }
            },
          ),
        ),
      ),
    );
  }

  int itemCount() {
    if (tokenListModel == null || tokenListModel!.data == null || tokenListModel!.data!.length == 0) {
      return 1;
    } else {
      return tokenListModel!.data!.length + 1;
    }
  }

  Widget itemHeaderView(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      padding: EdgeInsets.only(bottom: 18),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {},
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 36,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 0, left: 15),
                            child: Row(
                              children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.coinImage!,
                                      errorBuilder: (
                                        BuildContext context,
                                        Object error,
                                        StackTrace? stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                        );
                                      },
                                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) return child;

                                        return AnimatedOpacity(
                                          child: child,
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 2),
                                          curve: Curves.easeOut,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    widget.coinName!,
                                    style: new TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(
                                        Utils.formatBalanceLength(double.parse(coinCount!)),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 24, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                      if (price != null)
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                          price!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                          ),
                                        ),
                                    ],
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
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2 - 25 - 18,
                    margin: const EdgeInsets.only(top: 0),
                    child: FlatButton(
                      onPressed: () {
                        if (Platform.isIOS) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EthTokenSendOnePage(
                                        tokenName: widget.coinName,
                                        tokenCount: coinCount,
                                        tokenImage: widget.coinImage,
                                        tokenContract: widget.ctId,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              SlideRoute(EthTokenSendOnePage(
                                tokenName: widget.coinName,
                                tokenCount: coinCount,
                                tokenImage: widget.coinImage,
                                tokenContract: widget.ctId,
                              )));
                        }
                      },
                      child: Text(
                        S.of(context).home_page_function_send,
                        maxLines: 1,
                        style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF37A1DB)),
                      ),
                      color: Color(0xFF37A1DB).withAlpha(16),
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2 - 25 - 18,
                    margin: const EdgeInsets.only(top: 0),
                    child: FlatButton(
                      onPressed: () {
//                  goDefi(context);
                        if (Platform.isIOS) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EthTokenReceivePage()));
                        } else {
                          Navigator.push(context, SlideRoute(EthTokenReceivePage()));
                        }
                      },
                      child: Text(
                        S.of(context).home_page_function_receive,
                        maxLines: 1,
                        style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF37A1DB)),
                      ),
                      color: Color(0xFF37A1DB).withAlpha(16),
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget itemView(BuildContext context, int index) {
    if (account == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () async {
            var scanUrl = await EthManager.instance.getScanUrl(EthHomePage.account!);
            _launchURL(scanUrl + tokenListModel!.data![index - 1].hash!);
          },
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width - 36,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 0, left: 0),
                            child: Row(
                              children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
//
//                          Container(
//                            width: 36.0,
//                            height: 36.0,
//                            decoration: BoxDecoration(
//                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                              borderRadius: BorderRadius.circular(30.0),
//                            ),
//                            child: ClipOval(
//                              child: Image.network(
//                                tokenListModel.data[index].image,
//                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
//                                  if (wasSynchronouslyLoaded) return child;
//
//                                  return AnimatedOpacity(
//                                    child: child,
//                                    opacity: frame == null ? 0 : 1,
//                                    duration: const Duration(seconds: 2),
//                                    curve: Curves.easeOut,
//                                  );
//                                },
//                              ),
//                            ),
//                          ),
                                Container(
                                  margin: EdgeInsets.only(left: 16),
                                  height: 30,
                                  padding: EdgeInsets.all(6),
                                  width: 30,
                                  //????????????
                                  decoration: new BoxDecoration(
                                    //??????
                                    color: Colors.white,
                                    //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    //??????????????????
                                    border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                  ),
                                  child: Image(
                                    width: 25,
                                    height: 25,
                                    color: tokenListModel!.data![index - 1].from == EthHomePage.address ? Colors.green : Color(0xFFF22B79),
                                    image: tokenListModel!.data![index - 1].from == EthHomePage.address ? AssetImage("images/token_receive.png") : AssetImage("images/token_send.png"),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        tokenListModel!.data![index - 1].from == EthHomePage.address ? Utils.formatAddress(tokenListModel!.data![index - 1].to) : Utils.formatAddress(tokenListModel!.data![index - 1].from),
                                        style: TextStyle(fontSize: 15, color: Color(0xff333333), fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 12, top: 8),
                                      child: Text(
                                        DateTime.fromMicrosecondsSinceEpoch(tokenListModel!.data![index - 1].timestamp! * 1000000)
                                            .toLocal()
                                            .toString()
                                            .substring(0, DateTime.fromMicrosecondsSinceEpoch(tokenListModel!.data![index - 1].timestamp! * 1000000).toLocal().toString().length - 4),
                                        style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,

                                    children: [
                                      AutoSizeText(
                                        tokenListModel!.data![index - 1].to == EthHomePage.address
                                            ? "- " + Utils.formatBalanceLength(double.parse(AmountDecimal.parseUnits(tokenListModel!.data![index - 1].tokenValue, this.decimal))) + " " + widget.coinName!
                                            : "+ " + Utils.formatBalanceLength(double.parse(AmountDecimal.parseUnits(tokenListModel!.data![index - 1].tokenValue, this.decimal))) + " " + widget.coinName!,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 15, color: tokenListModel!.data![index - 1].from == EthHomePage.address ? Colors.black : Colors.black, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                      Container(
                                        height: 5,
                                        // color: Color(0xFFfafbfc),
                                      ),
                                      Text(
                                        "-" + tokenListModel!.data![index - 1].fee.toString() + account!.coin!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Color(0xFFfafbfc),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
