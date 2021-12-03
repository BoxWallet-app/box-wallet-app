import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/ethereum/eth_activity_coin_model.dart';
import 'package:box/model/ethereum/eth_token_top_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class EthTokenTopDao {
  static Future<EthTokenTopModel> fetch(String chainID) async {
    Map<String, String> params = new Map();
    params["blockchain_id"] = chainID;
    Response response = await Dio().post(ETH_TOKEN_HOT_LIST,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      EthTokenTopModel model = EthTokenTopModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load EthTokenTopModel.json');
    }
  }
}
