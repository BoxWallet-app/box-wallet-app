class EthTokenPriceModel {
  List<String>? data;
  String? message;
  int? result;

  EthTokenPriceModel({this.data, this.message, this.result});

  EthTokenPriceModel.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<String>();
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}