import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/model/conflux/cfx_nft_token_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxNftTokenDao {
  static Future<CfxNftTokenModel> fetch(String? contract) async {
    Map<String, String?> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    params["contract"] = contract;
    Response response = await Dio().post(Host.CFX_NFT_TOKEN,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      CfxNftTokenModel model = CfxNftTokenModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxNftTokenModel.json');
    }
  }
}
