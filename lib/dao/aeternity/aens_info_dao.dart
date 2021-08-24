import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:dio/dio.dart';

class AensInfoDao {
  static Future<AensInfoModel> fetch(String name) async {
    Map<String, String> params = new Map();
    params['name'] = name;
    Response response = await Dio().post(NAME_INFO, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      AensInfoModel model = AensInfoModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load AensInfoModel.json');
    }
  }
}
