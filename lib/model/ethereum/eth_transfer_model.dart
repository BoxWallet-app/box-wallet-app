class EthTransferModel {
  List<EthTransferItemData>? data;
  String? message;
  int? result;

  EthTransferModel({this.data, this.message, this.result});

  EthTransferModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EthTransferItemData>[];
      json['data'].forEach((v) {
        data!.add(new EthTransferItemData.fromJson(v));
      });
    }
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}

class EthTransferItemData {
  int? decimal;
  String? fee;
  String? symbol;
  int? timestamp;
  int? blockNumber;
  String? gas;
  String? gasPrice;
  String? usedGas;
  String? value;
  String? tokenValue;
  String? hash;
  String? nonce;
  String? blockHash;
  int? logIndex;
  String? from;
  String? to;
  String? addrToken;
  int? type;
  String? input;
  int? inputStatus;
  int? status;
  String? errorMessage;

  EthTransferItemData(
      {this.decimal,
        this.fee,
        this.symbol,
        this.timestamp,
        this.blockNumber,
        this.gas,
        this.gasPrice,
        this.usedGas,
        this.value,
        this.tokenValue,
        this.hash,
        this.nonce,
        this.blockHash,
        this.logIndex,
        this.from,
        this.to,
        this.addrToken,
        this.type,
        this.input,
        this.inputStatus,
        this.errorMessage,
        this.status});

  EthTransferItemData.fromJson(Map<String, dynamic> json) {
    decimal = json['decimal'];
    fee = json['fee'];
    symbol = json['symbol'];
    timestamp = json['timestamp'];
    blockNumber = json['block_number'];
    gas = json['gas'];
    gasPrice = json['gas_price'];
    usedGas = json['used_gas'];
    value = json['value'];
    tokenValue = json['token_value'];
    hash = json['hash'];
    nonce = json['nonce'];
    blockHash = json['block_hash'];
    logIndex = json['log_index'];
    from = json['from'];
    to = json['to'];
    addrToken = json['addr_token'];
    type = json['type'];
    input = json['input'];
    inputStatus = json['input_status'];
    status = json['status'];
    errorMessage = json['error_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['decimal'] = this.decimal;
    data['fee'] = this.fee;
    data['symbol'] = this.symbol;
    data['timestamp'] = this.timestamp;
    data['block_number'] = this.blockNumber;
    data['gas'] = this.gas;
    data['gas_price'] = this.gasPrice;
    data['used_gas'] = this.usedGas;
    data['value'] = this.value;
    data['token_value'] = this.tokenValue;
    data['hash'] = this.hash;
    data['nonce'] = this.nonce;
    data['block_hash'] = this.blockHash;
    data['log_index'] = this.logIndex;
    data['from'] = this.from;
    data['to'] = this.to;
    data['addr_token'] = this.addrToken;
    data['type'] = this.type;
    data['input'] = this.input;
    data['input_status'] = this.inputStatus;
    data['status'] = this.status;
    data['error_message'] = this.errorMessage;
    return data;
  }
}
