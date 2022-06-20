class CfxCrc20TransferModel {
  int? code;
  String? message;
  Data? data;

  CfxCrc20TransferModel({this.code, this.message, this.data});

  CfxCrc20TransferModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? total;
  List<Transfer>? list;
  // AddressInfo addressInfo;

  Data({this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = <Transfer>[];
      json['list'].forEach((v) {
        list!.add(new Transfer.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transfer {
  int? epochNumber;
  String? transactionHash;
  String? from;
  String? to;
  int? timestamp;
  String? contract;
  String? amount;

  Transfer(
      {this.epochNumber,
        this.transactionHash,
        this.from,
        this.to,
        this.timestamp,
        this.contract,
        this.amount});

  Transfer.fromJson(Map<String, dynamic> json) {
    epochNumber = json['epochNumber'];
    transactionHash = json['transactionHash'];
    from = json['from'];
    to = json['to'];
    timestamp = json['timestamp'];
    contract = json['contract'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['epochNumber'] = this.epochNumber;
    data['transactionHash'] = this.transactionHash;
    data['from'] = this.from;
    data['to'] = this.to;
    data['timestamp'] = this.timestamp;
    data['contract'] = this.contract;
    data['amount'] = this.amount;
    return data;
  }
}

