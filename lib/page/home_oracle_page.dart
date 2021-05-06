import 'dart:io';
import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/name_reverse_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/problem_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/name_reverse_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/problem_model.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/setting_page_v2.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'home_oracle_detail_page.dart';

class HomeOraclePage extends StatefulWidget {
  @override
  _HomeOraclePageState createState() => _HomeOraclePageState();
}

class _HomeOraclePageState extends State<HomeOraclePage> with AutomaticKeepAliveClientMixin {
  DateTime lastPopTime;
  PriceModel priceModel;
  List<NameReverseModel> namesModel;
  ProblemModel problemModel;
  LoadingType _loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    netNameReverseData();
    netBaseData();
    netAccountInfo();
    getAddress();
    netProblem();
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      HomePageV2.address = address;
      setState(() {});
    });
  }

  void netBaseData() {
    var type = "usd";
//    if (BoxApp.language == "cn") {
//      type = "cny";
//    } else {
//      type = "usd";
//    }
    PriceDao.fetch(type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netProblem() {
    ProblemDao.fetch("").then((ProblemModel model) {
      if (model != null && model.data != null) {
        problemModel = model;
        _loadingType = LoadingType.finish;
        setState(() {});
      } else {}
    }).catchError((e) {
      _loadingType = LoadingType.error;
      setState(() {});
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netNameReverseData() {
    NameReverseDao.fetch().then((List<NameReverseModel> model) {
      if (model.isNotEmpty) {
        if (model.isNotEmpty) {
          model.sort((left, right) => right.expiresAt.compareTo(left.expiresAt));
        }
        namesModel = model;
        setState(() {});
      } else {}
    }).catchError((e) {
//      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice() {
    if (HomePageV2.token == "loading...") {
      return "";
    }
    if (priceModel.aeternity.usd == null) {
      return "";
    }
    return " \$" + (priceModel.aeternity.usd * double.parse(HomePageV2.token)).toStringAsFixed(2) + " ≈ ";
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        // HomePage.token = "8888.88888";
        HomePageV2.token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Widget buildColumn(BuildContext context, int position) {
    return listItem(context, position);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "再按一次退出", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            exit(0);
          }
        },

        child: Scaffold(
          backgroundColor: Color(0xff303749),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 100),
                width: MediaQuery.of(context).size.width,
                child: LoadingWidget(
                  type: _loadingType,
                  onPressedError: () {
                    _onRefresh();
                    return;
                  },
                  child: EasyRefresh(
                    header: AEHeader(),
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      itemBuilder: buildColumn,
                      itemCount: problemModel == null ? 0 : problemModel.data.length,
                    ),
                  ),
                ),
              ),
              Container(
                color: Color(0xff242A37),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "ONGOING",
                                  style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white, letterSpacing: 1.2, height: 1.4),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 50,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "FINISH",
                                  style: new TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white, letterSpacing: 1.2, height: 1.4),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 16, right: 16, top: 50),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "The ongoing Oracles Tournament",
                        style: TextStyle(
                          color: Color(0xFFffffff),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: BoxApp.language == "cn"
                              ? "Ubuntu"
                              : BoxApp.language == "cn"
                                  ? "Ubuntu"
                                  : "Ubuntu",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    netNameReverseData();
    netBaseData();
    netAccountInfo();
    getAddress();
    netProblem();
  }

  Widget listItem(BuildContext context, int index) {
//    return Text("123");
    List<Widget> items = [];
    problemModel.data[index].answer.forEach((element) {
      var container = Container(
        height: 40,
        margin: EdgeInsets.only(top: 14),
        width: (MediaQuery.of(context).size.width - 32) * 0.85,
        child: FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOracleDetailPage(id: problemModel.data[index].index - 1)));
          },
          child: Text(
            element.contentEn,
            maxLines: 1,
            style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665)),
          ),
          color: Color(0xFFE61665).withAlpha(46),
          textColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      items.add(container);
    });
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xff242A37),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOracleDetailPage(id: problemModel.data[index].index - 1)));
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 16,
                    ),
                    Text(
                      "#" + problemModel.data[index].index.toString(),
                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665), letterSpacing: 1.2, height: 1.4),
                    ),
                    Container(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        problemModel.data[index].contentEn,
                        style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white, letterSpacing: 1.2, height: 1.4),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              Column(
                children: items,
              ),
              Container(
                margin: EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 10),
                child: Text(
                  "Deadline: " + Utils.formatTime(problemModel.data[index].overTime),
                  style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, left: 10, bottom: 16),
                child: Text(
                  problemModel.data[index].sourceUrl,
                  style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF4299e1)),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 32),
                //边框设置
                decoration: new BoxDecoration(
                  color: Colors.green,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
