class EthTokenTopModel {
  List<Data> data;
  String message;
  int result;

  EthTokenTopModel({this.data, this.message, this.result});

  EthTokenTopModel.fromJson(Map<String, dynamic> json) {
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
  Null blockchain;
  int tokenType;
  String name;
  String symbol;
  String blSymbol;
  int gas;
  int decimal;
  int precision;
  String balance;
  Null frozenBalances;
  double priceUsd;
  int percentChange24h;
  int asset;
  int added;
  String address;
  String ownerAddress;
  String website;
  String description;
  int updateContract;
  String totalSupply;
  int holderCount;
  int published;
  String tiLink;
  int tokenStatus;
  int validated;
  String iconUrl;
  int autoAdd;
  String dappCode;
  int tokenProtocol;
  int metadataType;
  String createTime;
  int weight;

  Data(
      {this.hid,
        this.blockchainId,
        this.blockchain,
        this.tokenType,
        this.name,
        this.symbol,
        this.blSymbol,
        this.gas,
        this.decimal,
        this.precision,
        this.balance,
        this.frozenBalances,
        this.priceUsd,
        this.percentChange24h,
        this.asset,
        this.added,
        this.address,
        this.ownerAddress,
        this.website,
        this.description,
        this.updateContract,
        this.totalSupply,
        this.holderCount,
        this.published,
        this.tiLink,
        this.tokenStatus,
        this.validated,
        this.iconUrl,
        this.autoAdd,
        this.dappCode,
        this.tokenProtocol,
        this.metadataType,
        this.createTime,
        this.weight});

  Data.fromJson(Map<String, dynamic> json) {
    hid = json['hid'];
    blockchainId = json['blockchain_id'];
    blockchain = json['blockchain'];
    tokenType = json['token_type'];
    name = json['name'];
    symbol = json['symbol'];
    blSymbol = json['bl_symbol'];
    gas = json['gas'];
    decimal = json['decimal'];
    precision = json['precision'];
    balance = json['balance'];
    frozenBalances = json['frozen_balances'];
    priceUsd = json['price_usd'];
    percentChange24h = json['percent_change_24h'];
    asset = json['asset'];
    added = json['added'];
    address = json['address'];
    ownerAddress = json['owner_address'];
    website = json['website'];
    description = json['description'];
    updateContract = json['update_contract'];
    totalSupply = json['total_supply'];
    holderCount = json['holder_count'];
    published = json['published'];
    tiLink = json['ti_link'];
    tokenStatus = json['token_status'];
    validated = json['validated'];
    iconUrl = json['icon_url'];
    autoAdd = json['auto_add'];
    dappCode = json['dapp_code'];
    tokenProtocol = json['token_protocol'];
    metadataType = json['metadata_type'];
    createTime = json['create_time'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hid'] = this.hid;
    data['blockchain_id'] = this.blockchainId;
    data['blockchain'] = this.blockchain;
    data['token_type'] = this.tokenType;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['bl_symbol'] = this.blSymbol;
    data['gas'] = this.gas;
    data['decimal'] = this.decimal;
    data['precision'] = this.precision;
    data['balance'] = this.balance;
    data['frozen_balances'] = this.frozenBalances;
    data['price_usd'] = this.priceUsd;
    data['percent_change_24h'] = this.percentChange24h;
    data['asset'] = this.asset;
    data['added'] = this.added;
    data['address'] = this.address;
    data['owner_address'] = this.ownerAddress;
    data['website'] = this.website;
    data['description'] = this.description;
    data['update_contract'] = this.updateContract;
    data['total_supply'] = this.totalSupply;
    data['holder_count'] = this.holderCount;
    data['published'] = this.published;
    data['ti_link'] = this.tiLink;
    data['token_status'] = this.tokenStatus;
    data['validated'] = this.validated;
    data['icon_url'] = this.iconUrl;
    data['auto_add'] = this.autoAdd;
    data['dapp_code'] = this.dappCode;
    data['token_protocol'] = this.tokenProtocol;
    data['metadata_type'] = this.metadataType;
    data['create_time'] = this.createTime;
    data['weight'] = this.weight;
    return data;
  }
}
