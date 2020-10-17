import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_ranking_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ContractRankingDao {
  static Future<RankingModel> fetch() async {
    Map<String, String> params = new Map();
    Response response = await Dio().post(CONTRACT_RANKING,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      RankingModel model = RankingModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load RankingModel.json');
    }
  }
}
