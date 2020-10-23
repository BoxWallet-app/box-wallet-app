import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/aens_update_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:dio/dio.dart';

class AensPreclaimDao {
  static Future<MsgSignModel> fetch(String name, String address) async {
    Map<String, String> params = new Map();
    params['name'] = name;
    params['address'] = address;
    Response response = await Dio().post(NAME_PRECLAI, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      MsgSignModel model = MsgSignModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load MsgSignModel.json');
    }
  }
}
