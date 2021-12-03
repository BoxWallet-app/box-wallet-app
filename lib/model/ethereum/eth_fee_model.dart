class EthFeeModel {
  Data data;
  String message;
  int result;

  EthFeeModel({this.data, this.message, this.result});

  EthFeeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  List<FeeList> feeList;
  String max;
  String maxFee;
  String maxTip;
  String min;
  String minFee;
  String minTip;

  Data(
      {this.feeList,
        this.max,
        this.maxFee,
        this.maxTip,
        this.min,
        this.minFee,
        this.minTip});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['fee_list'] != null) {
      feeList = new List<FeeList>();
      json['fee_list'].forEach((v) {
        feeList.add(new FeeList.fromJson(v));
      });
    }
    max = json['max'];
    maxFee = json['maxFee'];
    maxTip = json['maxTip'];
    min = json['min'];
    minFee = json['minFee'];
    minTip = json['minTip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feeList != null) {
      data['fee_list'] = this.feeList.map((v) => v.toJson()).toList();
    }
    data['max'] = this.max;
    data['maxFee'] = this.maxFee;
    data['maxTip'] = this.maxTip;
    data['min'] = this.min;
    data['minFee'] = this.minFee;
    data['minTip'] = this.minTip;
    return data;
  }
}

class FeeList {
  int minFee;
  int maxFee;
  int dayCount;
  int memCount;
  int minDelay;
  int maxDelay;
  int minMinutes;
  int maxMinutes;
  String fee;
  double minute;
  String maxFeePerGas;
  String maxPriorityFeePerGas;

  FeeList(
      {this.minFee,
        this.maxFee,
        this.dayCount,
        this.memCount,
        this.minDelay,
        this.maxDelay,
        this.minMinutes,
        this.maxMinutes,
        this.fee,
        this.minute,
        this.maxFeePerGas,
        this.maxPriorityFeePerGas});

  FeeList.fromJson(Map<String, dynamic> json) {
    minFee = json['minFee'];
    maxFee = json['maxFee'];
    dayCount = json['dayCount'];
    memCount = json['memCount'];
    minDelay = json['minDelay'];
    maxDelay = json['maxDelay'];
    minMinutes = json['minMinutes'];
    maxMinutes = json['maxMinutes'];
    fee = json['fee'];
    minute = json['minute'];
    maxFeePerGas = json['maxFeePerGas'];
    maxPriorityFeePerGas = json['maxPriorityFeePerGas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minFee'] = this.minFee;
    data['maxFee'] = this.maxFee;
    data['dayCount'] = this.dayCount;
    data['memCount'] = this.memCount;
    data['minDelay'] = this.minDelay;
    data['maxDelay'] = this.maxDelay;
    data['minMinutes'] = this.minMinutes;
    data['maxMinutes'] = this.maxMinutes;
    data['fee'] = this.fee;
    data['minute'] = this.minute;
    data['maxFeePerGas'] = this.maxFeePerGas;
    data['maxPriorityFeePerGas'] = this.maxPriorityFeePerGas;
    return data;
  }
}
