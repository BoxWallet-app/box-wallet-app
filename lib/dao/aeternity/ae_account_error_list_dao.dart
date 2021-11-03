import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_dapp_list_model.dart';
import 'package:dio/dio.dart';


class AeAccountErrorListDao {
  static Future<String> fetch() async {
    Response response = await Dio().get(ACCOUNT_ERROR_LIST+"account_error.json");
    if (response.statusCode == 200) {
      return response.toString();
    } else {
      throw Exception('Failed to load CfxDappListModel.json');
    }
  }
}
