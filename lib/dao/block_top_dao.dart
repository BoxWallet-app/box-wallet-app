import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/block_top_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class BlockTopDao {
  static Future<BlockTopModel> fetch() async {
    Response response = await Dio().post(BLOCK_TOP);
    if (response.statusCode != 200) {
      var data = jsonDecode(response.toString());
      BlockTopModel model = BlockTopModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load BlockTopModel.json');
    }
  }
}
