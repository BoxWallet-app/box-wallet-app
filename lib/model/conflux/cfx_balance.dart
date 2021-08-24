class CfxBalance {
  String address;
  String balance;
  String stakingBalance;
  String collateralForStorage;
  String accumulatedInterestReturn;
  String nonce;
  String admin;
  String codeHash;

  CfxBalance(
      {this.address,
        this.balance,
        this.stakingBalance,
        this.collateralForStorage,
        this.accumulatedInterestReturn,
        this.nonce,
        this.admin,
        this.codeHash});

  CfxBalance.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    balance = json['balance'];
    stakingBalance = json['stakingBalance'];
    collateralForStorage = json['collateralForStorage'];
    accumulatedInterestReturn = json['accumulatedInterestReturn'];
    nonce = json['nonce'];
    admin = json['admin'];
    codeHash = json['codeHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['balance'] = this.balance;
    data['stakingBalance'] = this.stakingBalance;
    data['collateralForStorage'] = this.collateralForStorage;
    data['accumulatedInterestReturn'] = this.accumulatedInterestReturn;
    data['nonce'] = this.nonce;
    data['admin'] = this.admin;
    data['codeHash'] = this.codeHash;
    return data;
  }
}
