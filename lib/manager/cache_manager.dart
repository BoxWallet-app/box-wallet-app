import 'dart:convert';

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

  Future<bool> setTokenBalance(String address,tokenAddress, String coin, String value) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('token_balance_' + address + "_"+tokenAddress+"_" + coin, value);
  }

  Future<String> getTokenBalance(String address, String tokenAddress,String coin) async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('token_balance_' + address + "_"+tokenAddress+"_" + coin);
    if (data == null || data == "") return "";
    return data;
  }

  Future<bool> setEthRecord(String address, String coin,  EthTransferModel ethTransferModel) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('eth_record_' + address +"_" + coin, jsonEncode(ethTransferModel));
  }

  Future<EthTransferModel> getEthRecord(String address,String coin) async {
    try{
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('eth_record_' + address +"_" + coin);
      var json = jsonDecode(data);
      print(json);
      EthTransferModel model = EthTransferModel.fromJson(jsonDecode(data));
      return model;
    }catch(e){
      return null;
    }
  }
  Future<bool> setAERecord(String address, String coin,  EthTransferModel ethTransferModel) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('ae_record_' + address +"_" + coin, jsonEncode(ethTransferModel));
  }

  Future<EthTransferModel> getAERecord(String address,String coin) async {
    try{
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('ae_record_' + address +"_" + coin);
      var json = jsonDecode(data);
      print(json);
      EthTransferModel model = EthTransferModel.fromJson(jsonDecode(data));
      return model;
    }catch(e){
      return null;
    }
  }
}
