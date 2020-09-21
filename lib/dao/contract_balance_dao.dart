import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ContractBalanceDao {
  static Future<ContractBalanceModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    Response response = await Dio().post(CONTRACT_BALANCE,queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      ContractBalanceModel model = ContractBalanceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractBalanceModel.json');
    }
  }
}
