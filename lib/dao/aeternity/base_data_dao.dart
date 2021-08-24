import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/base_data_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:dio/dio.dart';

class BaseDataDao {
  static Future<BaseDataModel> fetch() async {
    Response response = await Dio().post(BASE_DATA);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      BaseDataModel model = BaseDataModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load BaseDataModel.json');
    }
  }
}

