import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/we_true_praise_model.dart';
import 'package:dio/dio.dart';

class WeTrueTopicDao {
  static Future<bool> fetch(String hash) async {
    String url = "";

    FormData formData = FormData.fromMap({
      "hash": hash,
    });  var address = await BoxApp.getAddress();
    ///创建 dio
    Options options = Options();
    ///请求header的配置
    options.headers["ak-token"]=address;
//    url = "https://liushao.cc:1817/Submit/hash";
    url = "https://api.wetrue.io/Submit/hash";
    Response response = await Dio().post(url, data: formData,options: options);
    print(response.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load WeTruePraiseModel.json');
    }
  }
}
