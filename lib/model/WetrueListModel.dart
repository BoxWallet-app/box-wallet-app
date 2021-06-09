class WetrueListModel {
  int code;
  Data data;
  String msg;

  WetrueListModel({this.code, this.data, this.msg});

  WetrueListModel.fromJson(Map<String, dynamic> json) {
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
  int page;
  int size;
  int totalPage;
  int totalSize;
  List<Data2> data;

  Data({this.page, this.size, this.totalPage, this.totalSize, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
    totalPage = json['totalPage'];
    totalSize = json['totalSize'];
    if (json['data'] != null) {
      data = new List<Data2>();
      json['data'].forEach((v) {
        data.add(new Data2.fromJson(v));
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
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data2 {
  String hash;
  String payload;
  String imgTx;
  String source;
  int utcTime;
  int praise;
  int star;
  int read;
  bool isPraise;
  bool isStar;
  bool isFocus;
  int commentNumber;
  Users users;

  Data2(
      {this.hash,
        this.payload,
        this.imgTx,
        this.utcTime,
        this.praise,
        this.star,
        this.source,
        this.read,
        this.isPraise,
        this.isStar,
        this.isFocus,
        this.commentNumber,
        this.users});

  Data2.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    payload = json['payload'];
    imgTx = json['imgTx'];
    utcTime = json['utcTime'];
    praise = json['praise'];
    star = json['star'];
    source = json['source'];
    read = json['read'];
    isPraise = json['isPraise'];
    isStar = json['isStar'];
    isFocus = json['isFocus'];
    commentNumber = json['commentNumber'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['payload'] = this.payload;
    data['imgTx'] = this.imgTx;
    data['utcTime'] = this.utcTime;
    data['praise'] = this.praise;
    data['star'] = this.star;
    data['source'] = this.source;
    data['read'] = this.read;
    data['isPraise'] = this.isPraise;
    data['isStar'] = this.isStar;
    data['isFocus'] = this.isFocus;
    data['commentNumber'] = this.commentNumber;
    if (this.users != null) {
      data['users'] = this.users.toJson();
    }
    return data;
  }
}

class Users {
  String userAddress;
  String nickname;
  int active;
  int userActive;
  String portrait;

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