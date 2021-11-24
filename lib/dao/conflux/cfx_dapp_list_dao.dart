import 'dart:convert';
import 'dart:io';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_dapp_list_model.dart';
import 'package:dio/dio.dart';

class CfxDappListDao {
  static Future<CfxDappListModel> fetch(String language) async {
    String url = "";
    if (Platform.isIOS) {
      url = CFX_DAPP_LIST + "cfx_dapp_" + language + "_ios.json";
    } else {
      url = CFX_DAPP_LIST + "cfx_dapp_" + language + ".json";
    }

    Response response = await Dio().get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      CfxDappListModel model = CfxDappListModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load CfxDappListModel.json');
    }
  }
}
