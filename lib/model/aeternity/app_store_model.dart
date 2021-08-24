class AppStoreModel {
  int code;
  String msg;
  int time;
  Data data;

  AppStoreModel({this.code, this.msg, this.time, this.data});

  AppStoreModel.fromJson(Map<String, dynamic> json) {
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
  bool isOpen;
  String version;
  bool nextOpen;

  Data({this.isOpen, this.version, this.nextOpen});

  Data.fromJson(Map<String, dynamic> json) {
    isOpen = json['is_open'];
    version = json['version'];
    nextOpen = json['next_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_open'] = this.isOpen;
    data['version'] = this.version;
    data['next_open'] = this.nextOpen;
    return data;
  }
}