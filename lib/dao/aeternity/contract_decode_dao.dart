import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/contract_decode_model.dart';
import 'package:box/model/aeternity/contract_info_model.dart';
import 'package:box/model/aeternity/contract_record_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class ContractDecodeDao {
  static Future<ContractDecodeModel> fetch(String hash, String function) async {
    Map<String, String> params = new Map();
    params["hash"] = hash;
    params["function"] = function;
    Response response = await Dio().post(Host.CONTRACT_DECODE,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      ContractDecodeModel model = ContractDecodeModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractDecodeModel.json');
    }
  }

  static Future<ContractDecodeModel> fetchCbId(String hash, String function) async {
    Map<String, String> params = new Map();
    params["hash"] = hash;
    params["function"] = function;
    params["ct_id"] = "ct_Evidt2ZUPzYYPWhestzpGsJ8uWzB1NgMpEvHHin7GCfgWLpjv";
    Response response = await Dio().post(Host.CONTRACT_DECODE,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      ContractDecodeModel model = ContractDecodeModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractDecodeModel.json');
    }
  }
}
