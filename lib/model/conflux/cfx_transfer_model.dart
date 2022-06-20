class CfxTransfer {
  int? total;
  int? listLimit;
  List<Data>? list;

  CfxTransfer({this.total, this.listLimit, this.list});

  CfxTransfer.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    listLimit = json['listLimit'];
    if (json['list'] != null) {
      list = <Data>[];
      json['list'].forEach((v) {
        list!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['listLimit'] = this.listLimit;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? blockHash;
  String? method;
  int? transactionIndex;
  String? nonce;
  String? hash;
  String? from;
  String? to;
  String? value;
  String? gasPrice;
  int? status;
  int? timestamp;
  int? epochNumber;
  int? syncTimestamp;
  String? gasFee;
  ToContractInfo? toContractInfo;
  ToTokenInfo? toTokenInfo;
  String? txExecErrorMsg;

  Data(
      {this.blockHash,
        this.method,
        this.transactionIndex,
        this.nonce,
        this.hash,
        this.from,
        this.to,
        this.value,
        this.gasPrice,
        this.status,
        this.timestamp,
        this.epochNumber,
        this.syncTimestamp,
        this.gasFee,
        this.toContractInfo,
        this.toTokenInfo,
        this.txExecErrorMsg});

  Data.fromJson(Map<String, dynamic> json) {
    blockHash = json['blockHash'];
    method = json['method'];
    transactionIndex = json['transactionIndex'];
    nonce = json['nonce'];
    hash = json['hash'];
    from = json['from'];
    to = json['to'];
    value = json['value'];
    gasPrice = json['gasPrice'];
    status = json['status'];
    timestamp = json['timestamp'];
    epochNumber = json['epochNumber'];
    syncTimestamp = json['syncTimestamp'];
    gasFee = json['gasFee'];
    toContractInfo = json['toContractInfo'] != null
        ? new ToContractInfo.fromJson(json['toContractInfo'])
        : null;
    toTokenInfo = json['toTokenInfo'] != null
        ? new ToTokenInfo.fromJson(json['toTokenInfo'])
        : null;
    txExecErrorMsg = json['txExecErrorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockHash'] = this.blockHash;
    data['method'] = this.method;
    data['transactionIndex'] = this.transactionIndex;
    data['nonce'] = this.nonce;
    data['hash'] = this.hash;
    data['from'] = this.from;
    data['to'] = this.to;
    data['value'] = this.value;
    data['gasPrice'] = this.gasPrice;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['epochNumber'] = this.epochNumber;
    data['syncTimestamp'] = this.syncTimestamp;
    data['gasFee'] = this.gasFee;
    if (this.toContractInfo != null) {
      data['toContractInfo'] = this.toContractInfo!.toJson();
    }
    if (this.toTokenInfo != null) {
      data['toTokenInfo'] = this.toTokenInfo!.toJson();
    }
    data['txExecErrorMsg'] = this.txExecErrorMsg;
    return data;
  }
}

class ToContractInfo {
  String? address;
  String? name;
  Verify? verify;

  ToContractInfo({this.address, this.name, this.verify});

  ToContractInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
    verify =
    json['verify'] != null ? new Verify.fromJson(json['verify']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    if (this.verify != null) {
      data['verify'] = this.verify!.toJson();
    }
    return data;
  }
}

class Verify {
  int? result;

  Verify({this.result});

  Verify.fromJson(Map<String, dynamic> json) {
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    return data;
  }
}

class ToTokenInfo {
  String? address;
  String? name;
  String? symbol;
  String? icon;
  int? decimals;

  ToTokenInfo({this.address, this.name, this.symbol, this.icon, this.decimals});

  ToTokenInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
    symbol = json['symbol'];
    icon = json['icon'];
    decimals = json['decimals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['icon'] = this.icon;
    data['decimals'] = this.decimals;
    return data;
  }
}