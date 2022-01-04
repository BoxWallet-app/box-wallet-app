import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/msg_sign_model.dart';
import 'package:box/model/aeternity/aens_register_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/token_send_model.dart';
import 'package:box/model/aeternity/tx_broadcast_model.dart';
import 'package:dio/dio.dart';

class TxBroadcastDao {
  static Future<TxBroadcastModel> fetch(String signature, String tx, String type) async {
    Map<String, String> params = new Map();
    params['signature'] = signature;
    params['tx'] = tx;
    params['type'] = type;
    Response response = await Dio().post(Host.TX_BROADCAST, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      TxBroadcastModel model = TxBroadcastModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TxBroadcastModel.json');
    }
  }
}
