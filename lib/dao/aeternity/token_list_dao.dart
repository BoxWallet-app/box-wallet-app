import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:dio/dio.dart';

class TokenListDao {
  static Future<TokenListModel> fetch(String? address, String type) async {
    Map<String, String?> params = new Map();
    params['address'] = address;
    params['type'] = type;
    Response response = await Dio().get(Host.ossHost! + "/api/ae-token-list.json", queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      TokenListModel model = TokenListModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load TokenListModel.json');
    }
  }
}
