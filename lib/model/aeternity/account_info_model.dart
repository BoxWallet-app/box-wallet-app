class AccountInfoModel {
  int? code;
  Data? data;
  String? msg;
  int? time;

  AccountInfoModel({this.code, this.data, this.msg, this.time});

  AccountInfoModel.fromJson(Map<String, dynamic> json) {
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
  String? address;
  String? balance;

  Data({this.address, this.balance});

  Data.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['balance'] = this.balance;
    return data;
  }
}