import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/version_model.dart';
import 'package:dio/dio.dart';

class VersionDao {
  static Future<VersionModel> fetch() async {
    print(Host.VERSION);
    Response response = await Dio().get(Host.VERSION);
    print(response.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      VersionModel model = VersionModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load VersionModel.json');
    }
  }
}

