class VersionModel {
  int code;
  String msg;
  String time;
  Data data;

  VersionModel({this.code, this.msg, this.time, this.data});

  VersionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String isMandatory;
  String urlAndroid;
  String urlIos;
  String version;

  Data({this.isMandatory, this.urlAndroid, this.urlIos, this.version});

  Data.fromJson(Map<String, dynamic> json) {
    isMandatory = json['is_mandatory'];
    urlAndroid = json['url_android'];
    urlIos = json['url_ios'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_mandatory'] = this.isMandatory;
    data['url_android'] = this.urlAndroid;
    data['url_ios'] = this.urlIos;
    data['version'] = this.version;
    return data;
  }
}