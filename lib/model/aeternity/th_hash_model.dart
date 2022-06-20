class ThHashModel {
  int? code;
  String? msg;
  int? time;
  Data? data;

  ThHashModel({this.code, this.msg, this.time, this.data});

  ThHashModel.fromJson(Map<String, dynamic> json) {
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
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? blockHeight;

  Data({this.blockHeight});

  Data.fromJson(Map<String, dynamic> json) {
    blockHeight = json['block_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_height'] = this.blockHeight;
    return data;
  }
}