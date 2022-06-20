class CfxRpcModel {
  String? type;
  Payload? payload;
  int? resolver;

  CfxRpcModel({this.type, this.payload, this.resolver});

  CfxRpcModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    resolver = json['resolver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['resolver'] = this.resolver;
    return data;
  }
}

class Payload {
  String? storageLimit;
  String? gas;
  String? gasPrice;
  String? value;
  String? from;
  String? to;
  String? data;

  Payload(
      {this.storageLimit,
        this.gas,
        this.gasPrice,
        this.value,
        this.from,
        this.to,
        this.data});

  Payload.fromJson(Map<String, dynamic> json) {
    storageLimit = json['storageLimit'];
    gas = json['gas'];
    gasPrice = json['gasPrice'];
    value = json['value'];
    from = json['from'];
    to = json['to'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storageLimit'] = this.storageLimit;
    data['gas'] = this.gas;
    data['gasPrice'] = this.gasPrice;
    data['value'] = this.value;
    data['from'] = this.from;
    data['to'] = this.to;
    data['data'] = this.data;
    return data;
  }
}
