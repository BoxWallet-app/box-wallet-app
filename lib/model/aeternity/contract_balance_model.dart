class ContractBalanceModel {
  int code;
  String msg;
  int time;
  Data data;

  ContractBalanceModel({this.code, this.msg, this.time, this.data});

  ContractBalanceModel.fromJson(Map<String, dynamic> json) {
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
  String balance;
  String rate;

  Data({this.balance});

  Data.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['rate'] = this.rate;
    return data;
  }
}