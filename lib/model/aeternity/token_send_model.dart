class TokenSendModel {
  int? code;
  Data? data;
  String? msg;
  int? time;

  TokenSendModel({this.code, this.data, this.msg, this.time});

  TokenSendModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    data['time'] = this.time;
    return data;
  }
}

class Data {
  String? blockHash;
  int? blockHeight;
  Null error;
  String? hash;
  bool? mined;
  String? signature;
  String? signedTx;
  Tx? tx;

  Data({this.blockHash, this.blockHeight, this.error, this.hash, this.mined, this.signature, this.signedTx, this.tx});

  Data.fromJson(Map<String, dynamic> json) {
    blockHash = json['BlockHash'];
    blockHeight = json['BlockHeight'];
    error = json['Error'];
    hash = json['Hash'];
    mined = json['Mined'];
    signature = json['Signature'];
    signedTx = json['SignedTx'];
    tx = json['Tx'] != null ? new Tx.fromJson(json['Tx']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BlockHash'] = this.blockHash;
    data['BlockHeight'] = this.blockHeight;
    data['Error'] = this.error;
    data['Hash'] = this.hash;
    data['Mined'] = this.mined;
    data['Signature'] = this.signature;
    data['SignedTx'] = this.signedTx;
    if (this.tx != null) {
      data['Tx'] = this.tx!.toJson();
    }
    return data;
  }
}

class Tx {
  String? accountID;
  int? accountNonce;
  int? fee;
  String? name;
  int? nameFee;
  double? nameSalt;
  int? tTL;

  Tx({this.accountID, this.accountNonce, this.fee, this.name, this.nameFee, this.nameSalt, this.tTL});

  Tx.fromJson(Map<String, dynamic> json) {
    accountID = json['AccountID'];
    accountNonce = json['AccountNonce'];
    fee = json['Fee'];
    name = json['Name'];
    nameFee = json['NameFee'];
    nameSalt = json['NameSalt'];
    tTL = json['TTL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AccountID'] = this.accountID;
    data['AccountNonce'] = this.accountNonce;
    data['Fee'] = this.fee;
    data['Name'] = this.name;
    data['NameFee'] = this.nameFee;
    data['NameSalt'] = this.nameSalt;
    data['TTL'] = this.tTL;
    return data;
  }
}
