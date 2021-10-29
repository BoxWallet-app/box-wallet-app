class CfxNftBalanceModel {
  int code;
  List<NftData> data;

  CfxNftBalanceModel({this.code, this.data});

  CfxNftBalanceModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<NftData>();
      json['data'].forEach((v) {
        data.add(new NftData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NftData {
  String address;
  String type;
  Name name;
  String balance;

  NftData({this.address, this.type, this.name, this.balance});

  NftData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    type = json['type'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['type'] = this.type;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['balance'] = this.balance;
    return data;
  }
}

class Name {
  String zh;
  String en;

  Name({this.zh, this.en});

  Name.fromJson(Map<String, dynamic> json) {
    zh = json['zh'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zh'] = this.zh;
    data['en'] = this.en;
    return data;
  }
}
