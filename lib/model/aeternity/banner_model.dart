class BannerModel {
  Cn? cn;
  Cn? en;

  BannerModel({this.cn, this.en});

  BannerModel.fromJson(Map<String, dynamic> json) {
    cn = json['cn'] != null ? new Cn.fromJson(json['cn']) : null;
    en = json['en'] != null ? new Cn.fromJson(json['en']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cn != null) {
      data['cn'] = this.cn!.toJson();
    }
    if (this.en != null) {
      data['en'] = this.en!.toJson();
    }
    return data;
  }
}

class Cn {
  String? image;
  String? title;
  String? url;

  Cn({this.image, this.title, this.url});

  Cn.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }
}
