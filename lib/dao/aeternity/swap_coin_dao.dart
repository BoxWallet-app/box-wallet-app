import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/swap_coin_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class SwapCoinDao {
  static Future<SwapCoinModel> fetch() async {
    Map<String, String> params = new Map();
    Response response = await Dio().post(Host.SWAP_COIN_LIST,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      SwapCoinModel model = SwapCoinModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load SwapCoinModel.json');
    }
  }
}
