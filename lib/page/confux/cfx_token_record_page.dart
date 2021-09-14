import 'dart:convert';
import 'dart:typed_data';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/dao/aeternity/token_record_dao.dart';
import 'package:box/dao/conflux/cfx_crc20_transfer_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/token_record_model.dart';
import 'package:box/model/conflux/cfx_crc20_transfer_model.dart';
import 'package:box/page/aeternity/ae_token_add_page.dart';
import 'package:box/page/aeternity/ae_token_receive_page.dart';
import 'package:box/page/aeternity/ae_token_send_one_page.dart';
import 'package:box/page/aeternity/ae_token_tx_detail_page.dart';
import 'package:box/page/aeternity/ae_tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'cfx_home_page.dart';
import 'cfx_token_receive_page.dart';
import 'cfx_token_send_one_page.dart';
import 'cfx_tx_detail_page.dart';

class CfxTokenRecordPage extends StatefulWidget {
  final String ctId;
  final String coinName;
  final String coinImage;
  final String coinCount;

  const CfxTokenRecordPage({Key key, this.ctId, this.coinName, this.coinCount, this.coinImage}) : super(key: key);

  @override
  _TokenRecordState createState() => _TokenRecordState();
}

class _TokenRecordState extends State<CfxTokenRecordPage> {
  var loadingType = LoadingType.loading;
  CfxCrc20TransferModel tokenListModel;
  int page = 1;
  String count;
  EasyRefreshController _controller = EasyRefreshController();

  Future<void> _onRefresh() async {
    page = 1;
    netTokenRecord();
  }

  Future<void> netTokenRecord() async {
    CfxCrc20TransferModel model = await CfxCrc20TransferDao.fetch(page.toString(), widget.ctId);
    if (model != null || model.code == 0) {
      if (page == 1) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
      } else {
        tokenListModel.data.list.addAll(model.data.list);
        loadingType = LoadingType.finish;
      }
      _controller.finishRefresh();
      _controller.finishLoad();
      if (tokenListModel.data.list.length < 20) {
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
        child: ListView.builder(
          itemCount: itemCount(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return itemHeaderView(context, index);
            } else {
              return itemView(context, index);
            }
          },
        ),
      ),
    );
  }

  int itemCount() {
    if (tokenListModel == null || tokenListModel.data.list == null ||  tokenListModel.data.list.length == 0) {
      return 1;
    } else {
      return tokenListModel.data.list.length;
    }
  }

  Widget itemHeaderView(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 18, right: 18),
      padding: EdgeInsets.only(bottom: 18),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                                    child: getIconImage(widget.coinImage, widget.coinName),
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
                                Text(
                                  (double.parse(widget.coinCount) / 1000000000000000000).toStringAsFixed(2),
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
                    width: MediaQuery.of(context).size.width / 2 - 25 - 18,
                    margin: const EdgeInsets.only(top: 0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CfxTokenSendOnePage()));
                      },
                      child: Text(
                        S.of(context).home_page_function_send,
                        maxLines: 1,
                        style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF37A1DB)),
                      ),
                      color: Color(0xFF37A1DB).withAlpha(16),
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

                        Navigator.push(context, MaterialPageRoute(builder: (context) => CfxTokenReceivePage()));
                      },
                      child: Text(
                        S.of(context).home_page_function_receive,
                        maxLines: 1,
                        style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF37A1DB)),
                      ),
                      color: Color(0xFF37A1DB).withAlpha(16),
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getIconImage(String data, String name) {

    if(data == null){
      return Container(
        width: 27.0,
        height: 27.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(36.0),
          image: DecorationImage(
            image: AssetImage("images/" + "CFX"+ ".png"),
          ),
        ),
      );
    }
    if (name == "FC") {
      return Container(
        width: 27.0,
        height: 27.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(36.0),
          image: DecorationImage(
            image: AssetImage("images/" + name + ".png"),
          ),
        ),
      );
    }
    String icon = data.split(',')[1]; //
    if (data.contains("data:image/png")) {
      Uint8List bytes = Base64Decoder().convert(icon);
      return Image.memory(bytes, fit: BoxFit.contain);
    }

    if (data.contains("data:image/svg")) {
      Uint8List bytes = Base64Decoder().convert(icon);

      return SvgPicture.memory(
        bytes,
        semanticsLabel: 'A shark?!',
        placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
      );
    }

    return Container(
      width: 27.0,
      height: 27.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(36.0),
        image: DecorationImage(
          image: AssetImage("images/" + "CFX" + ".png"),
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

  Widget itemView(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 18, right: 18, bottom: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            _launchURL("https://confluxscan.io/transaction/" + tokenListModel.data.list[index].transactionHash);
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
                                    color: tokenListModel.data.list[index - 1].to == CfxHomePage.address ? Color(0xFFF22B79) : Colors.green,
                                    image: tokenListModel.data.list[index - 1].to == CfxHomePage.address ? AssetImage("images/token_send.png") : AssetImage("images/token_receive.png"),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        tokenListModel.data.list[index - 1].from == CfxHomePage.address ? Utils.formatAddress(tokenListModel.data.list[index - 1].to) : Utils.formatAddress(tokenListModel.data.list[index - 1].from),
                                        style: TextStyle(fontSize: 17, color: Color(0xff333333), fontWeight: FontWeight.w400, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 12, top: 8),
                                      child: Text(
                                        DateTime.fromMicrosecondsSinceEpoch(tokenListModel.data.list[index - 1].timestamp * 1000000).toLocal().toString().substring(0, DateTime.fromMicrosecondsSinceEpoch(tokenListModel.data.list[index - 1].timestamp * 1000000).toLocal().toString().length - 4),
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
                                      tokenListModel.data.list[index - 1].from == CfxHomePage.address ? "- " + (double.parse(tokenListModel.data.list[index - 1].amount) / 1000000000000000000).toStringAsFixed(2) + " " + widget.coinName : "+ " + (double.parse(tokenListModel.data.list[index - 1].amount) / 1000000000000000000).toStringAsFixed(2) + " " + widget.coinName,
                                      style: TextStyle(fontSize: 17, color: tokenListModel.data.list[index - 1].from == CfxHomePage.address ? Colors.black : Colors.black, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
                                    Container(
                                      height: 5,
                                      color: Color(0xFFfafbfc),
                                    ),
                                    Text(
                                      S.current.cfx_tx_detail_page_jiyuan+":" + tokenListModel.data.list[index - 1].epochNumber.toString() + " ",
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
      ),
    );
  }
}
