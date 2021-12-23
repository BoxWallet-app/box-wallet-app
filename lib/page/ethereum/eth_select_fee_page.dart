import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/dao/ethereum/eth_activity_coin_dao.dart';
import 'package:box/dao/ethereum/eth_fee_dao.dart';
import 'package:box/dao/ethereum/eth_token_price_rate_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/model/ethereum/eth_activity_coin_model.dart';
import 'package:box/model/ethereum/eth_fee_model.dart';
import 'package:box/model/ethereum/eth_token_price_rate_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';

typedef EthSelectFeeCallBackFuture = Future Function(String spendFee, String amountFee, String feePrice, String minute,int type);

class EthSelectFeePage extends StatefulWidget {
  final int gasLimit;
  final EthSelectFeeCallBackFuture ethSelectFeeCallBackFuture;

  const EthSelectFeePage({Key key, this.ethSelectFeeCallBackFuture, this.gasLimit}) : super(key: key);

  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<EthSelectFeePage> {
  Account account;
  EthFeeModel ethFeeModel;
  EthActivityCoinModel ethActivityCoinModel;
  EthTokenPriceRateModel ethTokenPriceRateModel;

  Future<void> _onRefresh() async {
    setState(() {});
     account = await WalletCoinsManager.instance.getCurrentAccount();
    ethFeeModel = await EthFeeDao.fetch(EthManager.instance.getChainID(account));
    // if (this.tokenContract == "") {
    var amountFee = Utils.formatBalanceLength(double.parse(ethFeeModel.data.feeList[0].fee) * widget.gasLimit / 1000000000000000000);
    setState(() {});
    ethActivityCoinModel = await EthActivityCoinDao.fetch(EthManager.instance.getChainID(account));
    if (ethActivityCoinModel != null && ethActivityCoinModel.data != null && ethActivityCoinModel.data.length > 0) {
      ethTokenPriceRateModel = await EthTokenRateDao.fetch();
      if(!mounted)return;
      setState(() {});
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
          Expanded(
            child: InkResponse(
                highlightColor: Colors.transparent,
                radius: 0.0,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: EdgeInsets.only(bottom: 50),
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
                            "选择速度",
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
                getFeeItem(context,0),
                getFeeItem(context,1),
                getFeeItem(context,2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container getFeeItem(BuildContext context,int index) {
    return Container(
                margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    onTap: () {
                      // Future Function(String spendFee, String amountFee, String feePrice, String minute,int type);
                      widget.ethSelectFeeCallBackFuture(
                          ethFeeModel.data.feeList[index].fee,
                        (double.parse(ethFeeModel.data.feeList[index].fee) * widget.gasLimit / 1000000000000000000).toString()+" "+account.coin,getFeePrice(index),getFeeMinute(index),index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 0, left: 20),
                                  child: Row(
                                    children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              getType(index),
                                              style: new TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff000000),
//                                            fontWeight: FontWeight.w600,
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          ),
                                          if (ethFeeModel != null)
                                          Container(
                                            child: Text(
                                              getFeeMinute(index),
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
                                      Expanded(child: Container()),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          if (ethFeeModel != null)
                                            Text(
                      "≈"+ (double.parse(ethFeeModel.data.feeList[index].fee) * widget.gasLimit / 1000000000000000000).toStringAsFixed(8)+" "+account.coin,
                                              style: TextStyle(fontSize: 16, color: Color(0xFF333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                            ),
                                          if (ethFeeModel == null)
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: Lottie.asset(
                                                'images/loading.json',
                                              ),
                                            ),
                                          if (ethFeeModel != null && ethTokenPriceRateModel != null && ethActivityCoinModel != null)
                                            Container(
                                              margin: EdgeInsets.only(top: 2),
                                              child: Text(
                                                getFeePrice(index),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                              ),
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

  String getFeeMinute(int index){
    if(double.parse(ethFeeModel.data.feeList[index].minute)<1){
      return "≈"+(double.parse(ethFeeModel.data.feeList[index].minute)*60).toStringAsFixed(0)+"秒钟";
    }
    return "≈"+ethFeeModel.data.feeList[index].minute+"分钟";
  }

  String getType(int index){
    if(index == 0){
      return   "慢速";
    }
    if(index == 1){
      return   "正常";
    }
    if(index == 2){
      return   "快速";
    }
    return "";
  }

  getFeePrice(int index) {
    var amountFee = Utils.formatBalanceLength(double.parse(ethFeeModel.data.feeList[index].fee) * widget.gasLimit / 1000000000000000000);
    if (BoxApp.language == "cn") {
      return "¥" + Utils.formatBalanceLength(double.parse(ethActivityCoinModel.data[0].priceUsd.toString()) * double.parse(amountFee) * double.parse(ethTokenPriceRateModel.data[0].data[0].rate));
    } else {
      return "\$" + Utils.formatBalanceLength(double.parse(ethActivityCoinModel.data[0].priceUsd.toString()) * double.parse(amountFee));
    }
  }
}
