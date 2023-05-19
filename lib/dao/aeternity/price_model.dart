import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:dio/dio.dart';

class PriceDao {
  static Future<PriceModel> fetch() async {
    print(Host.PRICE);
    Response response = await Dio().get(Host.PRICE);
    print(Host.PRICE);
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
