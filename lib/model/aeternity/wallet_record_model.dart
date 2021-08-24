class WalletTransferRecordModel {
  int code;
  String msg;
  int time;
  List<RecordData> data;

  WalletTransferRecordModel({this.code, this.msg, this.time, this.data});

  WalletTransferRecordModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = new List<RecordData>();
      json['data'].forEach((v) {
        data.add(new RecordData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecordData {
  String blockHash;
  int blockHeight;
  String hash;
  int time;
  Map<String,dynamic>  tx;

  RecordData({this.blockHash, this.blockHeight, this.hash, this.time, this.tx});

  RecordData.fromJson(Map<String, dynamic> json) {
    blockHash = json['block_hash'];
    blockHeight = json['block_height'];
    hash = json['hash'];
    time = json['time'];
    tx = json['tx'] != null ? json['tx'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_hash'] = this.blockHash;
    data['block_height'] = this.blockHeight;
    data['hash'] = this.hash;
    data['time'] = this.time;
    if (this.tx != null) {
//      data['tx'] = this.tx.toJson();
    }
    return data;
  }
}

class Tx {
  int fee;
  int nonce;
  String oracleId;
  String query;
  int queryFee;
  QueryTtl queryTtl;
  QueryTtl responseTtl;
  String senderId;
  int ttl;
  String type;
  int version;
  int abiVersion;
  String accountId;
  QueryTtl oracleTtl;
  String queryFormat;
  String responseFormat;
  String amount;
  String payload;
  String recipientId;

  Tx(
      {this.fee,
        this.nonce,
        this.oracleId,
        this.query,
        this.queryFee,
        this.queryTtl,
        this.responseTtl,
        this.senderId,
        this.ttl,
        this.type,
        this.version,
        this.abiVersion,
        this.accountId,
        this.oracleTtl,
        this.queryFormat,
        this.responseFormat,
        this.amount,
        this.payload,
        this.recipientId});

  Tx.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    nonce = json['nonce'];
    oracleId = json['oracle_id'];
    query = json['query'];
    queryFee = json['query_fee'];
    queryTtl = json['query_ttl'] != null
        ? new QueryTtl.fromJson(json['query_ttl'])
        : null;
    responseTtl = json['response_ttl'] != null
        ? new QueryTtl.fromJson(json['response_ttl'])
        : null;
    senderId = json['sender_id'];
    ttl = json['ttl'];
    type = json['type'];
    version = json['version'];
    abiVersion = json['abi_version'];
    accountId = json['account_id'];
    oracleTtl = json['oracle_ttl'] != null
        ? new QueryTtl.fromJson(json['oracle_ttl'])
        : null;
    queryFormat = json['query_format'];
    responseFormat = json['response_format'];
    amount = json['amount'].toString();
    payload = json['payload'];
    recipientId = json['recipient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['nonce'] = this.nonce;
    data['oracle_id'] = this.oracleId;
    data['query'] = this.query;
    data['query_fee'] = this.queryFee;
    if (this.queryTtl != null) {
      data['query_ttl'] = this.queryTtl.toJson();
    }
    if (this.responseTtl != null) {
      data['response_ttl'] = this.responseTtl.toJson();
    }
    data['sender_id'] = this.senderId;
    data['ttl'] = this.ttl;
    data['type'] = this.type;
    data['version'] = this.version;
    data['abi_version'] = this.abiVersion;
    data['account_id'] = this.accountId;
    if (this.oracleTtl != null) {
      data['oracle_ttl'] = this.oracleTtl.toJson();
    }
    data['query_format'] = this.queryFormat;
    data['response_format'] = this.responseFormat;
    data['amount'] = this.amount;
    data['payload'] = this.payload;
    data['recipient_id'] = this.recipientId;
    return data;
  }
}

class QueryTtl {
  String type;
  int value;

  QueryTtl({this.type, this.value});

  QueryTtl.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}