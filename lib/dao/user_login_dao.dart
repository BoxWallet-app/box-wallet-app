import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/user_model.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class UserLoginDao {
  static Future<UserModel> fetch(String mnemonic) async {
    Map<String, String> params = new Map();

    params["mnemonic"] = mnemonic;
    Response response = await Dio().post(USER_LOGIN, queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load UserLoginDao');
    }
  }
}
