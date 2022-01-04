import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/user_model.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class UserLoginDao {
  static Future<UserModel> fetch(String mnemonic) async {
    Map<String, String> params = new Map();
    params["mnemonic"] = mnemonic;
    Response response = await Dio().post(Host.USER_LOGIN, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load UserLoginDao');
    }
  }
}
