class SwapCoinAccountModel {
  int code;
  String msg;
  int time;
  List<Data> data;

  SwapCoinAccountModel({this.code, this.msg, this.time, this.data});

  SwapCoinAccountModel.fromJson(Map<String, dynamic> json) {
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
  String coinName;
  String aeCount;
  String tokenCount;
  String token;
  String rate;

  Data(
      {this.account,
        this.coinName,
        this.aeCount,
        this.tokenCount,
        this.token,
        this.rate});

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    coinName = json['coin_name'];
    aeCount = json['ae_count'];
    tokenCount = json['token_count'];
    token = json['token'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['coin_name'] = this.coinName;
    data['ae_count'] = this.aeCount;
    data['token_count'] = this.tokenCount;
    data['token'] = this.token;
    data['rate'] = this.rate;
    return data;
  }
}