import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/problem_model.dart';
import 'package:box/model/problem_model_info.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ProblemInfoDao {
  static Future<ProblemInfoModel> fetch(int id) async {
    Map<String, String> params = new Map();
    params['id'] = id.toString();
    Response response = await Dio().post(GET_PROBLEM_INFO,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      ProblemInfoModel model = ProblemInfoModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ProblemInfoModel.json');
    }
  }
}
