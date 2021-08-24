import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class NodeTestDao {
  static Future<bool> fetch(String nodeUrl, String compilerUrl) async {
    Response responseNode = await Dio().get(nodeUrl + "/v2/blocks/top");
    if (responseNode.statusCode != 200) {
      return false;
    }

    Response responseCompiler = await Dio().get(compilerUrl + "/version");
    if (responseCompiler.statusCode != 200) {
      return false;
    }
    return true;
  }

}
