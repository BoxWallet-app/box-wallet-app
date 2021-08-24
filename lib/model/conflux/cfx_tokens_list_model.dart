class TokensListModel {
  int total;
  List<TokenList> list;

  TokensListModel({this.total, this.list});

  TokensListModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = new List<TokenList>();
      json['list'].forEach((v) {
        list.add(new TokenList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TokenList {
  String address;
  String name;
  String symbol;
  int decimals;
  int granularity;
  String totalSupply;
  int holderCount;
  int transferCount;
  String transferType;
  String icon;
  String accountAddress;
  String balance;
  String quoteUrl;
  String price;
  String totalPrice;

  TokenList({this.address, this.name, this.symbol, this.decimals, this.granularity, this.totalSupply, this.holderCount, this.transferCount, this.transferType, this.icon, this.accountAddress, this.balance, this.quoteUrl, this.price, this.totalPrice});

  TokenList.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
    symbol = json['symbol'];
    decimals = json['decimals'];
    granularity = json['granularity'];
    totalSupply = json['totalSupply'];
    holderCount = json['holderCount'];
    transferCount = json['transferCount'];
    transferType = json['transferType'];
    icon = json['icon'];
    accountAddress = json['accountAddress'];
    balance = json['balance'];
    quoteUrl = json['quoteUrl'];
    price = json['price'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['decimals'] = this.decimals;
    data['granularity'] = this.granularity;
    data['totalSupply'] = this.totalSupply;
    data['holderCount'] = this.holderCount;
    data['transferCount'] = this.transferCount;
    data['transferType'] = this.transferType;
    data['icon'] = this.icon;
    data['accountAddress'] = this.accountAddress;
    data['balance'] = this.balance;
    data['quoteUrl'] = this.quoteUrl;
    data['price'] = this.price;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}
