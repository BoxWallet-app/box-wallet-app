import 'dart:convert';

import 'package:box/model/wallet_coins_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletCoinsManager {
  WalletCoinsManager._privateConstructor();

  static final WalletCoinsManager instance =
      WalletCoinsManager._privateConstructor();

  Future<WalletCoinsModel> getCoins() async {
    var prefs = await SharedPreferences.getInstance();
    var walletCoinsJson = prefs.getString('wallet_coins');
    var data = jsonDecode(walletCoinsJson.toString());
    WalletCoinsModel model;
    if (data == null) {
      model = new WalletCoinsModel();
    } else {
      model = WalletCoinsModel.fromJson(data);
    }

    if (model.ae.length == 0) {
      var signingKey = prefs.getString('signingKey');
      var address = prefs.getString('address');
      var mnemonic = prefs.getString('mnemonic');
      Account account = Account();
      account.signingKey = signingKey;
      account.address = address;
      account.mnemonic = mnemonic;
      account.isSelect = true;
      model.ae.add(account);
      setCoins(model);
      return getCoins();
    }
    return model;
  }

  Future<bool> setCoins(WalletCoinsModel model) async {
    var prefs = await SharedPreferences.getInstance();
    print(jsonEncode(model));
    return prefs.setString('wallet_coins', jsonEncode(model));
  }

  Future<Account> getCurrentAccount() async {
    WalletCoinsModel coins = await getCoins();
    for (var i = 0; i < coins.ae.length; i++) {
      print(coins.ae[i].address);
      if (coins.ae[i].isSelect) {
        return coins.ae[i];
      }
    }
    return null;
  }

  Future<String> getCurrentCoin() async {
    WalletCoinsModel coins = await getCoins();
    for (var i = 0; i < coins.ae.length; i++) {
      if (coins.ae[i].isSelect) {
        return "ae";
      }
    }
    return "";
  }
}
