import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/ethereum/eth_activity_coin_model.dart';
import 'package:box/model/ethereum/eth_token_price_model.dart';
import 'package:box/model/ethereum/eth_token_price_request_model.dart';
import 'package:box/model/ethereum/eth_token_search_model.dart';
import 'package:box/model/ethereum/eth_token_top_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class EthTokenPriceDao {
  static Future<EthTokenPriceModel> fetch(EthTokenPriceRequestModel requestModel) async {
    Response response = await Dio().post(ETH_TOKEN_PRICE,data: requestModel);
    print(response.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      EthTokenPriceModel model = EthTokenPriceModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load EthTokenTopModel.json');
    }
  }

}
