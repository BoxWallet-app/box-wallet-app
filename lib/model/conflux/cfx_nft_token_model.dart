class CfxNftTokenModel {
  int code;
  List<dynamic> data;

  CfxNftTokenModel({this.code, this.data});

  CfxNftTokenModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}
