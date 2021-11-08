class CfxTokensListModel {
  int total;
  List<TokensData> list;

  CfxTokensListModel({this.total, this.list});

  CfxTokensListModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = new List<TokensData>();
      json['list'].forEach((v) {
        list.add(new TokensData.fromJson(v));
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

class TokensData {
  int hex40id;
  String address;
  String name;
  String symbol;
  int decimals;
  int granularity;
  String totalSupply;
  String transferType;
  int holderCount;
  int transferCount;
  String price;
  String totalPrice;
  String quoteUrl;
  String iconUrl;
  bool isSelect = false;

  TokensData(
      {this.hex40id,
        this.address,
        this.name,
        this.symbol,
        this.decimals,
        this.granularity,
        this.totalSupply,
        this.transferType,
        this.holderCount,
        this.transferCount,
        this.price,
        this.totalPrice,
        this.quoteUrl,
        this.iconUrl});

  TokensData.fromJson(Map<String, dynamic> json) {
    hex40id = json['hex40id'];
    address = json['address'];
    name = json['name'];
    symbol = json['symbol'];
    decimals = json['decimals'];
    granularity = json['granularity'];
    totalSupply = json['totalSupply'];
    transferType = json['transferType'];
    holderCount = json['holderCount'];
    transferCount = json['transferCount'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    quoteUrl = json['quoteUrl'];
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hex40id'] = this.hex40id;
    data['address'] = this.address;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['decimals'] = this.decimals;
    data['granularity'] = this.granularity;
    data['totalSupply'] = this.totalSupply;
    data['transferType'] = this.transferType;
    data['holderCount'] = this.holderCount;
    data['transferCount'] = this.transferCount;
    data['price'] = this.price;
    data['totalPrice'] = this.totalPrice;
    data['quoteUrl'] = this.quoteUrl;
    data['iconUrl'] = this.iconUrl;
    return data;
  }
}
