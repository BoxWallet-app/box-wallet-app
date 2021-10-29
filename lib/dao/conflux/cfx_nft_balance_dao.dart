import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class CfxNftBalanceDao {
  static Future<CfxNftBalanceModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    address = "cfx:aat43r14sv2sb3wy1mz58w0k0r3m1xtseas22zv9ew";
    params["address"] = address;
    Response response = await Dio().post(CFX_NFT_BALANCE,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      print(response.toString());
      CfxNftBalanceModel model = CfxNftBalanceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxBalanceModel.json');
    }
  }
}
