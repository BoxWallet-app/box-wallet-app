import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/we_true_praise_model.dart';
import 'package:box/model/wetrue_config_model.dart';
import 'package:dio/dio.dart';

class WeTrueConfigDao {
  static Future<WeTrueConfigModel> fetch() async {
    String url = "";

//    FormData formData = FormData.fromMap({
//      "hash": hash,
//      "type": "topic",
//    });
    var address = await BoxApp.getAddress();
    ///创建 dio
    Options options = Options();
    ///请求header的配置
    options.headers["ak-token"]=address;
    url = WE_TRUE_URL+"/Config/info";
    Response response = await Dio().post(url,options: options);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      WeTrueConfigModel model = WeTrueConfigModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load WeTrueConfigModel.json');
    }
  }
}
