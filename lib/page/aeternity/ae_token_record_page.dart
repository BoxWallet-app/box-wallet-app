import 'dart:convert';
import 'dart:io';

import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/token_record_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/token_record_model.dart';
import 'package:box/page/aeternity/ae_token_receive_page.dart';
import 'package:box/page/aeternity/ae_token_send_one_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../manager/data_center_manager.dart';
import '../../manager/wallet_coins_manager.dart';
import '../../model/aeternity/wallet_coins_model.dart';
import 'ae_home_page.dart';

class AeTokenRecordPage extends BaseWidget {
  final String? ctId;
  final String? coinName;
  final String? coinImage;
  String? coinCount;

  AeTokenRecordPage({Key? key, this.ctId, this.coinName, this.coinCount, this.coinImage});

  @override
  _TokenRecordState createState() => _TokenRecordState();
}

class _TokenRecordState extends BaseWidgetState<AeTokenRecordPage> {
  var loadingType = LoadingType.finish;
  TokenRecordModel? tokenListModel;
  int page = 1;
  String? count;
  EasyRefreshController _controller = EasyRefreshController();

  late Map tokenInfos;
  bool isTokenInfosLoading = true;
  Future<void> getTokenInfo() async {
    tokenInfos = DataCenterManager.tokenInfos;
    if (tokenInfos.isEmpty) {
      tokenInfos = await DataCenterManager.instance.netTokenInfos();
    }

    isTokenInfosLoading = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    await getTokenInfo();
    await netContractBalance();
  }

  Future<void> netContractBalance() async {
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var params = {
      "name": "aeAex9TokenBalance",
      "params": {"ctAddress": widget.ctId, "address": account!.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      var address = jsonResponse["result"]["address"];
      var ctAddress = jsonResponse["result"]["ctAddress"].toString();

      if (!mounted) return;
      if (ctAddress != widget.ctId!) return;

      count = AmountDecimal.parseDecimal(balance);
      // loadingType = LoadingType.finish;
      setState(() {});

      return;
    }, channelJson);
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
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
          onRefresh: _onRefresh,
          footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
          controller: _controller,
          child: ListView.builder(
            itemCount: tokenListModel == null ? 1 : tokenListModel!.data!.length + 1,
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

  Widget itemHeaderView(BuildContext context, int index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          height: 80,
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
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          widget.coinImage!,
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
                                      padding: const EdgeInsets.only(left: 15, right: 15),
                                      child: Text(
                                        widget.coinName!,
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
                                            count!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                        width: MediaQuery.of(context).size.width / 2 - 25 - 18,
                        margin: const EdgeInsets.only(top: 0),
                        child: FlatButton(
                          onPressed: () {
                            if (Platform.isIOS) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AeTokenSendOnePage(
                                            tokenName: widget.coinName,
                                            tokenCount: count,
                                            tokenImage: widget.coinImage,
                                            tokenContract: widget.ctId,
                                          )));
                            } else {
                              Navigator.push(
                                  context,
                                  SlideRoute(AeTokenSendOnePage(
                                    tokenName: widget.coinName,
                                    tokenCount: count,
                                    tokenImage: widget.coinImage,
                                    tokenContract: widget.ctId,
                                  )));
                            }
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
                        width: MediaQuery.of(context).size.width / 2 - 25 - 18,
                        margin: const EdgeInsets.only(top: 0),
                        child: FlatButton(
                          onPressed: () {
//                  goDefi(context);
                            if (Platform.isIOS) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                            } else {
                              Navigator.push(context, SlideRoute(TokenReceivePage()));
                            }
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
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 18, right: 0, top: 12, bottom: 0),
          alignment: Alignment.centerLeft,
          child: Text(
            "Token Info",
            style: TextStyle(
              color: Color(0xFF000000),
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
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 12),
          padding: EdgeInsets.only(bottom: 18),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          width: MediaQuery.of(context).size.width - 36,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 0, left: 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "ContractId",
                                        style: new TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff333333),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 0, left: 20),
                                        child: Text(
                                          widget.ctId.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 16, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25, left: 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Name",
                                        style: new TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff333333),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    if (!isTokenInfosLoading)
                                      Text(
                                        tokenInfos[widget.ctId.toString()]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25, left: 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Symbol",
                                        style: new TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff333333),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    if (!isTokenInfosLoading)
                                      Text(
                                        tokenInfos[widget.ctId.toString()]['symbol'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25, left: 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Decimals",
                                        style: new TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff333333),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    if (!isTokenInfosLoading)
                                      Text(
                                        tokenInfos[widget.ctId.toString()]['decimals'].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget itemView(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            _launchURL("https://www.aeknow.org/block/transaction/" + tokenListModel!.data![index - 1].hash!);
          },
          child: Column(
            children: [
              Container(
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
                                    width: 25,
                                    height: 25,
                                    color: tokenListModel!.data![index - 1].aex9ReceiveAddress == AeHomePage.address ? Color(0xFFF22B79) : Colors.green,
                                    image: tokenListModel!.data![index - 1].aex9ReceiveAddress == AeHomePage.address ? AssetImage("images/token_receive.png") : AssetImage("images/token_send.png"),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        tokenListModel!.data![index - 1].aex9ReceiveAddress == AeHomePage.address ? Utils.formatAddress(tokenListModel!.data![index - 1].callAddress) : Utils.formatAddress(tokenListModel!.data![index - 1].aex9ReceiveAddress),
                                        style: TextStyle(fontSize: 15, color: Color(0xff333333), fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 12, top: 8),
                                      child: Text(
                                        Utils.formatTime(tokenListModel!.data![index - 1].createTime),
                                        style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                                      tokenListModel!.data![index - 1].aex9ReceiveAddress == AeHomePage.address ? "+ " + double.parse(tokenListModel!.data![index - 1].aex9Amount!).toStringAsFixed(2) + " " + widget.coinName! : "- " + double.parse(tokenListModel!.data![index - 1].aex9Amount!).toStringAsFixed(2) + " " + widget.coinName!,
                                      style: TextStyle(fontSize: 15, color: tokenListModel!.data![index - 1].aex9ReceiveAddress == AeHomePage.address ? Colors.black : Colors.black, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
                                    Container(
                                      height: 5,
                                      color: Color(0xFFfafbfc),
                                    ),
                                    Text(
                                      "- " + tokenListModel!.data![index - 1].fee! + " AE",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
      ),
    );
  }
}
