class ContractInfoModel {
  int code;
  String msg;
  int time;
  Data data;

  ContractInfoModel({this.code, this.msg, this.time, this.data});

  ContractInfoModel.fromJson(Map<String, dynamic> json) {
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
  String contractBalance;
  String myBalance;

  Data({this.contractBalance, this.myBalance});

  Data.fromJson(Map<String, dynamic> json) {
    contractBalance = json['contract_balance'];
    myBalance = json['my_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contract_balance'] = this.contractBalance;
    data['my_balance'] = this.myBalance;
    return data;
  }
}