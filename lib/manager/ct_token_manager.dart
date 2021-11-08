import 'dart:convert';

import 'package:box/a.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CtTokenManager {
  CtTokenManager._privateConstructor();

  static final CtTokenManager instance = CtTokenManager._privateConstructor();

  Future<List<Tokens>> getCfxCtTokens(String address) async {
    try{
      var prefs = await SharedPreferences.getInstance();
      var ctCfxTokens = prefs.getString('ct_cfx_tokens_' + address);
      if (ctCfxTokens == null || ctCfxTokens.isEmpty) {
        return [];
      }
      final key = Utils.generateMd5Int(b);
      var ctCfxTokensJson = Utils.aesDecode(ctCfxTokens, key);
      if (ctCfxTokensJson == null || ctCfxTokensJson.isEmpty) {
        return [];
      }
      var data = jsonDecode(ctCfxTokensJson.toString());
      var model = CtTokenModel.fromJson(data);
      if (model.tokens == null) {
        return [];
      }
      return model.tokens;
    }catch(e){
      return [];
    }

  }

  Future<bool> updateCfxCtTokens(String address, List<Tokens> ctTokens) async {
    CtTokenModel model = CtTokenModel();
    model.tokens = ctTokens;
    var prefs = await SharedPreferences.getInstance();
    if (ctTokens == null || ctTokens.isEmpty) {
      prefs.setString('ct_cfx_tokens_' + address, null);
      return true;
    }
    prefs.setString('ct_cfx_tokens_' + address, Utils.aesEncode(jsonEncode(model), Utils.generateMd5Int(b)));
    return true;
  }
}
