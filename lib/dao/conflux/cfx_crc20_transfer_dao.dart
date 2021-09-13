import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_crc20_transfer_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxCrc20TransferDao {
  static Future<CfxCrc20TransferModel> fetch(String page, ctAddress) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["page"] = page;
    if(ctAddress != ""){
      params["contract"] = ctAddress;
    }

    Response response = await Dio().post(CFX_CRC20_TRANSACTION_HASH, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      // print(response.toString());
      CfxCrc20TransferModel model = CfxCrc20TransferModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxCrc20TransferModel.json');
    }
  }
}
