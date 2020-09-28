import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/base_data_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/version_model.dart';
import 'package:dio/dio.dart';

class VersionDao {
  static Future<VersionModel> fetch() async {
    Response response = await Dio().post(VERSION);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      VersionModel model = VersionModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load VersionModel.json');
    }
  }
}

