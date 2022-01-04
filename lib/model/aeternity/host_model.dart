class HostModel {
  String baseUrl;

  HostModel({this.baseUrl});

  HostModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_url'] = this.baseUrl;
    return data;
  }
}
