import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_decode_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/contract_record_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ContractDecodeDao {
  static Future<ContractDecodeModel> fetch(String hash, String function) async {
    Map<String, String> params = new Map();
    params["hash"] = hash;
    params["function"] = function;
    Response response = await Dio().post(CONTRACT_DECODE,queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      ContractDecodeModel model = ContractDecodeModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractDecodeModel.json');
    }
  }
}
