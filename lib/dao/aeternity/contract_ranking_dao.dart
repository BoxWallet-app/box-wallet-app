import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/contract_ranking_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class ContractRankingDao {
  static Future<RankingModel> fetch() async {
    Map<String, String> params = new Map();
    params['ct_id'] = BoxApp.ABC_CONTRACT_AEX9;
    Response response = await Dio().post(Host.CONTRACT_RANKING,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      RankingModel model = RankingModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load RankingModel.json');
    }
  }
}
