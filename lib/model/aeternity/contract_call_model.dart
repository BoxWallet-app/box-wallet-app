class ContractCallModel {
  int? code;
  String? msg;
  int? time;
  Data? data;

  ContractCallModel({this.code, this.msg, this.time, this.data});

  ContractCallModel.fromJson(Map<String, dynamic> json) {
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
  String? function;
  String? tx;

  Data({this.function, this.tx});

  Data.fromJson(Map<String, dynamic> json) {
    function = json['function'];
    tx = json['tx'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['function'] = this.function;
    data['tx'] = this.tx;
    return data;
  }
}