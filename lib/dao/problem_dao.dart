import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/problem_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ProblemDao {
  static Future<ProblemModel> fetch(String type) async {
    Map<String, String> params = new Map();
    params['type'] = type;
    Response response = await Dio().post(GET_PROBLEM,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      ProblemModel model = ProblemModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ProblemModel.json');
    }
  }
}
