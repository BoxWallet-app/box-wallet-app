class SwapCoinOrderModel {
  int? code;
  String? msg;
  int? time;
  List<Data>? data;

  SwapCoinOrderModel({this.code, this.msg, this.time, this.data});

  SwapCoinOrderModel.fromJson(Map<String, dynamic> json) {
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
  String? aeCount;
  String? buyAddress;
  String? coinName;
  int? createHeight;
  int? createTime;
  int? currentHeight;
  int? payHeight;
  int? payTime;
  String? sellAddress;
  String? tokenCount;

  Data(
      {this.aeCount,
        this.buyAddress,
        this.coinName,
        this.createHeight,
        this.createTime,
        this.currentHeight,
        this.payHeight,
        this.payTime,
        this.sellAddress,
        this.tokenCount});

  Data.fromJson(Map<String, dynamic> json) {
    aeCount = json['ae_count'];
    buyAddress = json['buy_address'];
    coinName = json['coin_name'];
    createHeight = json['create_height'];
    createTime = json['create_time'];
    currentHeight = json['current_height'];
    payHeight = json['pay_height'];
    payTime = json['pay_time'];
    sellAddress = json['sell_address'];
    tokenCount = json['token_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ae_count'] = this.aeCount;
    data['buy_address'] = this.buyAddress;
    data['coin_name'] = this.coinName;
    data['create_height'] = this.createHeight;
    data['create_time'] = this.createTime;
    data['current_height'] = this.currentHeight;
    data['pay_height'] = this.payHeight;
    data['pay_time'] = this.payTime;
    data['sell_address'] = this.sellAddress;
    data['token_count'] = this.tokenCount;
    return data;
  }
}