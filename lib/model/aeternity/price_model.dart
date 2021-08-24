class PriceModel {
  Aeternity aeternity;

  PriceModel({this.aeternity});

  PriceModel.fromJson(Map<String, dynamic> json) {
    aeternity = json['aeternity'] != null
        ? new Aeternity.fromJson(json['aeternity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aeternity != null) {
      data['aeternity'] = this.aeternity.toJson();
    }
    return data;
  }
}

class Aeternity {
  double usd;
  double cny;

  Aeternity({this.usd,this.cny});

  Aeternity.fromJson(Map<String, dynamic> json) {
    usd = json['usd'];
    cny = json['cny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    data['cny'] = this.cny;
    return data;
  }
}