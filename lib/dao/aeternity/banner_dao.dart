import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/banner_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:dio/dio.dart';

class BannerDao {
  static Future<BannerModel> fetch() async {
    Map<String, String> params = new Map();
    Response response = await Dio().post(Host.BANNER, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      BannerModel model = BannerModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load BannerModel.json');
    }
  }
}
