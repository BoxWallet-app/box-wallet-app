import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/token_record_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';


class TokenRecordDao {
  static Future<TokenRecordModel> fetch(String? ctId, String page) async {
    Map<String, String?> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["ct_id"] = ctId;
    params["page"] = page;
    Response response = await Dio().post(Host.AEX9_RECORD, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      TokenRecordModel model = TokenRecordModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TokenRecordModel.json');
    }
  }
}
