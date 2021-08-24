import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/WetrueListModel.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:box/model/aeternity/swap_order_model.dart';
import 'package:dio/dio.dart';

class WeTrueListDao {
  static Future<WetrueListModel> fetch(int type, int page) async {
    String url = "";
    switch (type) {
      case 0:
//        url = "https://liushao.cc:1817/Content/list";
        url = WE_TRUE_URL+"/Content/list";
        break;
      case 1:
        url = WE_TRUE_URL+"/Content/hotRec";
        break;
      case 2:
        url = WE_TRUE_URL+"/Image/list";
        break;
    }
    FormData formData = FormData.fromMap({
      "page": page,
      "size": 30,
    });  var address = await BoxApp.getAddress();
    ///创建 dio
    Options options = Options();
    ///请求header的配置
    options.headers["ak-token"]=address;

    Response response = await Dio().post(url, data: formData,options: options);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      WetrueListModel model = WetrueListModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load WetrueListModel.json');
    }
  }
}
