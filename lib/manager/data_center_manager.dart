import 'dart:async';
import 'dart:convert';

import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/aeternity/wallet_coins_model.dart';
import '../page/aeternity/ae_home_page.dart';

class DataCenterManager {
  DataCenterManager._privateConstructor();

  static final DataCenterManager instance = DataCenterManager._privateConstructor();

  static late List txsData = [];
  static late var tokenInfos = Map();

  start() {
    ///循环执行
    ///间隔1秒
    Timer.periodic(Duration(milliseconds: 5000), (timer) {
      netRecordData();
      netTokenInfos();

      ///定时任务
    });
  }

  Future<List> netRecordData() async {
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    AeHomePage.address = account!.address;
    Response responseTxs = await Dio().get("https://mainnet.aeternity.io/mdw///txs/backward?account=${AeHomePage.address}&limit=30&page=1");
    var responseDecode = jsonDecode(responseTxs.toString());
    List txsData = responseDecode['data'];
    Response responseAex9 = await Dio().get("https://mainnet.aeternity.io/mdw/v2/aex9/transfers/to/${AeHomePage.address}");
    var responseAex9Decode = jsonDecode(responseAex9.toString());
    List aex9Data = responseAex9Decode['data'];
    for (var i = 0; i < txsData.length; i++) {
      var txHash = txsData[i]["hash"];

      for (var j = 0; j < aex9Data.length; j++) {
        var aex9Hash = aex9Data[j]["tx_hash"];
        var aex9ContractId = aex9Data[j]["contract_id"];
        if (txHash == aex9Hash || aex9ContractId == 'ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3') {
          aex9Data.removeAt(j);
          j--;
        }
      }
    }
    txsData.addAll(aex9Data);
    txsData.sort((left, right) => right["micro_time"].compareTo(left["micro_time"]));
    DataCenterManager.txsData = txsData;

    return txsData;
  }

  Future<Map> netTokenInfos() async {
    Response responseTokenInfo = await Dio().get("https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/api/ae-token-info.json");
    Map tokenInfos = jsonDecode(responseTokenInfo.toString());
    DataCenterManager.tokenInfos = tokenInfos;
    return tokenInfos;
  }
}
