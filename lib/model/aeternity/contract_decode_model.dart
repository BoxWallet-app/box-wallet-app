class ContractDecodeModel {
  int? code;
  String? msg;
  int? time;
  Data? data;

  ContractDecodeModel({this.code, this.msg, this.time, this.data});

  ContractDecodeModel.fromJson(Map<String, dynamic> json) {
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
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? tokenNumber;

  Data({this.tokenNumber});

  Data.fromJson(Map<String, dynamic> json) {
    tokenNumber = json['token_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_number'] = this.tokenNumber;
    return data;
  }
}