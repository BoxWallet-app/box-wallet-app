import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:dio/dio.dart';

class AensRegisterDao {
  static Future<AensRegisterModel> fetch(String name) async {
    Map<String, String> params = new Map();
    params['name'] = name;
    params['signingKey'] =await  BoxApp.getSigningKey();
    Response response = await Dio().post(NAME_ADD, queryParameters: params);
    print(response.toString());
    print("\n" + jsonEncode(params) + "\n" + response.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      print(data);
      AensRegisterModel model = AensRegisterModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load AensRegisterModel.json');
    }
  }
}
