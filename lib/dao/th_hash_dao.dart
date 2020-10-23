import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_call_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/contract_record_model.dart';
import 'package:box/model/th_hash_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ThHashDao {
  static Future<ThHashModel> fetch(String th) async {
    Map<String, String> params = new Map();
    params["th"] = th;
    Response response = await Dio().post(TH_HASH, queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());

      ThHashModel model = ThHashModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ThHashModel.json');
    }
  }
}
