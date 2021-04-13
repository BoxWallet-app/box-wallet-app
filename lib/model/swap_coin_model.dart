class SwapCoinModel {
  int code;
  String msg;
  int time;
  List<SwapCoinModelData> data;

  SwapCoinModel({this.code, this.msg, this.time, this.data});

  SwapCoinModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = new List<SwapCoinModelData>();
      json['data'].forEach((v) {
        data.add(new SwapCoinModelData.fromJson(v));
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

class SwapCoinModelData {
  String name;
  String ctAddress;
  double lowTokenCount;
  double lowAeCount;

  SwapCoinModelData({this.name, this.ctAddress, this.lowTokenCount, this.lowAeCount});

  SwapCoinModelData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ctAddress = json['ct_address'];
    lowTokenCount = json['low_token_count'];
    lowAeCount = json['low_ae_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ct_address'] = this.ctAddress;
    data['low_token_count'] = this.lowTokenCount;
    data['low_ae_count'] = this.lowAeCount;
    return data;
  }
}