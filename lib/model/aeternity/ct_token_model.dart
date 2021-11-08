class CtTokenModel {
  List<Tokens> tokens;

  CtTokenModel({this.tokens});

  CtTokenModel.fromJson(Map<String, dynamic> json) {
    if (json['tokens'] != null) {
      tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        tokens.add(new Tokens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tokens != null) {
      data['tokens'] = this.tokens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tokens {
  String ctId;
  String name;
  String symbol;
  String quoteUrl;
  String iconUrl;
  String balance;
  String price;

  Tokens({this.ctId, this.name, this.symbol, this.quoteUrl});

  Tokens.fromJson(Map<String, dynamic> json) {
    ctId = json['ct_id'];
    name = json['name'];
    symbol = json['symbol'];
    quoteUrl = json['quoteUrl'];
    iconUrl = json['iconUrl'];
    balance = json['balance'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ct_id'] = this.ctId;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['quoteUrl'] = this.quoteUrl;
    data['iconUrl'] = this.iconUrl;
    data['balance'] = this.balance;
    data['price'] = this.price;
    return data;
  }
}
