import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/base_data_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:dio/dio.dart';

class PriceDao {
  static Future<PriceModel> fetch(String type) async {
    Map<String, String> params = new Map();

    Response response = await Dio().get(PRICE+"?ids=aeternity&vs_currencies="+type);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      PriceModel model = PriceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load PriceModel.json');
    }
  }
}

