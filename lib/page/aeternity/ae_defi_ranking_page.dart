import 'dart:ui';

import 'package:box/dao/aeternity/contract_ranking_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/contract_ranking_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../main.dart';

class AeDefiRankingPage extends StatefulWidget {
  @override
  _AeDefiRankingPageState createState() => _AeDefiRankingPageState();
}

class _AeDefiRankingPageState extends State<AeDefiRankingPage> {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  RankingModel rankingModel;
  int page = 1;
  var address = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: ClipRect(
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                height: 600,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    colors: [Color(0xff2453DF), Color(0xff2453DF), Color(0xff2453DF), Color(0xff2453DF), Color(0xff2453DF), Color(0xff2453DF), Colors.white],
                  ),
                ),
//                color: Color(0xff2453DF),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(right: 00),
              child: Column(
                children: [
                  Container(
                    child: Image(
                      width: 349,
                      height: 308,
                      image: AssetImage("images/ranking_logo.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 130,
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoxApp.language == "cn"
                      ? Container(
                    child: Image(
                      width: 144,
                      height: 48,
                      image: AssetImage("images/ranking_text.png"),
                    ),
                  )
                      : Container(
                    child: Text(
                      "Ranking",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 40, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Update Time: " + Utils.getCurrentDate(),
                      style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 310,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: getItemTitle(context),
            ),
          ),
          Positioned(
            top: 360,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 370,
              child: LoadingWidget(
                type: _loadingType,
                onPressedError: () {
                  setState(() {
                    _loadingType = LoadingType.loading;
                  });
                  _onRefresh();
                },
                child: EasyRefresh(
                  onRefresh: _onRefresh,
                  // header: MaterialHeader(
                  // valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
//          controller: _controller,
                  child: ListView.builder(
                    itemBuilder: buildColumn,
//            itemCount: 10,
                    itemCount: rankingModel == null ? 0 : rankingModel.data.ranking.length,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            child: ClipRect(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 50),
                alignment: Alignment.center,
                //边框设置
                decoration: new BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 5.0), //阴影xy轴偏移量
                        blurRadius: 10.0, //阴影模糊程度
                        spreadRadius: 0.5 //阴影扩散程度
                    )
                  ],
                ),

                width: MediaQuery
                    .of(context)
                    .size
                    .width - 20,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
//                        margin: EdgeInsets.only(top: 20, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              S
                                  .of(context)
                                  .defi_ranking_content,
                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              rankingModel == null ? "loading..." : rankingModel.data.outCount,
                              style: new TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: ClipRect(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQueryData
                          .fromWindow(window)
                          .padding
                          .top,
                    ),
                    Row(
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, int position) {
    return getItem(context, position);
  }

  Widget getItem(BuildContext context, int index) {
    return Container(
      color: index % 2 == 1 ? Colors.white : Color(0x66eeeeee),
      height: 50,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Container(
              alignment: Alignment.center,
              width: 30,
              child: getRankingIcon(index)

          ),
          Container(
            width: 15,
          ),
          Expanded(
            child: Container(
              child: Text(
                Utils.formatAddress(rankingModel.data.ranking[index].address),
                style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
              ),
            ),
          ),
          Container(
            child: Text(
              rankingModel.data.ranking[index].proportion + "%",
              style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
            ),
          ),
          Container(
            width: 10,
          ),
          Container(
            width: 130,
            alignment: Alignment.centerRight,
            child: Text(
              rankingModel.data.ranking[index].count,
              style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: missing_return
  Widget getRankingIcon(int index) {
    if (index == 0) {
      return Image(
          width: 30,
          height: 30,
          image: AssetImage("images/ranking_one.png"));
    }
    if (index == 1) {
      return Image(
          width: 30,
          height: 30,
          image: AssetImage("images/ranking_two.png"));
    }
    if (index == 2) {
      return Image(
          width: 30,
          height: 30,
          image: AssetImage("images/ranking_three.png"));
    }

    return Text(
      (index + 1).toString(),
      style: TextStyle(color: Colors.black.withAlpha(140), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    );
  }

  Widget getItemTitle(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Container(
            child: Text(
              S
                  .of(context)
                  .defi_raking_1,
              style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
            ),
          ),
          Container(
            width: 35,
          ),
          Expanded(
            child: Container(
              child: Text(
                S
                    .of(context)
                    .defi_raking_2,
                style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
              ),
            ),
          ),
          Container(
            child: Text(
              S
                  .of(context)
                  .defi_raking_3,
              style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
            ),
          ),
          Container(
            width: 10,
          ),
          Container(
            width: 130,
            alignment: Alignment.centerRight,
            child: Text(
              S
                  .of(context)
                  .defi_raking_4,
              style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      netData();
      setState(() {
        this.address = address;
      });
    });
  }

  Future<void> netData() async {
    page = 1;
    RankingModel model = await ContractRankingDao.fetch();
    if (!mounted) {
      return;
    }
    if (model.data == null) {
      return;
    }
    _loadingType = LoadingType.finish;
    if (page == 1) {
      rankingModel = model;
    } else {
      rankingModel.data.ranking.addAll(model.data.ranking);
    }
    setState(() {});
    if (rankingModel.data.ranking.length == 0) {
      _loadingType = LoadingType.no_data;
    }
    page++;

    if (rankingModel.data.ranking.length < 20) {
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
    EasyLoading.dismiss(animation: true);
  }

  Future<void> _onRefresh() async {
    page = 1;
    await netData();
  }
}
