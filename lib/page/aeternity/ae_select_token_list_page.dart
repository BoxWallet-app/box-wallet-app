import 'dart:async';
import 'dart:convert';

import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import 'ae_home_page.dart';

typedef AeSelectTokenListCallBackFuture = Future? Function(String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract);

class AeSelectTokenListPage extends BaseWidget {
  final String? aeCount;
  final AeSelectTokenListCallBackFuture? aeSelectTokenListCallBackFuture;

  AeSelectTokenListPage({Key? key, this.aeCount, this.aeSelectTokenListCallBackFuture});

  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends BaseWidgetState<AeSelectTokenListPage> {
  var loadingType = LoadingType.loading;
  TokenListModel? tokenListModel;

  Future<void> _onRefresh() async {
    TokenListDao.fetch(AeHomePage.address, "easy").then((TokenListModel model) async {
      if (model.code == 200) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
        setState(() {});
      } else {
        tokenListModel = null;
        loadingType = LoadingType.error;
        setState(() {});
      }
      await getCacheBalance();
      await getBalance();
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
    });
  }

  getCacheBalance() async {
    for (int i = 0; i < tokenListModel!.data!.length; i++) {
      Account account = await getCurrentAccount();
      var cacheBalance = await CacheManager.instance.getTokenBalance(account.address!, tokenListModel!.data![i].ctAddress!, account.coin!);
      if (cacheBalance != "") {
        tokenListModel!.data![i].countStr = cacheBalance;
        setState(() {});
      }
    }
  }

  Future<void> getBalance() async {
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    for (int i = 0; i < tokenListModel!.data!.length; i++) {
      var params = {
        "name": "aeAex9TokenBalance",
        "params": {"ctAddress":  tokenListModel!.data![i].ctAddress!, "address": account!.address}
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
        for (int j = 0; j < tokenListModel!.data!.length; j++) {
          if( tokenListModel!.data![j].ctAddress == ctAddress){
            tokenListModel!.data![j].countStr = AmountDecimal.parseDecimal(balance);
            CacheManager.instance.setTokenBalance(address, ctAddress, account.coin!, AmountDecimal.parseDecimal(balance));
          }

        }
        // if (address != account.address) return;
        // if (ctAddress != BoxApp.ABC_CONTRACT_AEX9) return;
        // AeHomePage.tokenABC = Utils.formatBalanceLength(double.parse(balance));
        // CacheManager.instance.setTokenBalance(account.address!, BoxApp.ABC_CONTRACT_AEX9, account.coin!, AeHomePage.tokenABC!);
        setState(() {});
        return;
      }, channelJson);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(0),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
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
                              S.of(context).ae_select_token_page_title,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                          itemCount: tokenListModel == null ? 0 : tokenListModel!.data!.length + 1,
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
      ),
    );
  }

  void netContractBalance(int index) {
    ContractBalanceDao.fetch(tokenListModel!.data![index].ctAddress).then((ContractBalanceModel model) {
      if (model.code == 200) {
        tokenListModel!.data![index].countStr = model.data!.balance;
        tokenListModel!.data![index].rate = model.data!.rate;
        setState(() {});
      } else {}
    }).catchError((e) {});
  }

  Widget itemListView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              if (widget.aeSelectTokenListCallBackFuture != null) {
                widget.aeSelectTokenListCallBackFuture!("AE", widget.aeCount, "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-ae.png", "");
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
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-ae.png",
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
                                  "AE",
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                                    style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if (tokenListModel!.data![index].countStr == null) {
              EasyLoading.showToast('正在获取数量，请稍后', duration: Duration(seconds: 2));
              return;
            }
            if (widget.aeSelectTokenListCallBackFuture != null) {
              widget.aeSelectTokenListCallBackFuture!(tokenListModel!.data![index].name, tokenListModel!.data![index].countStr, tokenListModel!.data![index].image, tokenListModel!.data![index].ctAddress);
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
                                  tokenListModel!.data![index].image!,
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
                                tokenListModel!.data![index].name!,
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            tokenListModel!.data![index].countStr == null
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    child: Lottie.asset(
                                      'images/loading.json',
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        tokenListModel!.data![index].countStr!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
}
