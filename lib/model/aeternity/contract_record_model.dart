class ContractRecordModel {
  int code;
  String msg;
  int time;
  List<Data> data;

  ContractRecordModel({this.code, this.msg, this.time, this.data});

  ContractRecordModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String account;
  int continueHeight;
  int day;
  int height;
  String number;
  String tokenNumber;
  int unlockHeight;

  Data(
      {this.account,
        this.continueHeight,
        this.day,
        this.number,
        this.tokenNumber,
        this.unlockHeight});

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    continueHeight = json['continue_height'];
    day = json['day'];
    height = json['height'];
    number = json['number'];
    tokenNumber = json['token_number'];
    unlockHeight = json['unlock_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['continue_height'] = this.continueHeight;
    data['day'] = this.day;
    data['height'] = this.height;
    data['number'] = this.number;
    data['token_number'] = this.tokenNumber;
    data['unlock_height'] = this.unlockHeight;
    return data;
  }
}