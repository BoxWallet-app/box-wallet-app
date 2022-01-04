import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/user_model.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:dio/dio.dart';


class UserRegisterDao {
  static Future<UserModel> fetch() async {
    Map<String, String> params = new Map();
    Response response = await Dio().post(Host.USER_REGISTER, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load UserRegisterModel.json');
    }
  }
}
