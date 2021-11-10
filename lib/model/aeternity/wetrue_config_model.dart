class WeTrueConfigModel {
  int code;
  String msg;
  Data data;

  WeTrueConfigModel({this.code, this.msg, this.data});

  WeTrueConfigModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String weTrue;
  String requireVersion;
  String topicAmount;
  String commentAmount;
  String replyAmount;
  String nicknameAmount;
  String sexAmount;
  String portraitAmount;
  String openMapAmount;
  String openMapAddress;
  String receivingAccount;
  int contentActive;
  int commentActive;
  int praiseActive;
  int nicknameActive;
  int portraitActive;
  int complainActive;
  String frontEndUrl;

  Data(
      {this.weTrue,
        this.requireVersion,
        this.topicAmount,
        this.commentAmount,
        this.replyAmount,
        this.nicknameAmount,
        this.sexAmount,
        this.portraitAmount,
        this.openMapAmount,
        this.openMapAddress,
        this.receivingAccount,
        this.contentActive,
        this.commentActive,
        this.praiseActive,
        this.nicknameActive,
        this.portraitActive,
        this.complainActive,
        this.frontEndUrl});

  Data.fromJson(Map<String, dynamic> json) {
    weTrue = json['WeTrue'];
    requireVersion = json['requireVersion'];
    topicAmount = json['topicAmount'];
    commentAmount = json['commentAmount'];
    replyAmount = json['replyAmount'];
    nicknameAmount = json['nicknameAmount'];
    sexAmount = json['sexAmount'];
    portraitAmount = json['portraitAmount'];
    openMapAmount = json['openMapAmount'];
    openMapAddress = json['openMapAddress'];
    receivingAccount = json['receivingAccount'];
    contentActive = json['contentActive'];
    commentActive = json['commentActive'];
    praiseActive = json['praiseActive'];
    nicknameActive = json['nicknameActive'];
    portraitActive = json['portraitActive'];
    complainActive = json['complainActive'];
    frontEndUrl = json['frontEndUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WeTrue'] = this.weTrue;
    data['requireVersion'] = this.requireVersion;
    data['topicAmount'] = this.topicAmount;
    data['commentAmount'] = this.commentAmount;
    data['replyAmount'] = this.replyAmount;
    data['nicknameAmount'] = this.nicknameAmount;
    data['sexAmount'] = this.sexAmount;
    data['portraitAmount'] = this.portraitAmount;
    data['openMapAmount'] = this.openMapAmount;
    data['openMapAddress'] = this.openMapAddress;
    data['receivingAccount'] = this.receivingAccount;
    data['contentActive'] = this.contentActive;
    data['commentActive'] = this.commentActive;
    data['praiseActive'] = this.praiseActive;
    data['nicknameActive'] = this.nicknameActive;
    data['portraitActive'] = this.portraitActive;
    data['complainActive'] = this.complainActive;
    data['frontEndUrl'] = this.frontEndUrl;
    return data;
  }
}
