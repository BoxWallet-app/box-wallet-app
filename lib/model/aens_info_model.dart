class AensInfoModel {
  int code;
  String msg;
  int time;
  Data data;

  AensInfoModel({this.code, this.msg, this.time, this.data});

  AensInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Claim> claim;
  int currentHeight;
  String currentPrice;
  int endHeight;
  int length;
  String name;
  int overHeight;
  String owner;
  String price;
  int startHeight;
  String thHash;

  Data(
      {this.claim,
        this.currentHeight,
        this.currentPrice,
        this.endHeight,
        this.length,
        this.name,
        this.overHeight,
        this.owner,
        this.price,
        this.startHeight,
        this.thHash});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['claim'] != null) {
      claim = new List<Claim>();
      json['claim'].forEach((v) {
        claim.add(new Claim.fromJson(v));
      });
    }
    currentHeight = json['current_height'];
    currentPrice = json['current_price'];
    endHeight = json['end_height'];
    length = json['length'];
    name = json['name'];
    overHeight = json['over_height'];
    owner = json['owner'];
    price = json['price'];
    startHeight = json['start_height'];
    thHash = json['th_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.claim != null) {
      data['claim'] = this.claim.map((v) => v.toJson()).toList();
    }
    data['current_height'] = this.currentHeight;
    data['current_price'] = this.currentPrice;
    data['end_height'] = this.endHeight;
    data['length'] = this.length;
    data['name'] = this.name;
    data['over_height'] = this.overHeight;
    data['owner'] = this.owner;
    data['price'] = this.price;
    data['start_height'] = this.startHeight;
    data['th_hash'] = this.thHash;
    return data;
  }
}

class Claim {
  String accountId;
  int blockHeight;
  int fee;
  String hash;
  String name;
  String nameFee;
  num nameSalt;
  int nonce;
  int time;
  int ttl;
  String type;
  int version;

  Claim(
      {this.accountId,
        this.blockHeight,
        this.fee,
        this.hash,
        this.name,
        this.nameFee,
        this.nameSalt,
        this.nonce,
        this.time,
        this.ttl,
        this.type,
        this.version});

  Claim.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    blockHeight = json['block_height'];
    fee = json['fee'];
    hash = json['hash'];
    name = json['name'];
    nameFee = json['name_fee'];
    nameSalt = json['name_salt'];
    nonce = json['nonce'];
    time = json['time'];
    ttl = json['ttl'];
    type = json['type'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['block_height'] = this.blockHeight;
    data['fee'] = this.fee;
    data['hash'] = this.hash;
    data['name'] = this.name;
    data['name_fee'] = this.nameFee;
    data['name_salt'] = this.nameSalt;
    data['nonce'] = this.nonce;
    data['time'] = this.time;
    data['ttl'] = this.ttl;
    data['type'] = this.type;
    data['version'] = this.version;
    return data;
  }
}