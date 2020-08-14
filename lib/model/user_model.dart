
class UserModel {
  int code;
  Data data;
  String msg;
  int time;

  UserModel({this.code, this.data, this.msg, this.time});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    data['time'] = this.time;
    return data;
  }
}

class Data {
  String address;
  String mnemonic;
  String redirectUri;
  String signingKey;

  Data({this.address, this.mnemonic, this.redirectUri, this.signingKey});

  Data.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    mnemonic = json['mnemonic'];
    redirectUri = json['redirectUri'];
    signingKey = json['signingKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['mnemonic'] = this.mnemonic;
    data['redirectUri'] = this.redirectUri;
    data['signingKey'] = this.signingKey;
    return data;
  }
}