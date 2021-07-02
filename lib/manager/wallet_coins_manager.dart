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

    WalletCoinsModel model;
    if (walletCoinsJson == null || walletCoinsJson == "") {
      model = new WalletCoinsModel();
    } else {
      var data = jsonDecode(walletCoinsJson.toString());
      model = WalletCoinsModel.fromJson(data);
    }

    if (model.ae.length == 0) {

      var signingKey = prefs.getString('signingKey');
      var address = prefs.getString('address');
      var mnemonic = prefs.getString('mnemonic');
      if(address !=null && address!=""){
        Account account = Account();
        account.signingKey = signingKey;
        account.address = address;
        account.mnemonic = mnemonic;
        account.isSelect = true;
        model.ae.add(account);
        setCoins(model);
        return getCoins();
      }

    }
    return model;
  }

  Future<bool> setCoins(WalletCoinsModel model) async {
    var prefs = await SharedPreferences.getInstance();
    if (model == null) {
      return prefs.setString('wallet_coins', "");
    } else {
      return prefs.setString('wallet_coins', jsonEncode(model));
    }
  }

  Future<Account> getCurrentAccount() async {
    WalletCoinsModel coins = await getCoins();
    for (var i = 0; i < coins.ae.length; i++) {
      if (coins.ae[i].isSelect) {
        print(coins.ae[i].address);
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
