class WeTruePraiseModel {
  int code;
  Data data;
  String msg;

  WeTruePraiseModel({this.code, this.data, this.msg});

  WeTruePraiseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  int praise;
  bool isPraise;

  Data({this.praise, this.isPraise});

  Data.fromJson(Map<String, dynamic> json) {
    praise = json['praise'];
    isPraise = json['isPraise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    return data;
  }
}