import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/base_data_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:dio/dio.dart';

class PriceDao {
  static Future<PriceModel> fetch(String ids, String type) async {
    Response response = await Dio().get(Host.PRICE + "?ids=" + ids + "&type=" + type);
    print(Host.PRICE + "?ids=" + ids + "&vs_currencies=" + type);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      PriceModel model = PriceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load PriceModel.json');
    }
  }
}
