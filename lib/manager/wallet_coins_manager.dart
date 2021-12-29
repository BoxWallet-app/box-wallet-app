import 'dart:convert';

import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../main.dart';

class WalletCoinsManager {
  WalletCoinsManager._privateConstructor();

  static final WalletCoinsManager instance = WalletCoinsManager._privateConstructor();

  Future<bool> init() async {
    var prefs = await SharedPreferences.getInstance();
    var walletCoinsJson = prefs.getString('wallet_coins');
    final key = Utils.generateMd5Int(LOCAL_KEY);
    walletCoinsJson = Utils.aesDecode(walletCoinsJson, key);
    WalletCoinsModel model;
    if (walletCoinsJson == null || walletCoinsJson == "") {
      model = new WalletCoinsModel();
    } else {
      var data = jsonDecode(walletCoinsJson.toString());
      model = WalletCoinsModel.fromJson(data);
    }

    if (model.coins == null) {
      model.coins = [];
      var signingKey = prefs.getString('signingKey');
      var address = prefs.getString('address');
      var mnemonic = prefs.getString('mnemonic');
      if (address != null && address != "") {
        Account account = Account();
        account.address = address;
        account.isSelect = true;
        account.coin = "AE";

        Coin coin = new Coin();
        coin.fullName = "Aeternity";
        coin.name = "AE";

        coin.accounts = [];
        coin.accounts.add(account);

        model.coins.add(coin);
        await setCoins(model);

        var isSaveMnemonic = false;
        if (mnemonic == null || mnemonic == "") {
          isSaveMnemonic = false;
        } else {
          isSaveMnemonic = true;
        }

        await setMnemonicAndSigningKey(address, mnemonic, signingKey, isSaveMnemonic);
      }
    }
    return true;
  }

