class SwapModel {
  int? code;
  String? msg;
  int? time;
  List<Data>? data;

  SwapModel({this.code, this.msg, this.time, this.data});

  SwapModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? account;
  String? ae;
  String? coin;
  String? count;


  double getPremium(){
    return (double.parse(ae!)) / (double.parse(count!));
  }
  Data({this.account, this.ae, this.coin, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    ae = json['ae'];
    coin = json['coin'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['ae'] = this.ae;
    data['coin'] = this.coin;
    data['count'] = this.count;
    return data;
  }
}