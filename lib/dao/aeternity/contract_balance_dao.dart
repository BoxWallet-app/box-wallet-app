import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class ContractBalanceDao {
  static Future<ContractBalanceModel> fetch(String ctId) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["ct_id"] = ctId;
    Response response = await Dio().post(Host.CONTRACT_BALANCE,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      ContractBalanceModel model = ContractBalanceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractBalanceModel.json');
    }
  }
}
