class AensPageModel {
  int code;
  List<Data> data;
  String msg;
  int time;

  AensPageModel({this.code, this.data, this.msg, this.time});

  AensPageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['time'] = this.time;
    return data;
  }
}

class Data {
  int currentHeight;
  String currentPrice;
  int endHeight;
  int length;
  String name;
  int overHeight;
  String owner;
  String price;
  int startHeight;
  String thHash;

  Data(
      {this.currentHeight,
        this.currentPrice,
        this.endHeight,
        this.length,
        this.name,
        this.overHeight,
        this.owner,
        this.price,
        this.startHeight,
        this.thHash});

  Data.fromJson(Map<String, dynamic> json) {
    currentHeight = json['current_height'];
    currentPrice = json['current_price'];
    endHeight = json['end_height'];
    length = json['length'];
    name = json['name'];
    overHeight = json['over_height'];
    owner = json['owner'];
    price = json['price'];
    startHeight = json['start_height'];
    thHash = json['th_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_height'] = this.currentHeight;
    data['current_price'] = this.currentPrice;
    data['end_height'] = this.endHeight;
    data['length'] = this.length;
    data['name'] = this.name;
    data['over_height'] = this.overHeight;
    data['owner'] = this.owner;
    data['price'] = this.price;
    data['start_height'] = this.startHeight;
    data['th_hash'] = this.thHash;
    return data;
  }
}