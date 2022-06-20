

class BaseNameDataModel {
  int? code;
  String? msg;
  int? time;
  Data? data;

  BaseNameDataModel({this.code, this.msg, this.time, this.data});

  BaseNameDataModel.fromJson(Map<String, dynamic> json) {
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
  int? count;
  int? sum;
  double?        sumPrice;
  List<Ranking>? ranking;

  Data({this.count, this.sum, this.sumPrice, this.ranking});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    sum = json['sum'];
    sumPrice = json['sum_price'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['sum'] = this.sum;
    data['sum_price'] = this.sumPrice;

    return data;
  }
}

class Ranking {
  String? owner;
  int? nameNum;
  double? sumPrice;

  Ranking({this.owner, this.nameNum, this.sumPrice});

  Ranking.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    nameNum = json['name_num'];
    sumPrice = json['sum_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['name_num'] = this.nameNum;
    data['sum_price'] = this.sumPrice;
    return data;
  }
}