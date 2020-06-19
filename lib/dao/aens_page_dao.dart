import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aens_page_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:http/http.dart' as http;

enum AensPageType { auction, price, over, my_auction, my_over }

class AensPageDao {
  static Future<AensPageModel> fetch(AensPageType aensPageType) async {
    var url = "";
    switch(aensPageType){
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
        break;
      case AensPageType.my_over:
        break;
    }
    final response = await http.post(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      AensPageModel model = AensPageModel.fromJson(result);
      return model;
    } else {
      throw Exception('Failed to load AensPageModel.json');
    }
  }
}
