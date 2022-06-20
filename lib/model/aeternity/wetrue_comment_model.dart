class WetrueCommentModel {
  int? code;
  Data? data;
  String? msg;

  WetrueCommentModel({this.code, this.data, this.msg});

  WetrueCommentModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  int? page;
  int? size;
  int? totalPage;
  int? totalSize;
  List<Data2>? data;

  Data({this.page, this.size, this.totalPage, this.totalSize, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
    totalPage = json['totalPage'];
    totalSize = json['totalSize'];
    if (json['data'] != null) {
      data = <Data2>[];
      json['data'].forEach((v) {
        data!.add(new Data2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['size'] = this.size;
    data['totalPage'] = this.totalPage;
    data['totalSize'] = this.totalSize;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data2 {
  String? hash;
  String? toHash;
  String? payload;
  int? utcTime;
  int? replyNumber;
  int? praise;
  bool? isPraise;
  Users? users;
  List<CommentList>? commentList;

  Data2(
      {this.hash,
        this.toHash,
        this.payload,
        this.utcTime,
        this.replyNumber,
        this.praise,
        this.isPraise,
        this.users,
        this.commentList});

  Data2.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    toHash = json['toHash'];
    payload = json['payload'];
    utcTime = json['utcTime'];
    replyNumber = json['replyNumber'];
    praise = json['praise'];
    isPraise = json['isPraise'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    if (json['commentList'] != null) {
      commentList = <CommentList>[];
      json['commentList'].forEach((v) {
        commentList!.add(new CommentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['toHash'] = this.toHash;
    data['payload'] = this.payload;
    data['utcTime'] = this.utcTime;
    data['replyNumber'] = this.replyNumber;
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    if (this.commentList != null) {
      data['commentList'] = this.commentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? userAddress;
  String? nickname;
  int? active;
  int? userActive;
  String? portrait;

  Users(
      {this.userAddress,
        this.nickname,
        this.active,
        this.userActive,
        this.portrait});

  Users.fromJson(Map<String, dynamic> json) {
    userAddress = json['userAddress'];
    nickname = json['nickname'];
    active = json['active'];
    userActive = json['userActive'];
    portrait = json['portrait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userAddress'] = this.userAddress;
    data['nickname'] = this.nickname;
    data['active'] = this.active;
    data['userActive'] = this.userActive;
    data['portrait'] = this.portrait;
    return data;
  }
}

class CommentList {
  String? hash;
  String? toHash;
  String? replyType;
  String? replyHash;
  String? payload;
  String? senderId;
  String? toAddress;
  String? receiverName;
  int? utcTime;
  int? praise;
  bool? isPraise;
  Users? users;

  CommentList(
      {this.hash,
        this.toHash,
        this.replyType,
        this.replyHash,
        this.payload,
        this.senderId,
        this.toAddress,
        this.receiverName,
        this.utcTime,
        this.praise,
        this.isPraise,
        this.users});

  CommentList.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    toHash = json['toHash'];
    replyType = json['replyType'];
    replyHash = json['replyHash'];
    payload = json['payload'];
    senderId = json['senderId'];
    toAddress = json['toAddress'];
    receiverName = json['receiverName'];
    utcTime = json['utcTime'];
    praise = json['praise'];
    isPraise = json['isPraise'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['toHash'] = this.toHash;
    data['replyType'] = this.replyType;
    data['replyHash'] = this.replyHash;
    data['payload'] = this.payload;
    data['senderId'] = this.senderId;
    data['toAddress'] = this.toAddress;
    data['receiverName'] = this.receiverName;
    data['utcTime'] = this.utcTime;
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

