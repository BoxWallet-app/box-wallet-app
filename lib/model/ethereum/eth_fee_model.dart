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
  String maxMinutes;

  Data(
      {this.feeList,
        this.max,
        this.maxFee,
        this.maxTip,
        this.maxMinutes,
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
    maxMinutes = json['maxMinutes'].toString();
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
    data['maxMinutes'] = this.maxMinutes;
    data['minFee'] = this.minFee;
    data['minTip'] = this.minTip;
    return data;
  }
}

class FeeList {
  String fee;
  String maxFeePerGas;
  String minute;
  String maxPriorityFeePerGas;

  FeeList(
      {
        this.fee,
        this.maxFeePerGas,
        this.maxPriorityFeePerGas});

  FeeList.fromJson(Map<String, dynamic> json) {

    fee = json['fee'];
    maxFeePerGas = json['maxFeePerGas'];
    minute = json['minute'].toString();
    maxPriorityFeePerGas = json['maxPriorityFeePerGas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['fee'] = this.fee;
    data['maxFeePerGas'] = this.maxFeePerGas;
    data['minute'] = this.minute;
    data['maxPriorityFeePerGas'] = this.maxPriorityFeePerGas;
    return data;
  }
}
