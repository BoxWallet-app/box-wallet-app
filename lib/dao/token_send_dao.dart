import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/token_send_model.dart';
import 'package:dio/dio.dart';

class TokenSendDao {
  static Future<TokenSendModel> fetch(String amount, String address) async {
    Map<String, String> params = new Map();
    params['amount'] = amount;
    params['address'] = address;
    params['signingKey'] = BoxApp.getSigningKey();
    Response response = await Dio().post(WALLET_TRANSFER, queryParameters: params);
    print(response.toString());
    print("\n" + jsonEncode(params) + "\n" + response.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      print(data);
      TokenSendModel model = TokenSendModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TokenSendModel.json');
    }
  }
}
