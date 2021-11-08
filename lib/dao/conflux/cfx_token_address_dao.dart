import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxTokenAddressDao {
  static Future<TokensData> fetch(String address) async {
    Map<String, String> params = new Map();
    params["address"] = address;
    Response response = await Dio().post(CFX_TOKENS_ADDRESS, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      print(response.toString());
      TokensData model = TokensData.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TokensData.json');
    }
  }
}

