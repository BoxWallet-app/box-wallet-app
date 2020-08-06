class BaseDataModel {
  int code;
  String msg;
  int time;
  Data data;

  BaseDataModel({this.code, this.msg, this.time, this.data});

  BaseDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String priceUsdt;
  String priceBtc;
  String blockHeight;
  String totalTransactions;
  String maxTps;
  String marketCap;
  String totalCoins;
  String aensTotal;
  String oraclesTotal;
  String contractsTotal;
  String accountsTotal;

  Data(
      {this.priceUsdt,
        this.priceBtc,
        this.blockHeight,
        this.totalTransactions,
        this.maxTps,
        this.marketCap,
        this.totalCoins,
        this.aensTotal,
        this.oraclesTotal,
        this.contractsTotal,
        this.accountsTotal});

  Data.fromJson(Map<String, dynamic> json) {
    priceUsdt = json['price_usdt'];
    priceBtc = json['price_btc'];
    blockHeight = json['block_height'];
    totalTransactions = json['total_transactions'];
    maxTps = json['max_tps'];
    marketCap = json['market_cap'];
    totalCoins = json['total_coins'];
    aensTotal = json['aens_total'];
    oraclesTotal = json['oracles_total'];
    contractsTotal = json['contracts_total'];
    accountsTotal = json['accounts_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_usdt'] = this.priceUsdt;
    data['price_btc'] = this.priceBtc;
    data['block_height'] = this.blockHeight;
    data['total_transactions'] = this.totalTransactions;
    data['max_tps'] = this.maxTps;
    data['market_cap'] = this.marketCap;
    data['total_coins'] = this.totalCoins;
    data['aens_total'] = this.aensTotal;
    data['oracles_total'] = this.oraclesTotal;
    data['contracts_total'] = this.contractsTotal;
    data['accounts_total'] = this.accountsTotal;
    return data;
  }
}