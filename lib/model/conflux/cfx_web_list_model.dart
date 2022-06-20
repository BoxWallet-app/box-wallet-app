class CfxWebListModel {
  int? code;
  String? msg;
  int? time;
  List<CfxWebListModelData>? data;

  CfxWebListModel({this.code, this.msg, this.time, this.data});

  CfxWebListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = <CfxWebListModelData>[];
      json['data'].forEach((v) {
        data!.add(new CfxWebListModelData.fromJson(v));
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

class CfxWebListModelData {
  String? nameCn;
  String? nameEn;
  String? url;

  CfxWebListModelData({this.nameCn, this.nameEn, this.url});

  CfxWebListModelData.fromJson(Map<String, dynamic> json) {
    nameCn = json['name_cn'];
    nameEn = json['name_en'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_cn'] = this.nameCn;
    data['name_en'] = this.nameEn;
    data['url'] = this.url;
    return data;
  }
}
