import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/model/conflux/cfx_nft_preview_model.dart';
import 'package:box/model/conflux/cfx_nft_token_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxNftPreviewDao {
  static Future<CfxNftPreviewModel> fetch(String contract,String tokenId) async {
    Map<String, String> params = new Map();
    params["tokenId"] = tokenId;
    params["contract"] = contract;
    Response response = await Dio().post(Host.CFX_NFT_PREVIEW,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      CfxNftPreviewModel model = CfxNftPreviewModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxNftPreviewModel.json');
    }
  }
}
