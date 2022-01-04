import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/ethereum/eth_activity_coin_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class EthTransferDao {
  static Future<EthTransferModel> fetch(String chainID,String ctAddress,String page) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["blockchain_id"] = chainID;
    params["contract_address"] = ctAddress;
    params["page"] = page;
    Response response = await Dio().post(Host.ETH_TRANSFER_RECORD,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      EthTransferModel model = EthTransferModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load EthTransferModel.json');
    }
  }
}
