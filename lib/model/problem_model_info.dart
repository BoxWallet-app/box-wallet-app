class ProblemInfoModel {
  int code;
  String msg;
  int time;
  Data data;

  ProblemInfoModel({this.code, this.msg, this.time, this.data});

  ProblemInfoModel.fromJson(Map<String, dynamic> json) {
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
  List<Answer> answer;
  String contentCn;
  String contentEn;
  String count;
  int createHeight;
  int createTime;
  int fee;
  int index;
  String minCount;
  int overTime;
  int result;
  String sourceUrl;
  int status;

  Data(
      {this.answer,
        this.contentCn,
        this.contentEn,
        this.count,
        this.createHeight,
        this.createTime,
        this.fee,
        this.index,
        this.minCount,
        this.overTime,
        this.result,
        this.sourceUrl,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['answer'] != null) {
      answer = new List<Answer>();
      json['answer'].forEach((v) {
        answer.add(new Answer.fromJson(v));
      });
    }
    contentCn = json['content_cn'];
    contentEn = json['content_en'];
    count = json['count'];
    createHeight = json['create_height'];
    createTime = json['create_time'];
    fee = json['fee'];
    index = json['index'];
    minCount = json['min_count'];
    overTime = json['over_time'];
    result = json['result'];
    sourceUrl = json['source_url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answer != null) {
      data['answer'] = this.answer.map((v) => v.toJson()).toList();
    }
    data['content_cn'] = this.contentCn;
    data['content_en'] = this.contentEn;
    data['count'] = this.count;
    data['create_height'] = this.createHeight;
    data['create_time'] = this.createTime;
    data['fee'] = this.fee;
    data['index'] = this.index;
    data['min_count'] = this.minCount;
    data['over_time'] = this.overTime;
    data['result'] = this.result;
    data['source_url'] = this.sourceUrl;
    data['status'] = this.status;
    return data;
  }
}

class Answer {
  List<String> accounts;
  String contentCn;
  String contentEn;
  int index;

  Answer({this.accounts, this.contentCn, this.contentEn,this.index});

  Answer.fromJson(Map<String, dynamic> json) {
    accounts = json['accounts'].cast<String>();
    contentCn = json['content_cn'];
    contentEn = json['content_en'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accounts'] = this.accounts;
    data['content_cn'] = this.contentCn;
    data['content_en'] = this.contentEn;
    data['index'] = this.index;
    return data;
  }
}