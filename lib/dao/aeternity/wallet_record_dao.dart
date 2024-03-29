import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:dio/dio.dart';

class WalletRecordDao {
  static Future<WalletTransferRecordModel> fetch(int page) async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();

    params["address"] = address;
    params["page"] = page.toString();
    Response response = await Dio().post(Host.WALLET_RECORD, queryParameters: params);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      WalletTransferRecordModel model = WalletTransferRecordModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load WalletTransferRecordModel.json');
    }
  }
}
