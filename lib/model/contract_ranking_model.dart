class RankingModel {
    int code;
    String msg;
    int time;
    Data data;

    RankingModel({this.code, this.msg, this.time, this.data});

    RankingModel.fromJson(Map<String, dynamic> json) {
        code = json['code'];
        msg = json['msg'];
        time = json['time'];
        data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['code'] = this.code;
        data['msg'] = this.msg;
        data['time'] = this.time;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}

class Data {
    String outCount;
    List<Ranking> ranking;

    Data({this.outCount, this.ranking});

    Data.fromJson(Map<String, dynamic> json) {
        outCount = json['out_count'];
        if (json['ranking'] != null) {
            ranking = new List<Ranking>();
            json['ranking'].forEach((v) {
                ranking.add(new Ranking.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['out_count'] = this.outCount;
        if (this.ranking != null) {
            data['ranking'] = this.ranking.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Ranking {
    String address;
    String count;
    String outCount;
    String proportion;

    Ranking({this.address, this.count, this.outCount, this.proportion});

    Ranking.fromJson(Map<String, dynamic> json) {
        address = json['address'];
        count = json['count'];
        outCount = json['OutCount'];
        proportion = json['proportion'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['count'] = this.count;
        data['OutCount'] = this.outCount;
        data['proportion'] = this.proportion;
        return data;
    }
}
