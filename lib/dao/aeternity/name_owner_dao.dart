import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/name_owner_model.dart';
import 'package:dio/dio.dart';

class NameOwnerDao {
  static Future<NameOwnerModel> fetch(String name) async {
    String nodeUrl = await BoxApp.getNodeUrl();
    if ( nodeUrl == "") {
      nodeUrl = "https://mainnet.aeternity.io";
    }
    Response response = await Dio().get(nodeUrl+Host.NAME_OWNER + name);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      NameOwnerModel model = NameOwnerModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load NameOwnerModel.json');
    }
  }
}
