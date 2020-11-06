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
  AccountInfo accountInfo;
  String contractBalance;
  String myBalance;

  Data({this.accountInfo, this.contractBalance, this.myBalance});

  Data.fromJson(Map<String, dynamic> json) {
    accountInfo = json['account_info'] != null
        ? new AccountInfo.fromJson(json['account_info'])
        : null;
    contractBalance = json['contract_balance'];
    myBalance = json['my_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accountInfo != null) {
      data['account_info'] = this.accountInfo.toJson();
    }
    data['contract_balance'] = this.contractBalance;
    data['my_balance'] = this.myBalance;
    return data;
  }
}

class AccountInfo {
  String account;
  String count;
  String earnings;
  int height;

  AccountInfo({this.account, this.count, this.earnings, this.height});

  AccountInfo.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    count = json['count'];
    earnings = json['earnings'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['count'] = this.count;
    data['earnings'] = this.earnings;
    data['height'] = this.height;
    return data;
  }
}