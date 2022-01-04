import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/contract_call_model.dart';
import 'package:box/model/aeternity/contract_info_model.dart';
import 'package:box/model/aeternity/contract_record_model.dart';
import 'package:box/model/aeternity/msg_sign_model.dart';
import 'package:dio/dio.dart';


class ContractTransferCallDao {
  static Future<MsgSignModel> fetch(String amount, String senderID,String recipientID) async {
    Map<String, String> params = new Map();
    params["senderID"] = senderID;
    params["recipientID"] = recipientID;
    params["amount"] = amount;
    Response response = await Dio().post(Host.CONTRACT_TRANSFER, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());

      MsgSignModel model = MsgSignModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractCallModel.json');
    }
  }
}
