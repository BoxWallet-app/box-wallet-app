import 'dart:convert';

import 'package:box/a.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebManager {
  WebManager._privateConstructor();

  static final WebManager instance = WebManager._privateConstructor();

  Future<List<String>> getUrls(String address) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var urls = prefs.getString('ct_web_dapp_' + address);
      if (urls == null || urls.isEmpty) {
        var ctCfxTokensJson = "[]";
        var data = jsonDecode(ctCfxTokensJson.toString());
        assert(data is List<String>);
        if (data.tokens == null) {
          return [];
        }
      }
      final key = Utils.generateMd5Int(b);
      var ctCfxTokensJson = Utils.aesDecode(urls, key);
      if (ctCfxTokensJson == null) {
        ctCfxTokensJson = "[]";
      }
      var data = jsonDecode(ctCfxTokensJson.toString());
      List<String> stringList = (data as List<dynamic>).cast<String>();
      if (stringList == null) {
        return [];
      }
      return stringList;
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateUrls(String address, List<String> data) async {
    var prefs = await SharedPreferences.getInstance();
    if (data == null || data.isEmpty) {
      prefs.setString('ct_web_dapp_' + address, Utils.aesEncode(jsonEncode(data), Utils.generateMd5Int(b)));
      return true;
    }
    prefs.setString('ct_web_dapp_' + address, Utils.aesEncode(jsonEncode(data), Utils.generateMd5Int(b)));
    return true;
  }
}
