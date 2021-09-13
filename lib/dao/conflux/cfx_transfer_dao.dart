import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxTransferDao {
  static Future<CfxTransfer> fetch(String page, ctAddress) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["page"] = page;
    if(ctAddress != ""){
      params["ct_address"] = ctAddress;
    }

    Response response = await Dio().post(CFX_TRANSACTION, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      // print(response.toString());
      CfxTransfer model = CfxTransfer.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxTransfer.json');
    }
  }
}
