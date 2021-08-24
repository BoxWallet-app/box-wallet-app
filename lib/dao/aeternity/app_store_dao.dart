import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/app_store_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:dio/dio.dart';

class AppStoreDao {
  static Future<AppStoreModel> fetch() async {
    Map<String, String> params = new Map();
    Response response = await Dio().post(APP_STORE, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      AppStoreModel model = AppStoreModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load AppStoreModel.json');
    }
  }
}
