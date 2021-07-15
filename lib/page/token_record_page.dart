import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/token_list_dao.dart';
import 'package:box/dao/token_record_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/token_list_model.dart';
import 'package:box/model/token_record_model.dart';
import 'package:box/page/token_add_page.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/page/token_tx_detail_page.dart';
import 'package:box/page/tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'home_page_v2.dart';

class TokenRecordPage extends StatefulWidget {
  final String ctId;
  final String coinName;
  final String coinImage;
  final String coinCount;

  const TokenRecordPage({Key key, this.ctId, this.coinName, this.coinCount, this.coinImage}) : super(key: key);

  @override
  _TokenRecordState createState() => _TokenRecordState();
}

class _TokenRecordState extends State<TokenRecordPage> {
  var loadingType = LoadingType.loading;
  TokenRecordModel tokenListModel;
  int page = 1;
  String count;
  EasyRefreshController _controller = EasyRefreshController();

  Future<void> _onRefresh() async {
    page = 1;
    netTokenRecord();
    netContractBalance();
  }

  Future<void> netTokenRecord() async {
    TokenRecordModel model = await TokenRecordDao.fetch(widget.ctId, page.toString());
    if (model != null || model.code == 200) {
      if (page == 1) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
      } else {
        tokenListModel.data.addAll(model.data);
        loadingType = LoadingType.finish;
      }
      _controller.finishRefresh();
      _controller.finishLoad();
      if (tokenListModel.data.length < 20) {
        _controller.finishLoad(noMore: true);
        _controller.finishLoad(success: true, noMore: true);
      }

      setState(() {});
    } else {
      tokenListModel = null;
      loadingType = LoadingType.error;
      setState(() {});
    }
  }

  Future<void> _onLoad() async {
    page++;
    await netTokenRecord();
  }

  void netContractBalance() {
    ContractBalanceDao.fetch(widget.ctId).then((ContractBalanceModel model) {
      if (model.code == 200) {
        count = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
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
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).home_page_transaction,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: EasyRefresh(
          header: BoxHeader(),
          onLoad: _onLoad,
          onRefresh: _onRefresh,
          footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
          controller: _controller,
          child: ListView.builder(
            itemCount: tokenListModel == null ? 1 : tokenListModel.data.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return itemHeaderView(context, index);
              } else {
                return itemView(context, index);
              }
            },
          ),
        ),
      ),
    );
  }

  Material itemHeaderView(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
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
                                width: 36.0,
                                height: 36.0,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    widget.coinImage,
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
                                  widget.coinName,
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              count == null
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
                                        'images/loading.json',
//              'images/animation_khzuiqgg.json',
                                      ),
                                    )
                                  : Text(
                                double.parse(count).toStringAsFixed(2),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 24, color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2 - 25,
                  margin: const EdgeInsets.only(top: 0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                    },
                    child: Text(
                     S.of(context).home_page_function_send,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                    ),
                    color: Color(0xFFF22B79).withAlpha(16),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                Container(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2 - 25,
                  margin: const EdgeInsets.only(top: 0),
                  child: FlatButton(
                    onPressed: () {
//                  goDefi(context);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                    },
                    child: Text(
                      S.of(context).home_page_function_receive,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                    ),
                    color: Color(0xFFF22B79).withAlpha(16),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 20,
              margin: EdgeInsets.only(top: 20),
              color: Color(0xFFfafbfc),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Material itemView(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          _launchURL("https://www.aeknow.org/block/transaction/" + tokenListModel.data[index - 1].hash);
        },
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 0, left: 0),
                          child: Row(
                            children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
//
//                          Container(
//                            width: 36.0,
//                            height: 36.0,
//                            decoration: BoxDecoration(
//                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                              borderRadius: BorderRadius.circular(30.0),
//                            ),
//                            child: ClipOval(
//                              child: Image.network(
//                                tokenListModel.data[index].image,
//                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
//                                  if (wasSynchronouslyLoaded) return child;
//
//                                  return AnimatedOpacity(
//                                    child: child,
//                                    opacity: frame == null ? 0 : 1,
//                                    duration: const Duration(seconds: 2),
//                                    curve: Curves.easeOut,
//                                  );
//                                },
//                              ),
//                            ),
//                          ),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                height: 30,
                                padding: EdgeInsets.all(6),
                                width: 30,
                                //边框设置
                                decoration: new BoxDecoration(
                                  //背景
                                  color: Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  //设置四周边框
                                  border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                ),
                                child: Image(
                                  width: 20,
                                  height: 20,
                                  color: tokenListModel.data[index - 1].aex9ReceiveAddress == HomePageV2.address ? Color(0xFFF22B79): Colors.green,
                                  image: tokenListModel.data[index - 1].aex9ReceiveAddress == HomePageV2.address ? AssetImage("images/token_send.png") : AssetImage("images/token_receive.png"),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Text(
                                      tokenListModel.data[index - 1].aex9ReceiveAddress == HomePageV2.address ? Utils.formatAddress(tokenListModel.data[index - 1].callAddress) : Utils.formatAddress(tokenListModel.data[index - 1].aex9ReceiveAddress),
                                      style: TextStyle(fontSize: 17, color: Color(0xff333333), fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 12, top: 8),
                                    child: Text(
                                      Utils.formatTime(tokenListModel.data[index - 1].createTime),
                                      style: TextStyle(fontSize: 13, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    tokenListModel.data[index - 1].aex9ReceiveAddress == HomePageV2.address ? "+ " +    double.parse(tokenListModel.data[index - 1].aex9Amount).toStringAsFixed(4) + " " + widget.coinName : "- " + double.parse(tokenListModel.data[index - 1].aex9Amount).toStringAsFixed(4) + " " + widget.coinName,
                                    style: TextStyle(fontSize: 17, color: tokenListModel.data[index - 1].aex9ReceiveAddress == HomePageV2.address ?Colors.black : Colors.black,  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  ),
                                  Container(
                                    height: 5,
                                    color: Color(0xFFfafbfc),
                                  ),
                                  Text(
                                    "- " + tokenListModel.data[index - 1].fee + " AE",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Color(0xFFfafbfc),
            ),
          ],
        ),
      ),
    );
  }
}
