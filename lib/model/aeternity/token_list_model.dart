class TokenListModel {
  int code;
  String msg;
  int time;
  List<Data> data;

  TokenListModel({this.code, this.msg, this.time, this.data});

  TokenListModel.fromJson(Map<String, dynamic> json) {
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
  String count;
  String countStr;
  String ctAddress;
  String image;
  String name;
  String type;
  String rate = "0";

  Data({this.count, this.ctAddress, this.image, this.name, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    ctAddress = json['ct_address'];
    image = json['image'];
    name = json['name'];
    type = json['type'];
    rate = json['reta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['ct_address'] = this.ctAddress;
    data['image'] = this.image;
    data['name'] = this.name;
    data['type'] = this.type;
    data['reta'] = this.rate;
    return data;
  }
}
