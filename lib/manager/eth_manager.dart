import 'dart:convert';

import 'package:box/config.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EthManager {
  EthManager._privateConstructor();

  static final EthManager instance = EthManager._privateConstructor();

  Future<String> getNodeUrl(Account account) async {
    if(account.coin == "OKT"){
      return "https://exchainrpc.okex.org/";
    }
    if(account.coin == "BNB"){
      return "https://bsc-dataseed4.ninicoin.io/";
    }
    if(account.coin == "HT"){
      return "https://http-mainnet.hecochain.com/";
    }
    return "";
  }
  // eth =1 bsc=12 hero=15 ok=20
  String getChainID(Account account)  {
    if(account.coin == "OKT"){
      return "20";
    }
    if(account.coin == "BNB"){
      return "12";
    }
    if(account.coin == "HT"){
      return "15";
    }
    return "1";
  }
}
