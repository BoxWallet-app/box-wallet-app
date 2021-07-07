class WalletCoinsModel {
  List<Account> ae =  new List<Account>();
  List<Account> btc =  new List<Account>();
  List<Account> eth =  new List<Account>();
  List<Account> btm =  new List<Account>();

  WalletCoinsModel();

  WalletCoinsModel.fromJson(Map<String, dynamic> json) {
    ae = new List<Account>();
    btc = new List<Account>();
    eth = new List<Account>();
    if (json['ae'] != null) {
      json['ae'].forEach((v) {
        ae.add(new Account.fromJson(v));
      });
    }
    if (json['btc'] != null) {
      json['btc'].forEach((v) {
        btc.add(new Account.fromJson(v));
      });
    }
    if (json['eth'] != null) {
      json['eth'].forEach((v) {
        eth.add(new Account.fromJson(v));
      });
    }
    if (json['btm'] != null) {
      json['btm'].forEach((v) {
        btm.add(new Account.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ae != null) {
      data['ae'] = this.ae.map((v) => v.toJson()).toList();
    }
    if (this.btc != null) {
      data['btc'] = this.btc.map((v) => v.toJson()).toList();
    }
    if (this.eth != null) {
      data['eth'] = this.eth.map((v) => v.toJson()).toList();
    }
    if (this.btm != null) {
      data['btm'] = this.btm.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Account {
  String address;
  String mnemonic;
  String signingKey;
  bool isSelect;

  Account({this.address, this.mnemonic, this.signingKey, this.isSelect});

  Account.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    mnemonic = json['mnemonic'];
    signingKey = json['signingKey'];
    isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['mnemonic'] = this.mnemonic;
    data['signingKey'] = this.signingKey;
    data['isSelect'] = this.isSelect;
    return data;
  }
}
