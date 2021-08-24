class ChainsModel {
  String name;
  String nameFull;

  ChainsModel({this.name, this.nameFull});

  ChainsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameFull = json['name_full'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_full'] = this.nameFull;
    return data;
  }
}