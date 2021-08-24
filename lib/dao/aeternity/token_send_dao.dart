import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/msg_sign_model.dart';
import 'package:box/model/aeternity/aens_register_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/token_send_model.dart';
import 'package:dio/dio.dart';

class TokenSendDao {
  static Future<MsgSignModel> fetch(String amount, String senderID,String recipientID) async {
    Map<String, String> params = new Map();
    params['amount'] = amount;
    params['senderID'] = senderID;
    params['recipientID'] = recipientID;
    params['data'] = "Box aepp";
    Response response = await Dio().post(WALLET_TRANSFER, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      MsgSignModel model = MsgSignModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TokenSendModel.json');
    }
  }
}
