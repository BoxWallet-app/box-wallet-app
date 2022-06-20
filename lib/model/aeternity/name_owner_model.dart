class NameOwnerModel {
  String? id;
  String? owner;
  List<Pointers>? pointers;
  int? ttl;

  NameOwnerModel({this.id, this.owner, this.pointers, this.ttl});

  NameOwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    if (json['pointers'] != null) {
      pointers = <Pointers>[];
      json['pointers'].forEach((v) {
        pointers!.add(new Pointers.fromJson(v));
      });
    }
    ttl = json['ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner'] = this.owner;
    if (this.pointers != null) {
      data['pointers'] = this.pointers!.map((v) => v.toJson()).toList();
    }
    data['ttl'] = this.ttl;
    return data;
  }
}

class Pointers {
  String? id;
  String? key;

  Pointers({this.id, this.key});

  Pointers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    return data;
  }
}