  setMnemonicAndSigningKey(String address, String mnemonic, String signingKey, bool isSaveMnemonic) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(Utils.generateMD5(address + "mnemonic"), mnemonic);
    prefs.setString(Utils.generateMD5(address + "signingKey"), signingKey);
    prefs.setBool(Utils.generateMD5(address + "isSaveMnemonic"), isSaveMnemonic);
  }

  setAddressPassword(String address, String addressPassword) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(Utils.generateMD5(address + "addressPassword"), addressPassword);
  }

  Future<bool> validationAddressPassword(String password) async {
    var address = await BoxApp.getAddress();
    var prefs = await SharedPreferences.getInstance();
    var addressPassword = prefs.getString(Utils.generateMD5(address + "addressPassword"));
    final key = Utils.generateMd5Int(password + address);
    var aesDecode = Utils.aesDecode(addressPassword, key);
    if (aesDecode == "") {
      return false;
    }
    return true;
  }

  Future<WalletCoinsModel> getCoins() async {
    var prefs = await SharedPreferences.getInstance();
    var walletCoinsJson = prefs.getString('wallet_coins');
    WalletCoinsModel model;
    if (walletCoinsJson == null || walletCoinsJson == "") {
      model = new WalletCoinsModel();
    } else {
      final key = Utils.generateMd5Int(LOCAL_KEY);
      walletCoinsJson = Utils.aesDecode(walletCoinsJson, key);

      var data = jsonDecode(walletCoinsJson.toString());
      model = WalletCoinsModel.fromJson(data);
    }
    return model;
  }

  Future<bool> setCoins(WalletCoinsModel model) async {
    var prefs = await SharedPreferences.getInstance();
    if (model == null) {
      return prefs.setString('wallet_coins', "");
    } else {
      final key = Utils.generateMd5Int(LOCAL_KEY);
      return prefs.setString('wallet_coins', Utils.aesEncode(jsonEncode(model), key));
    }
  }

  Future<bool> addAccount(String coinName, String fullName, String address, String mnemonic, String signingKey, int accountType, bool isSaveMnemonic) async {
    WalletCoinsModel coins = await getCoins();

    if (coins.coins == null) {
      Coin coin = new Coin();
      coin.fullName = fullName;
      coin.name = coinName;
      Account account = Account();
      account.address = address;
      account.accountType = accountType;
      account.isSelect = true;
      account.coin = coinName;
      coin.accounts = [];
      coin.accounts.add(account);
      if (coins.coins == null) {
        coins.coins = [];
      }
      coins.coins.add(coin);
      await setMnemonicAndSigningKey(address, mnemonic, signingKey, isSaveMnemonic);
    } else {
      for (var i = 0; i < coins.coins.length; i++) {
        if (coins.coins[i].accounts != null) {
          for (var j = 0; j < coins.coins[i].accounts.length; j++) {
            coins.coins[i].accounts[j].isSelect = false;
          }
        }

        if (coinName == coins.coins[i].name) {
          if (coins.coins[i].accounts == null) {
            coins.coins[i].accounts = [];
          }

          Account account = Account();
          account.address = address;
          account.accountType = accountType;
          account.isSelect = true;
          account.coin = coinName;
          coins.coins[i].accounts.add(account);
          await setMnemonicAndSigningKey(address, mnemonic, signingKey, isSaveMnemonic);
        }
      }
    }
    await changeAccount(coins, address);
    return true;
  }

  Future<bool> removeAccount(WalletCoinsModel walletCoinsModel, String address) async {
    await setCoins(walletCoinsModel);
    WalletCoinsModel coins = await getCoins();
    if(coins.coins == null || coins.coins.length == 0){
      return null;
    }
    //增加循环，因为eth系列地址私钥和助记词一样，只有本地存在eth系列地址大于1的情况下，就不清空本地私钥和助记词
    int count = 0;
    for (var i = 0; i < coins.coins.length; i++) {
      for (var j = 0; j < coins.coins[i].accounts.length; j++) {
        if (coins.coins[i].accounts[j].address == address) {
          count++;
        }
      }
    }
    if(count > 1){
      return true;
    }
    await setMnemonicAndSigningKey(address, "", "", false);
    return true;
  }

  Future<bool> changeAccount(WalletCoinsModel walletCoinsModel, String address) async {
    await setCoins(walletCoinsModel);
    var prefs = await SharedPreferences.getInstance();
    await BoxApp.setSigningKey(prefs.getString(Utils.generateMD5(address + "signingKey")));
    await BoxApp.setMnemonic(prefs.getString((Utils.generateMD5(address + "mnemonic"))));
    await BoxApp.setSaveMnemonic(prefs.getBool((Utils.generateMD5(address + "isSaveMnemonic"))));
    await BoxApp.setAddress(address);
    return true;
  }

  Future<bool> updateAccountSaveMnemonic(bool isSaveMnemonic) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Utils.generateMD5(await BoxApp.getAddress() + "isSaveMnemonic"), isSaveMnemonic);
    await BoxApp.setSaveMnemonic(prefs.getBool((Utils.generateMD5(await BoxApp.getAddress() + "isSaveMnemonic"))));
    return true;
  }

  Future<Account> getCurrentAccount() async {
    WalletCoinsModel coins = await getCoins();
    if(coins.coins == null || coins.coins.length == 0){
      return null;
    }
    for (var i = 0; i < coins.coins.length; i++) {
      for (var j = 0; j < coins.coins[i].accounts.length; j++) {
        if (coins.coins[i].accounts[j].isSelect) {
          return coins.coins[i].accounts[j];
        }
      }
    }
    return null;
  }

  Future<List<Object>> getCurrentCoin() async {
    WalletCoinsModel coins = await getCoins();
    for (var i = 0; i < coins.coins.length; i++) {
      for (var j = 0; j < coins.coins[i].accounts.length; j++) {
        if (coins.coins[i].accounts[j].isSelect) {
          return [coins.coins[i].name, i];
        }
      }
    }
    return null;
  }

  Future<WalletCoinsModel> addChain(String coinName, String fullName) async {
    WalletCoinsModel walletCoinsModel = await getCoins();

    if (walletCoinsModel.coins == null) {
      walletCoinsModel.coins = [];
    }

    for (var i = 0; i < walletCoinsModel.coins.length; i++) {
      if (walletCoinsModel.coins[i].name == coinName) {
        return null;
      }
    }

    if (walletCoinsModel.coins != null) {
      Coin coin = new Coin();
      coin.fullName = fullName;
      coin.name = coinName;

      coin.accounts = [];
      walletCoinsModel.coins.add(coin);
    }
    await setCoins(walletCoinsModel);
    return walletCoinsModel;
  }

  //获取可用的公链
  List<ChainsModel> getChains() {
    List<ChainsModel> chains = [];

    ChainsModel ae = ChainsModel();
    ae.name = "AE";
    ae.nameFull = "Aeternity";
    ae.nameFullCN = "阿姨链";
    chains.add(ae);

    ChainsModel eth = ChainsModel();
    eth.name = "ETH";
    eth.nameFull = "Ethereum";
    eth.nameFullCN = "以太坊";
    chains.add(eth);

    ChainsModel bnb = ChainsModel();
    bnb.name = "BNB";
    bnb.nameFull = "Binance Smart Chain";
    bnb.nameFullCN = "币安智能链";
    chains.add(bnb);

    ChainsModel okt = ChainsModel();
    okt.name = "OKT";
    okt.nameFull = "OKExChain";
    okt.nameFullCN = "OK生态链";
    chains.add(okt);

    ChainsModel ht = ChainsModel();
    ht.name = "HT";
    ht.nameFull = "HECO Chain";
    ht.nameFullCN = "火币生态链";
    chains.add(ht);

    ChainsModel cfx = ChainsModel();
    cfx.name = "CFX";
    cfx.nameFull = "Conflux";
    cfx.nameFullCN = "树图链";
    chains.add(cfx);

    // ChainsModel eth = ChainsModel();
    // eth.name = "ETH";
    // eth.nameFull = "Ethereum";
    // chains.add(eth);
    return chains;
  }
}
