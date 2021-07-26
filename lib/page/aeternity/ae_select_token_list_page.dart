import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/token_list_model.dart';
import 'package:box/page/aeternity/ae_token_add_page.dart';
import 'package:box/page/aeternity/ae_token_record_page.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import 'ae_home_page.dart';

typedef AeSelectTokenListCallBackFuture = Future Function(String tokenName, String tokenCount, String tokenImage, String tokenContract);

class AeSelectTokenListPage extends StatefulWidget {
  final String aeCount;
  final AeSelectTokenListCallBackFuture aeSelectTokenListCallBackFuture;

  const AeSelectTokenListPage({Key key, this.aeCount, this.aeSelectTokenListCallBackFuture}) : super(key: key);

  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<AeSelectTokenListPage> {
  var loadingType = LoadingType.loading;
  TokenListModel tokenListModel;
  PriceModel priceModel;

  Future<void> _onRefresh() async {
    TokenListDao.fetch(AeHomePage.address, "easy").then((TokenListModel model) {
      if (model != null || model.code == 200) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
        setState(() {});
      } else {
        tokenListModel = null;
        loadingType = LoadingType.error;
        setState(() {});
      }
      for (int i = 0; i < tokenListModel.data.length; i++) {
        netContractBalance(i);
      }
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(0),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          InkResponse(
              highlightColor: Colors.transparent,
              radius: 0.0,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: ShapeDecoration(
              // color: Color(0xffffffff),
              // color: Color(0xFFfafafa),
              color: Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 52,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 52,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            "选择积分",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 52,
                              width: 52,
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                Icons.close,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75 - 52,
                  child: LoadingWidget(
                    type: loadingType,
                    onPressedError: () {
                      _onRefresh();
                    },
                    child: EasyRefresh(
                      header: BoxHeader(),
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        itemCount: tokenListModel == null ? 0 : tokenListModel.data.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return itemListView(context, index);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void netContractBalance(int index) {
    ContractBalanceDao.fetch(tokenListModel.data[index].ctAddress).then((ContractBalanceModel model) {
      if (model.code == 200) {
        tokenListModel.data[index].countStr = model.data.balance;
        tokenListModel.data[index].rate = model.data.rate;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Widget itemListView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              if (widget.aeSelectTokenListCallBackFuture != null) {
                widget.aeSelectTokenListCallBackFuture("AE", widget.aeCount, "https://ae-source.oss-cn-hongkong.aliyuncs.com/ae.png", "");
              }
              Navigator.pop(context);
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width - 36,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 0, left: 15),
                          child: Row(
                            children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                      top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                      left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                      right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    "https://ae-source.oss-cn-hongkong.aliyuncs.com/ae.png",
                                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) return child;

                                      return AnimatedOpacity(
                                        child: child,
                                        opacity: frame == null ? 0 : 1,
                                        duration: const Duration(seconds: 2),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 18, right: 18),
                                child: Text(
                                  "AE",
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.aeCount,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 24, color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  ),
                                ],
                              ),

                              Container(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    index = index - 1;
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if(tokenListModel.data[index].countStr == null){
              EasyLoading.showToast('正在获取数量，请稍后', duration: Duration(seconds: 2));
              return;
            }
            if (widget.aeSelectTokenListCallBackFuture != null) {
              widget.aeSelectTokenListCallBackFuture(
                  tokenListModel.data[index].name, tokenListModel.data[index].countStr, tokenListModel.data[index].image, tokenListModel.data[index].ctAddress);
            }
            Navigator.pop(context);
          },
          child: Container(
            child: Row(
              children: [
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width - 36,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 15),
                        child: Row(
                          children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                    top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                    left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                    right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  tokenListModel.data[index].image,
                                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                    if (wasSynchronouslyLoaded) return child;

                                    return AnimatedOpacity(
                                      child: child,
                                      opacity: frame == null ? 0 : 1,
                                      duration: const Duration(seconds: 2),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 18, right: 18),
                              child: Text(
                                tokenListModel.data[index].name,
                                style: new TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            tokenListModel.data[index].countStr == null
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
                                      'images/loading.json',
//              'images/animation_khzuiqgg.json',
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        double.parse(tokenListModel.data[index].countStr).toStringAsFixed(2),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 24, color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ],
                                  ),

                            Container(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
