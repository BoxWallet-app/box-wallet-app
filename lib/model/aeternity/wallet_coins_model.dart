class WalletCoinsModel {
  List<Coin> coins;

  WalletCoinsModel({this.coins});

  WalletCoinsModel.fromJson(Map<String, dynamic> json) {
    if (json['coins'] != null) {
      coins = new List<Coin>();
      json['coins'].forEach((v) {
        coins.add(new Coin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coins != null) {
      data['coins'] = this.coins.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coin {
  String name;
  String fullName;
  List<Account> accounts;

  Coin({this.name, this.fullName, this.accounts});

  Coin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fullName = json['full_name'];
    if (json['accounts'] != null) {
      accounts = new List<Account>();
      json['accounts'].forEach((v) {
        accounts.add(new Account.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['full_name'] = this.fullName;
    if (this.accounts != null) {
      data['accounts'] = this.accounts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Account {
  String address;
  String name;
  bool isSelect;
  String coin;

  Account({this.address, this.isSelect});

  Account.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    isSelect = json['isSelect'];
    coin = json['coin'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['isSelect'] = this.isSelect;
    data['coin'] = this.coin;
    data['name'] = this.name;
    return data;
  }
}