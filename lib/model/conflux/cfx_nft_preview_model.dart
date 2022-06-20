class CfxNftPreviewModel {
  int? code;
  Data? data;

  CfxNftPreviewModel({this.code, this.data});

  CfxNftPreviewModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? imageMinHeight;
  String? imageUri;
  ImageName? imageName;

  Data({this.imageMinHeight, this.imageUri, this.imageName});

  Data.fromJson(Map<String, dynamic> json) {
    imageMinHeight = json['imageMinHeight'];
    imageUri = json['imageUri'];
    imageName = json['imageName'] != null
        ? new ImageName.fromJson(json['imageName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageMinHeight'] = this.imageMinHeight;
    data['imageUri'] = this.imageUri;
    if (this.imageName != null) {
      data['imageName'] = this.imageName!.toJson();
    }
    return data;
  }
}

class ImageName {
  String? zh;
  String? en;

  ImageName({this.zh, this.en});

  ImageName.fromJson(Map<String, dynamic> json) {
    zh = json['zh'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zh'] = this.zh;
    data['en'] = this.en;
    return data;
  }
}
