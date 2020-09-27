import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/contract_record_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ContractRecordDao {
  static Future<ContractRecordModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    Response response = await Dio().post(CONTRACT_RECORD,queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      ContractRecordModel model = ContractRecordModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractRecordModel.json');
    }
  }

  static Future<ContractRecordModel> fetchCtID() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["ct_id"] = "ct_Evidt2ZUPzYYPWhestzpGsJ8uWzB1NgMpEvHHin7GCfgWLpjv";
    Response response = await Dio().post(CONTRACT_RECORD,queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      ContractRecordModel model = ContractRecordModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractRecordModel.json');
    }
  }
}
