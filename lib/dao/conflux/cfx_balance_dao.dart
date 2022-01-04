import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxBalanceDao {
  static Future<CfxBalanceModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    Response response = await Dio().post(Host.CFX_BALANCE,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      CfxBalanceModel model = CfxBalanceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxBalanceModel.json');
    }
  }
}
