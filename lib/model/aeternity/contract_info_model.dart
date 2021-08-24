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
  String account;
  int afterHeight;
  String allCount;
  String count;
  int height;
  int minHeight;
  String token;

  Data(
      {this.account,
        this.afterHeight,
        this.allCount,
        this.count,
        this.height,
        this.minHeight,
        this.token});

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    afterHeight = json['after_height'];
    allCount = json['all_count'];
    count = json['count'];
    height = json['height'];
    minHeight = json['min_height'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['after_height'] = this.afterHeight;
    data['all_count'] = this.allCount;
    data['count'] = this.count;
    data['height'] = this.height;
    data['min_height'] = this.minHeight;
    data['token'] = this.token;
    return data;
  }
}