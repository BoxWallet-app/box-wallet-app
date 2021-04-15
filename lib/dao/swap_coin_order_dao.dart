import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/swap_coin_order_model.dart';
import 'package:box/model/swap_order_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class SwapCoinOrderDao {
  static Future<SwapCoinOrderModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    Response response = await Dio().post(SWAP_COIN_ORDER_MY,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      SwapCoinOrderModel model = SwapCoinOrderModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load SwapCoinOrderModel.json');
    }
  }
}
