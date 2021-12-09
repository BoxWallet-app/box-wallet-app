import 'dart:convert';

import 'package:box/config.dart';
import 'package:box/dao/ethereum/eth_token_price_rate_dao.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/ethereum/eth_token_price_rate_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EthManager {
  EthManager._privateConstructor();

  static final EthManager instance = EthManager._privateConstructor();

  Future<String> getNodeUrl(Account account) async {
    if (account.coin == "OKT") {
      return "https://okchain.mytokenpocket.vip/";
      // return "https://exchainrpc.okex.org/";
    }
    if (account.coin == "BNB") {
      return "https://bsc.mytokenpocket.vip";
      // return "https://bsc-dataseed4.ninicoin.io/";
    }
    if (account.coin == "HT") {
      return "https://heco.mytokenpocket.vip";
      // return "https://http-mainnet.hecochain.com/";
    }
    if (account.coin == "ETH") {
      return "https://web3.mytokenpocket.vip";
      // return "https://http-mainnet.hecochain.com/";
    }
    return "";
  }
  Future<String> getScanUrl(Account account) async {
    if (account.coin == "OKT") {
      return "https://www.oklink.com/zh-cn/oec/tx/";
    }
    if (account.coin == "BNB") {
      return "https://www.bscscan.com/tx/";
    }
    if (account.coin == "HT") {
      return "https://hecoinfo.com/tx/";
    }
    if (account.coin == "ETH") {
      return "https://etherscan.io/tx/";
    }
    return "";
  }

  // eth =1 bsc=12 hero=15 ok=20
  String getChainID(Account account) {
    if (account.coin == "OKT") {
      return "20";
    }
    if (account.coin == "BNB") {
      return "12";
    }
    if (account.coin == "HT") {
      return "15";
    }
    if (account.coin == "ETH") {
      return "1";
    }
    return "1";
  }

  String getCoinName(String name, String symbol) {
    name = name.replaceAll(" ", "");
    if (name.length < symbol.length) {
      name = name;
    } else {
      name = symbol;
    }
    if (name.length > 10) {
      name = name.substring(0, 5) + "..." + name.substring(name.length - 4, name.length);
    }
    if (name == "") {
      name = symbol;
    }
    return name;
  }

  EthTokenPriceRateModel ethTokenPriceRateModel;

  Future<String> getRateFormat(String price, String balance) async {
    if (ethTokenPriceRateModel == null) {
      ethTokenPriceRateModel = await EthTokenRateDao.fetch();
      return formatPrice(price, balance);
    }
    return formatPrice(price, balance);
  }

  String formatPrice(String price, String balance) {
     if (BoxApp.language == "cn") {
      return "¥" +Utils.formatBalanceLength (double.parse(price) * double.parse(balance) * double.parse(ethTokenPriceRateModel.data[0].data[0].rate));
    } else {
      return "\$" + Utils.formatBalanceLength (double.parse(price) * double.parse(balance));
    }
  }

  startRateList() {
    EthTokenRateDao.fetch().then((EthTokenPriceRateModel model) {
      ethTokenPriceRateModel = model;
      Future.delayed(Duration(seconds: 10), () {
        startRateList();
      });
    }).catchError((e) {});
  }
}
