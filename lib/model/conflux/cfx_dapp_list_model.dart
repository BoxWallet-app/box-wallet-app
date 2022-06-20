class DappListModel {
  int? code;
  String? msg;
  int? time;
  List<Data>? data;

  DappListModel({this.code, this.msg, this.time, this.data});

  DappListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? type;
  List<DataList>? dataList;

  Data({this.type, this.dataList});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['data_list'] != null) {
      dataList = <DataList>[];
      json['data_list'].forEach((v) {
        dataList!.add(new DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.dataList != null) {
      data['data_list'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  String? name;
  String? url;
  String? icon;
  String? content;
  List<String>? tabs;

  DataList({this.name, this.url, this.icon, this.content, this.tabs});

  DataList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    icon = json['icon'];
    content = json['content'];
    tabs = json['tabs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['icon'] = this.icon;
    data['content'] = this.content;
    data['tabs'] = this.tabs;
    return data;
  }
}
