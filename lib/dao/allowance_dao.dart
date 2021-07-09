import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/allowance_model.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/token_send_model.dart';
import 'package:box/model/tx_broadcast_model.dart';
import 'package:dio/dio.dart';

class AllowanceDao {
  static Future<AllowanceModel> fetch(String ctId) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params['ct_id'] = ctId;
    Response response = await Dio().post(AEX9_ALLOWANCE, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      AllowanceModel model = AllowanceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load AllowanceModel.json');
    }
  }
}
