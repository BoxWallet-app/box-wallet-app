import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/app_store_model.dart';
import 'package:box/model/aeternity/host_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:dio/dio.dart';

class HostDao {
  static Future<HostModel> fetch() async {
    Map<String, String> params = new Map();
    Response response = await Dio().get("https://ae-source.oss-cn-hongkong.aliyuncs.com/config/host.json", queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      HostModel model = HostModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load HostModel.json');
    }
  }
}
