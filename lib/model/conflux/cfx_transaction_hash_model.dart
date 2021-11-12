class CfxTransactionHashModel {
  String nonce;
  String value;
  String gasPrice;
  String gas;
  int v;
  int transactionIndex;
  int status;
  String storageLimit;
  int chainId;
  int epochHeight;
  String blockHash;
  String data;
  String from;
  String hash;
  String r;
  String s;
  String to;
  int epochNumber;
  double risk;
  int timestamp;
  int syncTimestamp;
  String gasUsed;
  String gasFee;
  String storageCollateralized;
  bool gasCoveredBySponsor;
  bool storageCoveredBySponsor;
  int confirmedEpochCount;
  int eventLogCount;

  CfxTransactionHashModel(
      {this.nonce,
        this.value,
        this.gasPrice,
        this.gas,
        this.v,
        this.transactionIndex,
        this.status,
        this.storageLimit,
        this.chainId,
        this.epochHeight,
        this.blockHash,
        this.data,
        this.from,
        this.hash,
        this.r,
        this.s,
        this.to,
        this.epochNumber,
        this.risk,
        this.timestamp,
        this.syncTimestamp,
        this.gasUsed,
        this.gasFee,
        this.storageCollateralized,
        this.gasCoveredBySponsor,
        this.storageCoveredBySponsor,
        this.confirmedEpochCount,
        this.eventLogCount});

  CfxTransactionHashModel.fromJson(Map<String, dynamic> json) {
    nonce = json['nonce'];
    value = json['value'];
    gasPrice = json['gasPrice'];
    gas = json['gas'];
    v = json['v'];
    transactionIndex = json['transactionIndex'];
    status = json['status'];
    storageLimit = json['storageLimit'];
    chainId = json['chainId'];
    epochHeight = json['epochHeight'];
    blockHash = json['blockHash'];
    data = json['data'];
    from = json['from'];
    hash = json['hash'];
    r = json['r'];
    s = json['s'];
    to = json['to'];
    epochNumber = json['epochNumber'];
    risk = json['risk'];
    timestamp = json['timestamp'];
    syncTimestamp = json['syncTimestamp'];
    gasUsed = json['gasUsed'];
    gasFee = json['gasFee'];
    storageCollateralized = json['storageCollateralized'];
    gasCoveredBySponsor = json['gasCoveredBySponsor'];
    storageCoveredBySponsor = json['storageCoveredBySponsor'];
    confirmedEpochCount = json['confirmedEpochCount'];
    eventLogCount = json['eventLogCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nonce'] = this.nonce;
    data['value'] = this.value;
    data['gasPrice'] = this.gasPrice;
    data['gas'] = this.gas;
    data['v'] = this.v;
    data['transactionIndex'] = this.transactionIndex;
    data['status'] = this.status;
    data['storageLimit'] = this.storageLimit;
    data['chainId'] = this.chainId;
    data['epochHeight'] = this.epochHeight;
    data['blockHash'] = this.blockHash;
    data['data'] = this.data;
    data['from'] = this.from;
    data['hash'] = this.hash;
    data['r'] = this.r;
    data['s'] = this.s;
    data['to'] = this.to;
    data['epochNumber'] = this.epochNumber;
    data['risk'] = this.risk;
    data['timestamp'] = this.timestamp;
    data['syncTimestamp'] = this.syncTimestamp;
    data['gasUsed'] = this.gasUsed;
    data['gasFee'] = this.gasFee;
    data['storageCollateralized'] = this.storageCollateralized;
    data['gasCoveredBySponsor'] = this.gasCoveredBySponsor;
    data['storageCoveredBySponsor'] = this.storageCoveredBySponsor;
    data['confirmedEpochCount'] = this.confirmedEpochCount;
    data['eventLogCount'] = this.eventLogCount;
    return data;
  }
}