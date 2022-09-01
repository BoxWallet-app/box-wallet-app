import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:box/dao/aeternity/wallet_record_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/page/aeternity/ae_tx_detail_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import '../../model/aeternity/wallet_coins_model.dart';
import 'ae_home_page.dart';

class AeRecordsPage extends StatefulWidget {
  const AeRecordsPage({Key? key}) : super(key: key);

  @override
  _AeRecordsPageState createState() => _AeRecordsPageState();
}

class _AeRecordsPageState extends State<AeRecordsPage> with AutomaticKeepAliveClientMixin {
  LoadingType _loadingType = LoadingType.loading;
  late var tokenInfos;
  late List records;
  int page = 1;
  var address = '';

  @override
  initState() {
    super.initState();
    netData();
  }

  Future<void> netData() async {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? account) {
      AeHomePage.address = account!.address;
      if (!mounted) return;
      setState(() {});
    });
    Response responseTokenInfo = await Dio().get("https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/api/ae-token-info.json");
    tokenInfos = jsonDecode(responseTokenInfo.toString());

    logger.info(tokenInfos);
    Response responseTxs = await Dio().get("https://mainnet.aeternity.io/mdw///txs/backward?account=ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF&limit=30&page=1");

    var responseDecode = jsonDecode(responseTxs.toString());
    List txsData = responseDecode['data'];

    Response responseAex9 = await Dio().get("https://mainnet.aeternity.io/mdw/v2/aex9/transfers/to/ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF");
    var responseAex9Decode = jsonDecode(responseAex9.toString());
    List aex9Data = responseAex9Decode['data'];
    for (var i = 0; i < txsData.length; i++) {
      var txHash = txsData[i]["hash"];
      for (var j = 0; j < aex9Data.length; j++) {
        var aex9Hash = aex9Data[j]["tx_hash"];
        if (txHash == aex9Hash) {
          aex9Data.removeAt(j);
          j--;
        }
      }
    }
    txsData.addAll(aex9Data);

    txsData.sort((left, right) => right["micro_time"].compareTo(left["micro_time"]));

    records = txsData;

    if (!mounted) {
      return;
    }
    _loadingType = LoadingType.finish;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
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
          child: ListView.builder(
            itemBuilder: getItem,
            itemCount: _loadingType == LoadingType.finish ? records.length : 0,
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

  Widget getItem(BuildContext context, int index) {
    var record = records[index];
    var hash = record['hash'];
    var microTime = record['micro_time'];
    var time = Utils.formatTime(microTime);
    //AEX9转账
    if (hash == null) {
      var contractId = record['contract_id'];
      var txHash = record['tx_hash'];
      var sender = record['sender'].toString();
      var recipient = record['recipient'].toString();
      var amount = record['amount'].toString();
      var contractName = "";

      var tokenInfo = tokenInfos[contractId];

      if (tokenInfo != null) {
        contractName = tokenInfo["name"];
        amount = AmountDecimal.parseUnits(amount, tokenInfo["decimals"]);
      } else {
        contractName = "";
        amount = "";
      }

      logger.info("AEX9 Transfer");
      return spendRecord(context, txHash, "AEX9 SpendTx", sender, recipient, amount, contractName, time);
    } else {
      var type = record['tx']['type'];
      var fee = record['tx']['fee'].toString();
      fee = AmountDecimal.parseUnits(fee, 18);
      if (type == "SpendTx") {
        logger.info("SpendTx");
        var sender = record["tx"]['sender_id'].toString();
        var recipient = record["tx"]['recipient_id'].toString();
        var amount = AmountDecimal.parseUnits(record["tx"]['amount'].toString(), 18);
        print(sender);
        print(recipient);
        return spendRecord(context, hash, type, sender, recipient, amount, "AE", time);
      } else if (type == "ContractCallTx") {
        var contractId = record['tx']['contract_id'].toString();
        var function = record['tx']['function'].toString();

        if (contractId == "ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3") {
          if (function == "swap_exact_tokens_for_ae") {
            logger.info("DEX swap_exact_tokens_for_ae");
            var tokenAmountA = record['tx']['arguments'][0]["value"].toString();
            var tokenAmountB = record['tx']['arguments'][1]["value"].toString();
            var tokenA = record['tx']['arguments'][2]["value"][0]["value"].toString();
            var tokenB = record['tx']['arguments'][2]["value"][1]["value"].toString();

            var tokenAInfo = tokenInfos[tokenA];
            if (tokenAInfo != null) {
              tokenA = tokenAInfo["name"];
              tokenAmountA = AmountDecimal.parseUnits(tokenAmountA, tokenAInfo["decimals"]);
            } else {
              tokenA = "";
              tokenAmountA = "";
            }

            var tokenBInfo = tokenInfos[tokenB];
            if (tokenBInfo != null) {
              tokenB = tokenBInfo["name"];
              tokenAmountB = AmountDecimal.parseUnits(tokenAmountB, tokenBInfo["decimals"]);
            } else {
              tokenB = "";
              tokenAmountB = "";
            }


            return dexSwap(context, hash, "Swap", tokenA, tokenB, tokenAmountA, tokenAmountB, time);
          }
          if (function == "swap_exact_ae_for_tokens") {
            logger.info("DEX swap_exact_ae_for_tokens");
            var tokenAmountA = AmountDecimal.parseUnits(record['tx']['amount'].toString(), 18);
            var tokenAmountB = record['tx']['arguments'][0]["value"].toString();
            var tokenA = "AE";
            var tokenB = record['tx']['arguments'][1]["value"][1]["value"].toString();

            var tokenBInfo = tokenInfos[tokenB];
            if (tokenBInfo != null) {
              tokenB = tokenBInfo["name"];
              tokenAmountB = AmountDecimal.parseUnits(tokenAmountB, tokenBInfo["decimals"]);
            } else {
              tokenB = "";
              tokenAmountB = "";
            }

            return dexSwap(context, hash, "Swap", tokenA, tokenB, tokenAmountA, tokenAmountB, time);
          }
          if (function == "swap_exact_tokens_for_tokens") {
            logger.info("DEX swap_exact_tokens_for_tokens");
            var tokenAmountA = record['tx']['arguments'][0]["value"].toString();
            var tokenAmountB = record['tx']['arguments'][1]["value"].toString();
            var tokenA = record['tx']['arguments'][2]["value"][0]["value"].toString();
            var tokenB = record['tx']['arguments'][2]["value"][1]["value"].toString();

            var tokenAInfo = tokenInfos[tokenA];
            if (tokenAInfo != null) {
              tokenA = tokenAInfo["name"];
              tokenAmountA = AmountDecimal.parseUnits(tokenAmountA, tokenAInfo["decimals"]);
            } else {
              tokenA = "";
              tokenAmountA = "";
            }

            var tokenBInfo = tokenInfos[tokenB];
            if (tokenBInfo != null) {
              tokenB = tokenBInfo["name"];
              tokenAmountB = AmountDecimal.parseUnits(tokenAmountB, tokenBInfo["decimals"]);
            } else {
              tokenB = "";
              tokenAmountB = "";
            }
            return dexSwap(context, hash, "Swap", tokenA, tokenB, tokenAmountA, tokenAmountB, time);
          }
          if (function == "add_liquidity") {
            logger.info("DEX add_liquidity");
          }
          if (function == "add_liquidity_ae") {
            logger.info("DEX add_liquidity_ae");
          }
          if (function == "remove_liquidity") {
            logger.info("DEX remove_liquidity");
          }
          if (function == "remove_liquidity_ae") {
            logger.info("DEX remove_liquidity_ae");
          }
        } else {
          logger.info("ContractCallTx");
          var tokenInfo = tokenInfos[contractId];
          if (tokenInfo != null && function == "transfer") {
            logger.info("AEX9 send");
            var sender = record['tx']['caller_id'];
            var recipient = record['tx']['arguments'][0]["value"];
            var amount = record['tx']['arguments'][1]["value"].toString();
            var contractName = tokenInfo["name"];
            amount = AmountDecimal.parseUnits(amount, tokenInfo["decimals"]);
            return spendRecord(context, hash, "AEX9 SpendTx", sender, recipient, amount, contractName, time);
          } else {
            var sender = record['tx']['caller_id'].toString();
            var recipient = contractId;
            var amount = (record['tx']['amount'] + record['tx']['fee']).toString();
            amount = AmountDecimal.parseUnits(amount, 18);
            return spendRecord(context, hash, type, sender, recipient, amount, "AE", time);
          }
        }
      } else if (type == "NameClaimTx") {
        logger.info("NameClaimTx");
        var name = record['tx']['name'].toString();
        var nameFee = AmountDecimal.parseUnits(record['tx']['name_fee'].toString(), 18);
        return nameRecord(context, hash, type, name, nameFee, "AE", time);
      } else if (type == "NameUpdateTx") {
        var name = record['tx']['name'].toString();
        return nameRecord(context, hash, type, name, fee, "AE", time);
      }
      return spendRecord(context, hash, type, AeHomePage.address!, "", fee, "AE", time);
    }
  }

  Container spendRecord(BuildContext context, String hash, String type, String sender, String recipient, String amount, String contractName, String time) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.all(6),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                  ),
                  child: Image(
                    width: 25,
                    height: 25,
                    color: recipient == AeHomePage.address ? Color(0xFFF22B79) : Colors.green,
                    image: recipient == AeHomePage.address ? AssetImage("images/token_receive.png") : AssetImage("images/token_send.png"),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            getTxType(type),
                            style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.black45, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (amount != "")
                        Container(
                          child: Text(
                            (recipient == AeHomePage.address ? "+" + amount : "-" + amount) + " " + contractName,
                            style: TextStyle(color: recipient == AeHomePage.address ? Color(0xFFF22B79) : Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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

  Container dexSwap(BuildContext context, String hash, String type, String tokenA, String tokenB, String tokenAmountA, String tokenAmountB, String time) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    // border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                  ),
                  child: Image(
                    width: 25,
                    height: 25,
                    color: Colors.blueAccent,
                    image: AssetImage("images/token_swap.png"),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            getTxType(type),
                            style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.black45, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "-" + tokenAmountA + " " + tokenA,
                          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          "+" + tokenAmountB + " " + tokenB,
                          style: TextStyle(color: Color(0xFFF22B79), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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

  Container nameRecord(BuildContext context, String hash, String type, String name, String amount, String contractName, String time) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.all(6),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                  ),
                  child: Image(
                    width: 25,
                    height: 25,
                    color: Colors.green,
                    image: AssetImage("images/token_send.png"),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            getTxType(type),
                            style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                        ),
                        if (name != "")
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black45, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.black45, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (amount != "")
                        Container(
                          child: Text(
                            "-" + amount + " " + contractName,
                            style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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

  getTxType(String type) {
    if (BoxApp.language == "cn") {
      switch (type) {
        case "SpendTx":
          return "转账";
        case "Swap":
          return "兑换";
        case "AEX9 SpendTx":
          return "积分转账";
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
      return type;
    }
    return type;
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
