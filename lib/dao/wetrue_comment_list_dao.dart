import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/WetrueListModel.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/swap_model.dart';
import 'package:box/model/swap_order_model.dart';
import 'package:box/model/wetrue_comment_model.dart';
import 'package:dio/dio.dart';

class WetrueCommentDao {
  static Future<WetrueCommentModel> fetch(String hash, int page) async {
    String url = "";

    url = WE_TRUE_URL + "/Comment/list";
    FormData formData = FormData.fromMap({
      "hash": hash,
      "page": page,
      "size": 30,
      "replyLimit": 3,
    });
    var address = await BoxApp.getAddress();

    ///创建 dio
    Options options = Options();

    ///请求header的配置
    options.headers["ak-token"] = address;

    Response response = await Dio().post(url, data: formData, options: options);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      WetrueCommentModel model = WetrueCommentModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load WetrueCommentModel.json');
    }
  }
}
