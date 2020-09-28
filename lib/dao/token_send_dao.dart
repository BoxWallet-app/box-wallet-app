import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/token_send_model.dart';
import 'package:dio/dio.dart';

class TokenSendDao {
  static Future<TokenSendModel> fetch(String amount, String address,String signingKey) async {
    Map<String, String> params = new Map();
    params['amount'] = amount;
    params['address'] = address;
    params['signingKey'] = signingKey;
//    params['data'] = "AEX9#ABC-TEST-TOKEN#ABC-TEST#18#ct_hM2PJEB66Sqx2mkyCixbh3z9hLMaK8N1Sa8v5kaWRqXwPYgkQ";
    params['data'] = "Box aepp";
    Response response = await Dio().post(WALLET_TRANSFER, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      TokenSendModel model = TokenSendModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TokenSendModel.json');
    }
  }
}
