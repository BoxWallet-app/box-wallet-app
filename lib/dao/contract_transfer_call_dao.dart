import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_call_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/contract_record_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ContractTransferCallDao {
  static Future<ContractCallModel> fetch( String address, String signingKey, String amount) async {
    Map<String, String> params = new Map();
    params["address"] = address;
    params["signingKey"] = signingKey;
    params["amount"] = amount;
    Response response = await Dio().post(CONTRACT_TRANSFER, queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());

      ContractCallModel model = ContractCallModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractCallModel.json');
    }
  }
}
