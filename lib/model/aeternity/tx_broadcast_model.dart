class TxBroadcastModel {
  int? code;
  String? msg;
  int? time;
  Data? data;

  TxBroadcastModel({this.code, this.msg, this.time, this.data});

  TxBroadcastModel.fromJson(Map<String, dynamic> json) {
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
  String? hash;

  Data({this.hash});

  Data.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    return data;
  }
}