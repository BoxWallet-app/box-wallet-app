import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_nft_balance_dao.dart';
import 'package:box/dao/conflux/cfx_token_address_dao.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/dao/ethereum/eth_activity_coin_dao.dart';
import 'package:box/dao/ethereum/eth_token_price_dao.dart';
import 'package:box/dao/ethereum/eth_token_price_rate_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/model/ethereum/eth_token_price_request_model.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'eth_home_page.dart';
import 'eth_token_add_page.dart';
import 'eth_token_record_page.dart';

class EthTokenListPage extends StatefulWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<EthTokenListPage> with SingleTickerProviderStateMixin {
  var tokenLoadingType = LoadingType.loading;
  List<Tokens>? cfxCtTokens = [];
  Account? account;
  bool isDelete = false;

  Future<void> _onRefresh() async {
    // await netTokenBaseData();

    account = await WalletCoinsManager.instance.getCurrentAccount();

    var chainID = EthManager.instance.getChainID(account!);
    cfxCtTokens = await CtTokenManager.instance.getEthCtTokens(chainID, account!.address!);
    // print(ethTokenRateModel.toJson());
    var firstTokenListLoad = await CacheManager.instance.getFirstTokenListLoad(account!.address!, account!.coin!);
    if (cfxCtTokens!.length == 0 && !firstTokenListLoad) {
      try {
        var ethActivityCoinModel = await EthActivityCoinDao.fetch(EthManager.instance.getChainID(account!));
        if (ethActivityCoinModel.data != null && ethActivityCoinModel.data!.length > 0) {
          for (var i = 0; i < ethActivityCoinModel.data!.length; i++) {
            if (ethActivityCoinModel.data![i].address != "") {
              Tokens token = Tokens();
              token.ctId = ethActivityCoinModel.data![i].address;
              token.name = ethActivityCoinModel.data![i].name;
              token.symbol = ethActivityCoinModel.data![i].symbol;
              token.quoteUrl = ethActivityCoinModel.data![i].website;
              token.iconUrl = ethActivityCoinModel.data![i].iconUrl;
              cfxCtTokens!.insert(0, token);
            }
          }
          await CacheManager.instance.setFirstTokenListLoad(account!.address!, account!.coin!,true);
          await CtTokenManager.instance.updateETHCtTokens(chainID, account!.address, cfxCtTokens);
        }
      } catch (e) {
        tokenLoadingType = LoadingType.error;
      }
    }

    if (cfxCtTokens!.length == 0) {
      tokenLoadingType = LoadingType.no_data;
    } else {
      tokenLoadingType = LoadingType.finish;
    }

    setState(() {});

    // tokenLoadingType = LoadingType.finish;
    // setState(() {});
    await getCacheBalance(account!.address);
    await getBalance(account!.address);
  }

  getCacheBalance(String? address) async {
    for (int i = 0; i < cfxCtTokens!.length; i++) {
      if (cfxCtTokens![i].balanceCache == null) {
        Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
        var cacheBalance = await CacheManager.instance.getTokenBalance(account.address!, cfxCtTokens![i].ctId!, account.coin!);
        if (cacheBalance != "") {
          cfxCtTokens![i].balanceCache = cacheBalance;
          setState(() {});
        }
      }
    }
    updatePrice();
  }

  bool isLoadBalance = false;

  // Future<void> getBalance(String address) async {
  //   if (isLoadBalance) {
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
  //   if (isReturn) {
  //     updatePrice();
  //     return;
  //   }
  //   isLoadBalance = true;
  //   if (token.balance == null) {
  //     print(address);
  //     var nodeUrl = await EthManager.instance.getNodeUrl(account);
  //     BoxApp.getErcBalanceETH((balance, decimal,address,coin) async {
  //       balance = AmountDecimal.parseUnits(balance, decimal);
  //       token.balance = Utils.formatBalanceLength(double.parse(balance));
  //
  //       CacheManager.instance.setTokenBalance(account.address, token.ctId, account.coin, token.balance);
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
  // }
  Future<void> getBalance(String? address) async {
    var nodeUrl = await EthManager.instance.getNodeUrl(account!);
    var maxLength = cfxCtTokens!.length;
    for (int i = 0; i < cfxCtTokens!.length; i++) {
      if (cfxCtTokens![i].balance == null) {
        BoxApp.getErcBalanceETH((balance, decimal, address,from, coin) async {
          if(from != account!.address )return;
          balance = AmountDecimal.parseUnits(balance, decimal);
          for (int j = 0; j < cfxCtTokens!.length; j++) {
            if (cfxCtTokens![j].ctId == address) {
              cfxCtTokens![j].balance = Utils.formatBalanceLength(double.parse(balance));
              CacheManager.instance.setTokenBalance(account!.address!, cfxCtTokens![j].ctId, account!.coin!, cfxCtTokens![j].balance!);
            }
          }
          if (i == maxLength - 1) {
            updatePrice();
          }
          if(!mounted)return;
          setState(() {});
        }, address!, cfxCtTokens![i].ctId!, account!.coin!, nodeUrl);
      }
    }
  }

