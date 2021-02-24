import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/name_owner_model.dart';
import 'package:dio/dio.dart';

class NameOwnerDao {
  static Future<NameOwnerModel> fetch(String name) async {
    String nodeUrl = await BoxApp.getNodeUrl();
    if (nodeUrl.isEmpty) {
      nodeUrl = "https://node.aeasy.io";
    }
    Response response = await Dio().get(nodeUrl+NAME_OWNER + name);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      NameOwnerModel model = NameOwnerModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load NameOwnerModel.json');
    }
  }
}
