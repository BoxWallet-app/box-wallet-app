import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/name_reverse_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:dio/dio.dart';

class NameReverseDao {
  static Future< List<NameReverseModel>> fetch() async {
    var address = await BoxApp.getAddress();
    Response response = await Dio().get(Host.NAME + address);
    if (response.statusCode == 200) {
      List responseJson = json.decode(json.encode(response.data));
      List<NameReverseModel> data = new List<NameReverseModel>();
      responseJson.forEach((v) {
        data.add(new NameReverseModel.fromJson(v));
      });
//      List<NameReverseModel> list = data.map((m) => new NameReverseModel.fromJson(m)).toList();
      return data;
    } else {
      throw Exception('Failed to load NameReverseModel.json');
    }
  }
}
