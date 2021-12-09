class EthActivityCoinModel {
  List<Data> data;
  String message;
  int result;

  EthActivityCoinModel({this.data, this.message, this.result});

  EthActivityCoinModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  int hid;
  int blockchainId;
  int tokenType;
  String name;
  String symbol;
  String blSymbol;
  int gas;
  int decimal;
  int precision;
  String priceUsd;
  String address;
  int tokenStatus;
  String iconUrl;
  int tokenProtocol;
  String website;
  String description;
  int ts;

  Data(
      {this.hid,
        this.blockchainId,
        this.tokenType,
        this.name,
        this.symbol,
        this.blSymbol,
        this.gas,
        this.decimal,
        this.precision,
        this.priceUsd,
        this.address,
        this.tokenStatus,
        this.iconUrl,
        this.tokenProtocol,
        this.website,
        this.description,
        this.ts});

  Data.fromJson(Map<String, dynamic> json) {
    hid = json['hid'];
    blockchainId = json['blockchain_id'];
    tokenType = json['token_type'];
    name = json['name'];
    symbol = json['symbol'];
    blSymbol = json['bl_symbol'];
    gas = json['gas'];
    decimal = json['decimal'];
    precision = json['precision'];
    priceUsd = json['price_usd'].toString();
    address = json['address'];
    tokenStatus = json['token_status'];
    iconUrl = json['icon_url'];
    tokenProtocol = json['token_protocol'];
    website = json['website'];
    description = json['description'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hid'] = this.hid;
    data['blockchain_id'] = this.blockchainId;
    data['token_type'] = this.tokenType;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['bl_symbol'] = this.blSymbol;
    data['gas'] = this.gas;
    data['decimal'] = this.decimal;
    data['precision'] = this.precision;
    data['price_usd'] = this.priceUsd.toString();
    data['address'] = this.address;
    data['token_status'] = this.tokenStatus;
    data['icon_url'] = this.iconUrl;
    data['token_protocol'] = this.tokenProtocol;
    data['website'] = this.website;
    data['description'] = this.description;
    data['ts'] = this.ts;
    return data;
  }
}
