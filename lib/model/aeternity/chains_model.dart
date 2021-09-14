class ChainsModel {
  String name;
  String nameFull;
  bool isSelect = false;

  ChainsModel({this.name, this.nameFull});

  ChainsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameFull = json['name_full'];
    isSelect = json['is_select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['is_select'] = this.isSelect;
    return data;
  }
}