import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/swap_coin_account_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class SwapCoinMyDao {
  static Future<SwapCoinAccountModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    Response response = await Dio().post(SWAP_COIN_ACCOUNT_MY, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      SwapCoinAccountModel model = SwapCoinAccountModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load SwapCoinAccountModel.json');
    }
  }
}
