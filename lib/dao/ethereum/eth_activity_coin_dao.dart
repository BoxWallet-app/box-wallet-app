import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/ethereum/eth_activity_coin_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class EthActivityCoinDao {
  static Future<EthActivityCoinModel> fetch(String chainID) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["blockchain_id"] = chainID;
    Response response = await Dio().post(ETH_TOKEN_LIST_ACTIVITY,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      EthActivityCoinModel model = EthActivityCoinModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load EthActivityCoinModel.json');
    }
  }
}
