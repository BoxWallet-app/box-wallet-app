class MsgSignModel {
  int? code;
  String? msg;
  int? time;
  Data? data;

  MsgSignModel({this.code, this.msg, this.time, this.data});

  MsgSignModel.fromJson(Map<String, dynamic> json) {
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
  String? msg;
  String? tx;
  double? salt;

  Data({this.msg, this.tx});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    tx = json['tx'];
    salt = json['salt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['tx'] = this.tx;
    data['salt'] = this.salt;
    return data;
  }
}