class EthTokenPriceRateModel {
  List<Data>? data;
  String? message;
  int? result;

  EthTokenPriceRateModel({this.data, this.message, this.result});

  EthTokenPriceRateModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  String? title;
  List<DataPrice>? data;

  Data({this.title, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data'] != null) {
      data = <DataPrice>[];
      json['data'].forEach((v) {
        data!.add(new DataPrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataPrice {
  String? name;
  String? symbol;
  String? rate;

  DataPrice({this.name, this.symbol, this.rate});

  DataPrice.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    rate = json['rate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['rate'] = this.rate;
    return data;
  }
}
