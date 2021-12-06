import 'dart:convert';

import 'package:box/config.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CtTokenManager {
  CtTokenManager._privateConstructor();

  static final CtTokenManager instance = CtTokenManager._privateConstructor();

  Future<List<Tokens>> getCfxCtTokens(String address) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var ctCfxTokens = prefs.getString('ct_cfx_tokens_' + address);
      if (ctCfxTokens == null || ctCfxTokens.isEmpty) {
        var ctCfxTokensJson = "{\"tokens\": [         {             \"ct_id\": \"cfx:achaa50a7zepwgjnbez8mw9s07n1g80k7awd38jcj7\",              \"name\": \"conflux ABC\",              \"symbol\": \"cABC\",              \"quoteUrl\": null,              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aachaa50a7zepwgjnbez8mw9s07n1g80k7awd38jcj7.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:achc8nxj7r451c223m18w2dwjnmhkd6rxawrvkvsy2\",              \"name\": \"FansCoin\",              \"symbol\": \"FC\",              \"quoteUrl\": \"https://coinmarketcap.com/currencies/fanscoin\",              \"iconUrl\": \"https://ae-source.oss-cn-hongkong.aliyuncs.com/FC.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:achcuvuasx3t8zcumtwuf35y51sksewvca0h0hj71a\",              \"name\": \"conflux MOON\",              \"symbol\": \"cMOON\",              \"quoteUrl\": \"https://coinmarketcap.com/currencies/moonswap\",              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aachcuvuasx3t8zcumtwuf35y51sksewvca0h0hj71a.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:acf2rcsh8payyxpg6xj7b0ztswwh81ute60tsw35j7\",              \"name\": \"conflux USDT\",              \"symbol\": \"cUSDT\",              \"quoteUrl\": \"https://coinmarketcap.com/currencies/tether\",              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aacf2rcsh8payyxpg6xj7b0ztswwh81ute60tsw35j7.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:acav5v98np8t3m66uw7x61yer1ja1jm0dpzj1zyzxv\",              \"name\": \"Points\",              \"symbol\": \"POS\",              \"quoteUrl\": \"https://moonswap.fi/analytics/pair/cfx:acegm8eez3utdye7uz61a5xgh6v70z54ay5tas70vc\",              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aacav5v98np8t3m66uw7x61yer1ja1jm0dpzj1zyzxv.png\",              \"balance\": null,              \"price\": null         }     ] }";
        var data = jsonDecode(ctCfxTokensJson.toString());
        var model = CtTokenModel.fromJson(data);
        if (model.tokens == null) {
          return [];
        }
      }
      final key = Utils.generateMd5Int(LOCAL_KEY);
      var ctCfxTokensJson = Utils.aesDecode(ctCfxTokens, key);
      if (ctCfxTokensJson == null || ctCfxTokensJson.isEmpty) {
        ctCfxTokensJson = "{\"tokens\": [         {             \"ct_id\": \"cfx:achaa50a7zepwgjnbez8mw9s07n1g80k7awd38jcj7\",              \"name\": \"conflux ABC\",              \"symbol\": \"cABC\",              \"quoteUrl\": null,              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aachaa50a7zepwgjnbez8mw9s07n1g80k7awd38jcj7.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:achc8nxj7r451c223m18w2dwjnmhkd6rxawrvkvsy2\",              \"name\": \"FansCoin\",              \"symbol\": \"FC\",              \"quoteUrl\": \"https://coinmarketcap.com/currencies/fanscoin\",              \"iconUrl\": \"https://ae-source.oss-cn-hongkong.aliyuncs.com/FC.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:achcuvuasx3t8zcumtwuf35y51sksewvca0h0hj71a\",              \"name\": \"conflux MOON\",              \"symbol\": \"cMOON\",              \"quoteUrl\": \"https://coinmarketcap.com/currencies/moonswap\",              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aachcuvuasx3t8zcumtwuf35y51sksewvca0h0hj71a.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:acf2rcsh8payyxpg6xj7b0ztswwh81ute60tsw35j7\",              \"name\": \"conflux USDT\",              \"symbol\": \"cUSDT\",              \"quoteUrl\": \"https://coinmarketcap.com/currencies/tether\",              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aacf2rcsh8payyxpg6xj7b0ztswwh81ute60tsw35j7.png\",              \"balance\": null,              \"price\": null         },          {             \"ct_id\": \"cfx:acav5v98np8t3m66uw7x61yer1ja1jm0dpzj1zyzxv\",              \"name\": \"Points\",              \"symbol\": \"POS\",              \"quoteUrl\": \"https://moonswap.fi/analytics/pair/cfx:acegm8eez3utdye7uz61a5xgh6v70z54ay5tas70vc\",              \"iconUrl\": \"https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/cfx%3Aacav5v98np8t3m66uw7x61yer1ja1jm0dpzj1zyzxv.png\",              \"balance\": null,              \"price\": null         }     ] }";
      }
      var data = jsonDecode(ctCfxTokensJson.toString());
      var model = CtTokenModel.fromJson(data);
      if (model.tokens == null) {
        return [];
      }
      return model.tokens;
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateCfxCtTokens(String address, List<Tokens> ctTokens) async {
    CtTokenModel model = CtTokenModel();
    model.tokens = ctTokens;
    var prefs = await SharedPreferences.getInstance();
    if (ctTokens == null || ctTokens.isEmpty) {
      prefs.setString('ct_cfx_tokens_' + address, Utils.aesEncode(jsonEncode(model), Utils.generateMd5Int(LOCAL_KEY)));
      return true;
    }
    prefs.setString('ct_cfx_tokens_' + address, Utils.aesEncode(jsonEncode(model), Utils.generateMd5Int(LOCAL_KEY)));
    return true;
  }

  Future<List<Tokens>> getEthCtTokens(String chainID, String address) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      var ctCfxTokens = prefs.getString('ct_eth_tokens_'+ chainID  + address);
      if (ctCfxTokens == null || ctCfxTokens.isEmpty) {
          return [];
      }
      final key = Utils.generateMd5Int(LOCAL_KEY);
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
    } catch (e) {
      return [];
    }
  }


  Future<bool> updateETHCtTokens(String chainID,String address , List<Tokens> ctTokens) async {
    CtTokenModel model = CtTokenModel();
    model.tokens = ctTokens;
    var prefs = await SharedPreferences.getInstance();
    if (ctTokens == null || ctTokens.isEmpty) {
      await prefs.setString('ct_eth_tokens_' + chainID + address, Utils.aesEncode(jsonEncode(model), Utils.generateMd5Int(LOCAL_KEY)));
      return true;
    }
    await prefs.setString('ct_eth_tokens_' + chainID +  address, Utils.aesEncode(jsonEncode(model), Utils.generateMd5Int(LOCAL_KEY)));
    return true;
  }
}