  Future<void> updatePrice() async {
    account = await WalletCoinsManager.instance.getCurrentAccount();

    var chainID = EthManager.instance.getChainID(account!);
    EthTokenPriceRequestModel tokenPriceRequestModel = new EthTokenPriceRequestModel();
    tokenPriceRequestModel.blockchainId = int.parse(chainID);
    tokenPriceRequestModel.tokenList = [];

    cfxCtTokens!.forEach((element) {
      EthTokenPriceRequestItemModel ethTokenPriceRequestItemModel = new EthTokenPriceRequestItemModel();
      ethTokenPriceRequestItemModel.address = element.ctId;
      ethTokenPriceRequestItemModel.blSymbol = element.symbol;
      tokenPriceRequestModel.tokenList!.add(ethTokenPriceRequestItemModel);
    });
    if(!mounted)return;
    setState(() {});
    var ethTokenPriceModel = await EthTokenPriceDao.fetch(tokenPriceRequestModel);

    for (int i = 0; i < cfxCtTokens!.length; i++) {
      if (ethTokenPriceModel.data != null && ethTokenPriceModel.data!.length > 0) {
        cfxCtTokens![i].price = await EthManager.instance.getRateFormat(ethTokenPriceModel.data![i], cfxCtTokens![i].balance == null ? cfxCtTokens![i].balanceCache : cfxCtTokens![i].balance);
      }
    }
    if(!mounted)return;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
  }

  String getTokenPrice(int index) {
    return "-1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // ????????????
        title: Text(
          S.of(context).home_token,
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
          if (!isDelete)
            IconButton(
              splashRadius: 40,
              icon: Icon(
                Icons.delete_outline,
                color: Color(0xFF000000),
                size: 22,
              ),
              onPressed: () {
                isDelete = true;
                setState(() {});
                return;
              },
            ),
          if (isDelete)
            MaterialButton(
              minWidth: 10,
              child: new Text(
                S.of(context).dialog_dismiss,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
              onPressed: () {
                isDelete = false;
                setState(() {});
              },
            ),
          if (!isDelete)
            IconButton(
              splashRadius: 40,
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Color(0xFF000000),
                size: 22,
              ),
              onPressed: () {
                if (Platform.isIOS) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EthTokenAddPage(
                                cfxTokenAddPageCallBackFuture: (isUpdate) {
                                  if (isUpdate) _onRefresh();
                                  return;
                                },
                              )));
                } else {
                  Navigator.push(context, SlideRoute(EthTokenAddPage(
                    cfxTokenAddPageCallBackFuture: (isUpdate) {
                      if (isUpdate) _onRefresh();
                      return;
                    },
                  )));
                }

                return;
              },
            ),
        ],
      ),
      body: LoadingWidget(
        type: tokenLoadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: EasyRefresh(
          header: BoxHeader(),
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
            itemCount: cfxCtTokens!.length,
            itemBuilder: (BuildContext context, int index) {
              return itemListView(context, index);
            },
          ),
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

  Tab createTab(BuildContext context, String tab) {
    return Tab(
        icon: Text(
      tab,
      style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w600),
    ));
  }

  Widget itemListView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if (cfxCtTokens![index].balance == null && cfxCtTokens![index].balanceCache == null) {
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EthTokenRecordPage(
                          ctId: cfxCtTokens![index].ctId,
                          coinCount: cfxCtTokens![index].balance == null ? cfxCtTokens![index].balanceCache : cfxCtTokens![index].balance,
                          coinImage: cfxCtTokens![index].iconUrl,
                          coinName: getCoinName(index),
                        )));
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
                              width: 36.0,
                              height: 36.0,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    EthManager.instance.getCoinName(cfxCtTokens![index].name!, cfxCtTokens![index].symbol!),
                                    style: new TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 2),
                                  child: Text(
                                    cfxCtTokens![index].name!,
                                    style: new TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff999999),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (isDelete)
                              Expanded(child: Container(),),
                            if (isDelete)
                              IconButton(
                                splashRadius: 40,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFF000000),
                                  size: 22,
                                ),
                                onPressed: () async {
                                  Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
                                  var chainID = EthManager.instance.getChainID(account);
                                  var address = await BoxApp.getAddress();
                                  var tokens = await (CtTokenManager.instance.getEthCtTokens(chainID, address) as FutureOr<List<Tokens>>);
                                  var tokensTemp = tokens.sublist(0);
                                  tokensTemp.forEach((element) {
                                    if (element.ctId == cfxCtTokens![index].ctId) {
                                      tokens.remove(element);
                                    }
                                  });
                                  await CtTokenManager.instance.updateETHCtTokens(chainID, address, tokens);
                                  if (tokens == null) {}
                                  _onRefresh();
                                  setState(() {});
                                  return;
                                },
                              ),
                            if (!isDelete)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (cfxCtTokens![index].balance != null || cfxCtTokens![index].balanceCache != null)
                                      AutoSizeText(
                                        cfxCtTokens![index].balance == null ? cfxCtTokens![index].balanceCache! : cfxCtTokens![index].balance!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    if (cfxCtTokens![index].balance == null && cfxCtTokens![index].balanceCache == null)
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

  String getCoinSymbol(int index) {
    String? name;
    if (cfxCtTokens![index].name!.length > cfxCtTokens![index].symbol!.length) {
      name = cfxCtTokens![index].name;
    } else {
      name = cfxCtTokens![index].symbol;
    }
    name = name!.replaceAll("\n", "");
    if (name.length > 10) {
      // name = name.substring(0, 5) + "..." + name.substring(name.length - 4, name.length);
    }
    return name;
  }
}
