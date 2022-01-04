import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/base_data_model.dart';
import 'package:box/model/aeternity/base_name_data_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:dio/dio.dart';

class BaseNameDataDao {
  static Future<BaseNameDataModel> fetch() async {
    Response response = await Dio().post(Host.BASE_NAME_DATA);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      BaseNameDataModel model = BaseNameDataModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load BaseNameDataModel.json');
    }
  }
}

