class ChainsModel {
  String? name;
  String? nameFull;
  String? nameFullCN;
  bool? isSelect = false;

  ChainsModel({this.name, this.nameFull,this.nameFullCN});

  ChainsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameFull = json['name_full'];
    nameFullCN = json['nameFullCN'];
    isSelect = json['is_select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nameFullCN'] = this.nameFullCN;
    data['is_select'] = this.isSelect;
    return data;
  }
}