class SwapOrderModel {
  int code;
  String msg;
  int time;
  List<Data> data;

  SwapOrderModel({this.code, this.msg, this.time, this.data});

  SwapOrderModel.fromJson(Map<String, dynamic> json) {
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
  String ae;
  String buyAddress;
  int cHeight;
  int cTime;
  String coin;
  String count;
  int pHeight;
  int pTime;
  String sellAddress;

  Data(
      {this.ae,
        this.buyAddress,
        this.cHeight,
        this.cTime,
        this.coin,
        this.count,
        this.pHeight,
        this.pTime,
        this.sellAddress});

  Data.fromJson(Map<String, dynamic> json) {
    ae = json['ae'];
    buyAddress = json['buy_address'];
    cHeight = json['c_height'];
    cTime = json['c_time'];
    coin = json['coin'];
    count = json['count'];
    pHeight = json['p_height'];
    pTime = json['p_time'];
    sellAddress = json['sell_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ae'] = this.ae;
    data['buy_address'] = this.buyAddress;
    data['c_height'] = this.cHeight;
    data['c_time'] = this.cTime;
    data['coin'] = this.coin;
    data['count'] = this.count;
    data['p_height'] = this.pHeight;
    data['p_time'] = this.pTime;
    data['sell_address'] = this.sellAddress;
    return data;
  }
}