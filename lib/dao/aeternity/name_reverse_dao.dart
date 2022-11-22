import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/name_reverse_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:dio/dio.dart';

class NameReverseDao {
  static Future< String> fetch() async {
    var address = await BoxApp.getAddress();
    print("--------------------------");
    Response response = await Dio().get("https://raendom-backend.z52da5wt.xyz/cache/chainnames");
    if (response.statusCode == 200) {
      Map responseJson = json.decode(response.toString());
      String aens = responseJson[address];
      return aens;
    } else {
      print("======================");
      throw Exception('Failed to load NameReverseModel.json');
    }
  }
}
