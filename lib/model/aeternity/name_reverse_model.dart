class NameReverseModel {
  String name;
  String nameHash;
  String txHash;
  int createdAtHeight;
  int auctionEndHeight;
  String owner;
  int expiresAt;
  List<Pointers> pointers;

  NameReverseModel(
      {this.name,
        this.nameHash,
        this.txHash,
        this.createdAtHeight,
        this.auctionEndHeight,
        this.owner,
        this.expiresAt,
        this.pointers});

  NameReverseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameHash = json['name_hash'];
    txHash = json['tx_hash'];
    createdAtHeight = json['created_at_height'];
    auctionEndHeight = json['auction_end_height'];
    owner = json['owner'];
    expiresAt = json['expires_at'];
    if (json['pointers'] != null) {
      pointers = new List<Pointers>();
      json['pointers'].forEach((v) {
        pointers.add(new Pointers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_hash'] = this.nameHash;
    data['tx_hash'] = this.txHash;
    data['created_at_height'] = this.createdAtHeight;
    data['auction_end_height'] = this.auctionEndHeight;
    data['owner'] = this.owner;
    data['expires_at'] = this.expiresAt;
    if (this.pointers != null) {
      data['pointers'] = this.pointers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pointers {
  String id;
  String key;

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