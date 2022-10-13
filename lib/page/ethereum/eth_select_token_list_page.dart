import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';

typedef EthSelectTokenListCallBackFuture = Future? Function(String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract);

class EthSelectTokenListPage extends StatefulWidget {
  final String? aeCount;
  final EthSelectTokenListCallBackFuture? aeSelectTokenListCallBackFuture;

  const EthSelectTokenListPage({Key? key, this.aeCount, this.aeSelectTokenListCallBackFuture}) : super(key: key);

  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<EthSelectTokenListPage> {
  var loadingType = LoadingType.loading;
  List<Tokens>? cfxCtTokens = [];
  Account? account;
  Future<void> _onRefresh() async {
   account = await WalletCoinsManager.instance.getCurrentAccount();

    var chainID = EthManager.instance.getChainID(account!);
    cfxCtTokens = await CtTokenManager.instance.getEthCtTokens(chainID, account!.address!);
    if (cfxCtTokens!.length == 0) {
      loadingType = LoadingType.no_data;
      setState(() {});
      return;
    }
    loadingType = LoadingType.finish;
    setState(() {});
    getBalance(account!.address);
  }

  bool isLoadBalance = false;

  // Future<void> getBalance(String address) async {
  //   if(isLoadBalance){
  //     return;
  //   }
  //   bool isReturn = true;
  //   Tokens token;
  //
  //   for (int i = 0; i < cfxCtTokens.length; i++) {
  //     if (cfxCtTokens[i].balance == null) {
  //       isReturn = false;
  //       token = cfxCtTokens[i];
  //       break;
  //     }
  //   }
  //
  //   if (isReturn) return;
  //   isLoadBalance = true;
  //   if (token.balance == null) {
  //     var nodeUrl = await EthManager.instance.getNodeUrl(account);
  //     BoxApp.getErcBalanceETH((balance,decimal,address,coin) async {
  //
  //       balance = AmountDecimal.parseUnits(balance, decimal);
  //       token.balance = Utils.formatBalanceLength(double.parse(balance));
  //
  //       isLoadBalance = false;
  //       if (!mounted) {
  //         return;
  //       }
  //       setState(() {});
  //       await getBalance(address);
  //       return;
  //     }, address, token.ctId,account.coin, nodeUrl);
  //   }
  //   isLoadBalance = false;
  // }
  Future<void> getBalance(String? address) async {
    var nodeUrl = await EthManager.instance.getNodeUrl(account!);
    var maxLength =  cfxCtTokens!.length;
    for (int i = 0; i < cfxCtTokens!.length; i++) {
      if (cfxCtTokens![i].balance == null) {
        BoxApp.getErcBalanceETH((balance, decimal, address,from, coin) async {
          if(from != account!.address )return;
          balance = AmountDecimal.parseUnits(balance, decimal);
          print(balance);
          for (int j = 0; j < cfxCtTokens!.length; j++) {
            if (cfxCtTokens![j].ctId == address) {
              cfxCtTokens![j].balance = Utils.formatBalanceLength(double.parse(balance));
            }
          }
          if(i == maxLength-1){
            // updatePrice();
          }
          setState(() {});
        }, address!, cfxCtTokens![i].ctId!, account!.coin!, nodeUrl);
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(0),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          InkResponse(
              highlightColor: Colors.transparent,
              radius: 0.0,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: ShapeDecoration(
              // color: Color(0xffffffff),
              // color: Color(0xFFfafafa),
              color: Color(0xFFfafbfc),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 52,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 52,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).cfx_select_token_page_title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 52,
                              width: 52,
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                Icons.close,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75 - 52,
                  child: LoadingWidget(
                    type: loadingType,
                    onPressedError: () {
                      _onRefresh();
                    },
                    child: EasyRefresh(
                      header: BoxHeader(),
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
                        itemCount: cfxCtTokens!.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return itemListView(context, index);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemListView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              if (widget.aeSelectTokenListCallBackFuture != null) {
                widget.aeSelectTokenListCallBackFuture!(account!.coin, widget.aeCount, "https://ae-source.oss-cn-hongkong.aliyuncs.com/"+account!.coin!+".png", "");
              }
              Navigator.pop(context);
            },
            child: Container(
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
                          margin: const EdgeInsets.only(top: 0, left: 15),
                          child: Row(
                            children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(36.0),
                                  image: DecorationImage(
                                    image: AssetImage("images/" + account!.coin!+ ".png"),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  account!.coin!,
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.aeCount!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                  ),
                                ],
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
          ),
        ),
      );
    }
    index = index - 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if (widget.aeSelectTokenListCallBackFuture != null) {
              widget.aeSelectTokenListCallBackFuture!(getCoinName(index), cfxCtTokens![index].balance, cfxCtTokens![index].iconUrl, cfxCtTokens![index].ctId);
            }
            Navigator.pop(context);
          },
          child: Container(
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
                        margin: const EdgeInsets.only(top: 0, left: 15),
                        child: Row(
                          children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  cfxCtTokens![index].iconUrl!,
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
                                getCoinName(index)!,
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (cfxCtTokens![index].balance != null)
                                    AutoSizeText(
                                      cfxCtTokens![index].balance!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                    ),
                                  if (cfxCtTokens![index].balance == null)
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
                                        'images/loading.json',
//              'images/animation_khzuiqgg.json',
                                      ),
                                    ),
                                  if (cfxCtTokens![index].price != null)
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        cfxCtTokens![index].price!,
                                        overflow: TextOverflow.ellipsis,

                                        style: TextStyle(fontSize: 13, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
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
        ),
      ),
    );
  }

  String? getCoinName(int index) {
    String? name;
    if (cfxCtTokens![index].name!.length < cfxCtTokens![index].symbol!.length) {
      name = cfxCtTokens![index].name;
    } else {
      name = cfxCtTokens![index].symbol;
    }
    if (name!.length > 10) {
      name = name.substring(0, 5) + "..." + name.substring(name.length - 4, name.length);
    }
    return name;
  }
}
