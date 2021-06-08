class WeTrueConfigModel {
  int code;
  Data data;
  String msg;

  WeTrueConfigModel({this.code, this.data, this.msg});

  WeTrueConfigModel.fromJson(Map<String, dynamic> json) {
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
  String weTrue;
  String requireVersion;
  int topicAmount;
  int commentAmount;
  int replyAmount;
  int nicknameAmount;
  int portraitAmount;
  String receivingAccount;
  int contentActive;
  int commentActive;
  int praiseActive;
  int nicknameActive;
  int portraitActive;
  int complainActive;

  Data(
      {this.weTrue,
        this.requireVersion,
        this.topicAmount,
        this.commentAmount,
        this.replyAmount,
        this.nicknameAmount,
        this.portraitAmount,
        this.receivingAccount,
        this.contentActive,
        this.commentActive,
        this.praiseActive,
        this.nicknameActive,
        this.portraitActive,
        this.complainActive});

  Data.fromJson(Map<String, dynamic> json) {
    weTrue = json['WeTrue'];
    requireVersion = json['requireVersion'];
    topicAmount = json['topicAmount'];
    commentAmount = json['commentAmount'];
    replyAmount = json['replyAmount'];
    nicknameAmount = json['nicknameAmount'];
    portraitAmount = json['portraitAmount'];
    receivingAccount = json['receivingAccount'];
    contentActive = json['contentActive'];
    commentActive = json['commentActive'];
    praiseActive = json['praiseActive'];
    nicknameActive = json['nicknameActive'];
    portraitActive = json['portraitActive'];
    complainActive = json['complainActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WeTrue'] = this.weTrue;
    data['requireVersion'] = this.requireVersion;
    data['topicAmount'] = this.topicAmount;
    data['commentAmount'] = this.commentAmount;
    data['replyAmount'] = this.replyAmount;
    data['nicknameAmount'] = this.nicknameAmount;
    data['portraitAmount'] = this.portraitAmount;
    data['receivingAccount'] = this.receivingAccount;
    data['contentActive'] = this.contentActive;
    data['commentActive'] = this.commentActive;
    data['praiseActive'] = this.praiseActive;
    data['nicknameActive'] = this.nicknameActive;
    data['portraitActive'] = this.portraitActive;
    data['complainActive'] = this.complainActive;
    return data;
  }
}