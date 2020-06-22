import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_page_model.dart';
import 'package:dio/dio.dart';

enum AensPageType { auction, price, over, my_auction, my_over }

class AensPageDao {
  static Future<AensPageModel> fetch(AensPageType aensPageType, int page) async {
    Map<String, String> params = new Map();
    var address = BoxApp.getAddress();
    var url = "";
    switch (aensPageType) {
      case AensPageType.auction:
        url = NAME_AUCTIONS;
        break;
      case AensPageType.price:
        url = NAME_PRICE;
        break;
      case AensPageType.over:
        url = NAME_OVER;
        break;
      case AensPageType.my_auction:
        url = NAME_MY_OVER;
        params["address"] = address;
        break;
      case AensPageType.my_over:
        url = NAME_MY_REGISTER;
        params["address"] = address;
        break;
    }
    params["page"] = page.toString();
    print("\n" + url);
    Response response = await Dio().post(url, queryParameters: params);
    print(response.toString());
    print("\n" + jsonEncode(params) + "\n" + response.toString());

    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      AensPageModel model = AensPageModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load AensPageModel.json');
    }
  }
}
