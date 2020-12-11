import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/swap_model.dart';
import 'package:box/model/swap_order_model.dart';
import 'package:dio/dio.dart';

class SwapMySellDao {
  static Future<SwapOrderModel> fetch() async {
    Map<String, String> params = new Map();
    params['ct_id'] = BoxApp.SWAP_CONTRACT;
    params['address'] =await BoxApp.getAddress();
    Response response = await Dio().post(SWAP_MY_SELL_LIST, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      SwapOrderModel model = SwapOrderModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load SwapOrderModel.json');
    }
  }
}
