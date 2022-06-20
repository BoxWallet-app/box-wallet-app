class TokenRecordModel {
  int? code;
  String? msg;
  int? time;
  List<Data>? data;

  TokenRecordModel({this.code, this.msg, this.time, this.data});

  TokenRecordModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? blockHash;
  int? blockHeight;
  String? hash;
  String? function;
  String? contractId;
  String? callAddress;
  String? aex9Amount;
  String? amount;
  String? fee;
  String? resultType;
  String? aex9ReceiveAddress;
  int? createTime;

  Data(
      {this.blockHash,
        this.blockHeight,
        this.hash,
        this.function,
        this.contractId,
        this.callAddress,
        this.aex9Amount,
        this.amount,
        this.fee,
        this.resultType,
        this.aex9ReceiveAddress,
        this.createTime});

  Data.fromJson(Map<String, dynamic> json) {
    blockHash = json['block_hash'];
    blockHeight = json['block_height'];
    hash = json['hash'];
    function = json['function'];
    contractId = json['contract_id'];
    callAddress = json['call_address'];
    aex9Amount = json['aex9_amount'];
    amount = json['amount'];
    fee = json['fee'];
    resultType = json['result_type'];
    aex9ReceiveAddress = json['aex9_receive_address'];
    createTime = json['create_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_hash'] = this.blockHash;
    data['block_height'] = this.blockHeight;
    data['hash'] = this.hash;
    data['function'] = this.function;
    data['contract_id'] = this.contractId;
    data['call_address'] = this.callAddress;
    data['aex9_amount'] = this.aex9Amount;
    data['amount'] = this.amount;
    data['fee'] = this.fee;
    data['result_type'] = this.resultType;
    data['aex9_receive_address'] = this.aex9ReceiveAddress;
    data['create_time'] = this.createTime;
    return data;
  }
}