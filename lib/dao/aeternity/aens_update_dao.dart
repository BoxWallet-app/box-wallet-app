import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_register_model.dart';
import 'package:box/model/aeternity/aens_update_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/msg_sign_model.dart';
import 'package:dio/dio.dart';

class AensUpdaterDao {
  static Future<MsgSignModel> fetch(String name, String address) async {
    Map<String, String> params = new Map();
    params['name'] = name;
    params['address'] = address;
    Response response = await Dio().post(Host.NAME_UPDATE, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      MsgSignModel model = MsgSignModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load MsgSignModel.json');
    }
  }
}
