class EthTokenSearchModel {
  List<EthTokenItemModel> data;
  String message;
  int result;

  EthTokenSearchModel({this.data, this.message, this.result});

  EthTokenSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<EthTokenItemModel>();
      json['data'].forEach((v) {
        data.add(new EthTokenItemModel.fromJson(v));
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

class EthTokenItemModel {
  int hid;
  int blockchainId;
  int tokenType;
  String name;
  String symbol;
  String blSymbol;
  int decimal;
  int precision;
  String balance;
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
  bool isSelect =false;

  int get top => isSelect ? 1 : 0;

  EthTokenItemModel(
      {this.hid,
        this.blockchainId,
        this.tokenType,
        this.name,
        this.symbol,
        this.blSymbol,
        this.decimal,
        this.precision,
        this.balance,
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

  EthTokenItemModel.fromJson(Map<String, dynamic> json) {
    hid = json['hid'];
    blockchainId = json['blockchain_id'];
    tokenType = json['token_type'];
    name = json['name'];
    symbol = json['symbol'];
    blSymbol = json['bl_symbol'];
    decimal = json['decimal'];
    precision = json['precision'];
    balance = json['balance'];
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
    data['token_type'] = this.tokenType;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['bl_symbol'] = this.blSymbol;
    data['decimal'] = this.decimal;
    data['precision'] = this.precision;
    data['balance'] = this.balance;
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
