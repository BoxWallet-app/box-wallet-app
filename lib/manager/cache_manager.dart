import 'dart:convert';

import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_record_model.dart';
import 'package:box/model/conflux/cfx_transfer_model.dart';
import 'package:box/model/ethereum/eth_transfer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  CacheManager._privateConstructor();

  static final CacheManager instance = CacheManager._privateConstructor();

  Future<bool> setBalance(String address, String coin, String value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('balance_' + address + "_" + coin, value);
  }

  Future<String> getBalance(String address, String coin) async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('balance_' + address + "_" + coin);
    if (data == null || data == "") return "";
    return data;
  }

  Future<bool> setTokenBalance(String address, tokenAddress, String coin, String value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('token_balance_' + address + "_" + tokenAddress + "_" + coin, value);
  }

  Future<String> getTokenBalance(String address, String tokenAddress, String coin) async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('token_balance_' + address + "_" + tokenAddress + "_" + coin);
    if (data == null || data == "") return "";
    return data;
  }

  Future<bool> setAeHomeFunction(String key,String value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('ae_home_function', value);
  }

  Future<String> getAeHomeFunction() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('ae_home_function');
    if (data == null || data == "") return "{\"data\":[{\"en_name\":\"Base Function\",\"cn_name\":\"基础功能\",\"info\":[{\"en_name\":\"Spend\",\"cn_name\":\"转账\",\"icon\":\"https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/icon/spend.png\",\"event\":\"Spend\"},{\"en_name\":\"Receive\",\"cn_name\":\"收款\",\"icon\":\"https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/icon/receive.png\",\"event\":\"Receive\"},{\"en_name\":\"AENS\",\"cn_name\":\"域名\",\"icon\":\"https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/icon/aens.png\",\"event\":\"Aens\"},{\"en_name\":\"Tokens\",\"cn_name\":\"积分\",\"icon\":\"https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/icon/token.png\",\"event\":\"Tokens\"},{\"en_name\":\"Record\",\"cn_name\":\"交易记录\",\"icon\":\"https://oss-box-files.oss-cn-hangzhou.aliyuncs"
        ".com/icon/record.png\",\"event\":\"Record\"}]},{\"en_name\":\"Other Product\",\"cn_name\":\"更多产品\",\"info\":[{\"en_name\":\"AeKnow\",\"cn_name\":\"浏览器\",\"icon\":\"https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/icon/aeknow.png\",\"event\":\"AeKnow\"}]}]}";
    return data;
  }

  Future<bool> setConfig(String value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('config', value);
  }

  Future<String> getConfig() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('config');
    if (data == null || data == "") {
     return "{\"theme_color\":\"0x00000000\",\"ios_hint_auth\":\"0\"}";
    }
    return data;
  }

  Future<bool> setEthRecord(String address, String coin, EthTransferModel? ethTransferModel) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('eth_record_' + address + "_" + coin, jsonEncode(ethTransferModel));
  }

  Future<EthTransferModel?> getEthRecord(String address, String coin) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('eth_record_' + address + "_" + coin)!;
      var json = jsonDecode(data);
      EthTransferModel model = EthTransferModel.fromJson(jsonDecode(data));
      return model;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setAEHeight(int value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setInt('ae_height', value);
  }

  Future<int> getAEHeight() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt('ae_height');
    if (data == null || data == 0) return 0;
    return data;
  }

  Future<bool> setAERecord(String address, String coin, WalletTransferRecordModel? walletTransferRecordModel) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('ae_record_' + address + "_" + coin, jsonEncode(walletTransferRecordModel));
  }

  Future<WalletTransferRecordModel?> getAERecord(String address, String coin) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('ae_record_' + address + "_" + coin)!;
      var json = jsonDecode(data);
      WalletTransferRecordModel model = WalletTransferRecordModel.fromJson(jsonDecode(data));
      return model;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setCFXRecord(String address, String coin, CfxTransfer? cfxTransfer) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('cfx_record_' + address + "_" + coin, jsonEncode(cfxTransfer));
  }

  Future<CfxTransfer?> getCFXRecord(String address, String coin) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('cfx_record_' + address + "_" + coin)!;
      var json = jsonDecode(data);
      CfxTransfer model = CfxTransfer.fromJson(jsonDecode(data));
      return model;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setAETokenList(String address, String coin, TokenListModel? tokenListModel) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('ae_token_list_' + address + "_" + coin, jsonEncode(tokenListModel));
  }

  Future<TokenListModel?> getAETokenList(String address, String coin) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('ae_token_list_' + address + "_" + coin)!;
      var json = jsonDecode(data);
      TokenListModel model = TokenListModel.fromJson(jsonDecode(data));
      return model;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setFirstTokenListLoad(String address, String coin, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setBool('token_list_first' + address + "_" + coin, value);
  }

  Future<bool> getFirstTokenListLoad(String address, String coin) async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool('token_list_first' + address + "_" + coin);
    if (data == null) return false;
    return data;
  }

}
