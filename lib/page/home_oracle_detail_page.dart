import 'dart:io';
import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/name_reverse_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/problem_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/name_reverse_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/problem_model_info.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/setting_page_v2.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class HomeOracleDetailPage extends StatefulWidget {
  final int id;

  const HomeOracleDetailPage({Key key, this.id}) : super(key: key);

  @override
  _HomeOracleDetailPageState createState() => _HomeOracleDetailPageState();
}

class _HomeOracleDetailPageState extends State<HomeOracleDetailPage> with AutomaticKeepAliveClientMixin {
  DateTime lastPopTime;
  PriceModel priceModel;
  List<NameReverseModel> namesModel;
  ProblemInfoModel problemInfoModel;
  LoadingType loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
//    netNameReverseData();
//    netBaseData();
//    netAccountInfo();
    netProblemInfo();
    getAddress();
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      HomePageV2.address = address;
      setState(() {});
    });
  }

  Future<void> netSubmitAnswer(BuildContext context, String problemIndex, String answerIndex) async {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              // ignore: missing_return
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var signingKey = await BoxApp.getSigningKey();
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  var aesDecode = Utils.aesDecode(signingKey, key);

                  if (aesDecode == "") {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(S.of(context).dialog_hint_check_error_content),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  // ignore: missing_return
                  BoxApp.submitAnswer((tx) {
                    showPlatformDialog(
                      androidBarrierDismissible: false,
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () async => false,
                        child: BasicDialogAlert(
                          content: Text(
                            "Betting on success",
                          ),
                          actions: <Widget>[
                            BasicDialogAction(
                              title: Text(
                                S.of(context).dialog_conform,
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                                loadingType = LoadingType.loading;
                                setState(() {

                                });
                                netProblemInfo();
                              },
                            ),
                          ],
                        ),
                      ),
                    );

                    // ignore: missing_return
                  }, (error) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );

                    // ignore: missing_return
                  }, aesDecode, address, "ct_22mvCVphg3ipN856sANq27zDkFt4tAUzeCB1w8PLrM8xoBNGvM", problemIndex, answerIndex, problemInfoModel.data.minCount);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
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

  void netProblemInfo() {
    ProblemInfoDao.fetch(widget.id).then((ProblemInfoModel model) {
      if (model.code == 200) {
        problemInfoModel = model;
        loadingType = LoadingType.finish;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
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

  Future<void> _onRefresh() async {
    netProblemInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xff20242F),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff20242F),
          // 隐藏阴影
          leading: BoxApp.isOpenStore
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 17,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
          title: Text(
            "Oracle Detail",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            LoadingWidget(
              type: loadingType,
              child: EasyRefresh(
                onRefresh: _onRefresh,
                header: AEHeader(),
                child: problemInfoModel == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 0),
                              child: Material(
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                                color: Color(0xff242A37),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 16,
                                      ),
                                      Container(
                                        child: Text(
                                          problemInfoModel.data.count + " AE",
                                          style: new TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665), letterSpacing: 1.2, height: 1.4),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 16),
                                        child: Text(
                                          "The total vote",
                                          style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
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
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 10),
                              child: Material(
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                                color: Color(0xff242A37),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 16,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 16,
                                          ),
                                          Text(
                                            "#" + problemInfoModel.data.index.toString(),
                                            style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFE61665), letterSpacing: 1.2, height: 1.4),
                                          ),
                                          Container(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Text(
                                              problemInfoModel.data.contentEn,
                                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white, letterSpacing: 1.2, height: 1.4),
                                            ),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      Column(
                                        children: buildItem(context),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 10),
                                        child: Text(
                                          "Deadline: " + Utils.formatTime(problemInfoModel.data.overTime),
                                          style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10, left: 10, bottom: 16),
                                        child: Text(
                                          problemInfoModel.data.sourceUrl,
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
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 16),
                              child: Text(
                                "To play a: " + problemInfoModel.data.minCount + "AE",
                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                              ),
                            ),
                            Container(
                              height: MediaQueryData.fromWindow(window).padding.bottom + 20,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildItem(BuildContext context) {
    List<Widget> items = [];
    problemInfoModel.data.answer.forEach((element) {
      var container = Container(
        height: 40,
        margin: EdgeInsets.only(top: 14),
        width: (MediaQuery.of(context).size.width - 32) * 0.85,
        child: FlatButton(
          onPressed: () {
            netSubmitAnswer(context, (problemInfoModel.data.index - 1).toString(), element.index.toString());
            print(element.contentCn);
          },
          child: Text(
            element.contentEn + " (" + element.accounts.length.toString() + ")",
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
    return items;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
