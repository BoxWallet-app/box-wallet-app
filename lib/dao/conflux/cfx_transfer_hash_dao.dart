import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_transaction_hash_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxTransactionHashDao {
  static Future<CfxTransactionHashModel> fetch(String? hash) async {
    Map<String, String?> params = new Map();
    params["hash"] = hash;
    Response response = await Dio().post(Host.CFX_TRANSACTION_HASH, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      CfxTransactionHashModel model = CfxTransactionHashModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxTransactionHashModel.json');
    }
  }
}
