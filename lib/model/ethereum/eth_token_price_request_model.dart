class EthTokenPriceRequestModel {
  int blockchainId;
  List<EthTokenPriceRequestItemModel> tokenList;

  EthTokenPriceRequestModel({this.blockchainId, this.tokenList});

  EthTokenPriceRequestModel.fromJson(Map<String, dynamic> json) {
    blockchainId = json['blockchain_id'];
    if (json['token_list'] != null) {
      tokenList = new List<EthTokenPriceRequestItemModel>();
      json['token_list'].forEach((v) {
        tokenList.add(new EthTokenPriceRequestItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockchain_id'] = this.blockchainId;
    if (this.tokenList != null) {
      data['token_list'] = this.tokenList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EthTokenPriceRequestItemModel {
  String address;
  String blSymbol;

  EthTokenPriceRequestItemModel({this.address, this.blSymbol});

  EthTokenPriceRequestItemModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    blSymbol = json['bl_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['bl_symbol'] = this.blSymbol;
    return data;
  }
}
