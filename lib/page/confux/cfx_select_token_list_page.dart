import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';
import 'cfx_home_page.dart';

typedef CfxSelectTokenListCallBackFuture = Future Function(String tokenName, String tokenCount, String tokenImage, String tokenContract);

class CfxSelectTokenListPage extends StatefulWidget {
  final String aeCount;
  final CfxSelectTokenListCallBackFuture aeSelectTokenListCallBackFuture;

  const CfxSelectTokenListPage({Key key, this.aeCount, this.aeSelectTokenListCallBackFuture}) : super(key: key);

  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<CfxSelectTokenListPage> {
  var loadingType = LoadingType.loading;
  CfxTokensListModel tokenListModel;
  PriceModel priceModel;
  PriceModel priceModelCfx;

  Future<void> _onRefresh() async {
    CfxTokenListDao.fetch().then((CfxTokensListModel model) {
      model.list.sort((t1, t2) {
        if(t2.price == null || t1.price == null){
          return 0;
        }
        return (double.parse(t2.price)*double.parse(t2.balance)).compareTo((double.parse(t1.price)*double.parse(t1.balance)));
      });
      tokenListModel = model;
      if (tokenListModel.total == 0) {
        loadingType = LoadingType.no_data;
        setState(() {});
        return;
      }
      loadingType = LoadingType.finish;
      setState(() {});
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
    });
  }

  void netBaseData() {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    PriceDao.fetch("tether", type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netCfxBaseData() {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    PriceDao.fetch("conflux-token", type).then((PriceModel model) {
      priceModelCfx = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
    netBaseData();
    netCfxBaseData();
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
              color: Color(0xFFfafbfc),
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
                           S.of(context).cfx_select_token_page_title,
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
                        padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
                        itemCount: tokenListModel == null ? 0 : tokenListModel.total,
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
                widget.aeSelectTokenListCallBackFuture("CFX", widget.aeCount, "https://ae-source.oss-cn-hongkong.aliyuncs.com/CFX.png", "");
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
                                  color: Colors.white,
                                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(36.0),
                                  image: DecorationImage(
                                    image: AssetImage("images/" + "CFX" + ".png"),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 18, right: 18),
                                child: Text(
                                  "CFX",
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
                                  if (getTokenPrice(index) != "")
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        getCfxPrice(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13, color: Color(0xff999999), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
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
            if (widget.aeSelectTokenListCallBackFuture != null) {
              widget.aeSelectTokenListCallBackFuture(tokenListModel.list[index].symbol, Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2), tokenListModel.list[index].icon, tokenListModel.list[index].address);
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
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: getIconImage(tokenListModel.list[index].icon, tokenListModel.list[index].symbol),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 18, right: 18),
                              child: Text(
                                tokenListModel.list[index].symbol,
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
                                  Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 24, color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                ),
                                if (getTokenPrice(index) != "")
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      getTokenPrice(index),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, color: Color(0xff999999), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                    ),
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

  String getCfxPrice() {
    if (CfxHomePage.token == "loading...") {
      return "";
    }
    if (priceModelCfx == null) {
      return "";
    }
    if (BoxApp.language == "cn" && priceModelCfx.conflux != null) {
      if (priceModelCfx.conflux.cny == null) {
        return "";
      }
      if (double.parse(CfxHomePage.token) < 1000) {
        return "¥" + (priceModelCfx.conflux.cny * double.parse(CfxHomePage.token)).toStringAsFixed(4) + " ≈";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "¥" + (priceModelCfx.conflux.cny * double.parse(CfxHomePage.token)).toStringAsFixed(4) + " ≈";
      }
    } else {
      if (priceModelCfx.conflux.usd == null) {
        return "";
      }
      return "\$" + (priceModelCfx.conflux.usd * double.parse(CfxHomePage.token)).toStringAsFixed(4) + " ≈";
    }
  }

  String getTokenPrice(int index) {
    if (priceModel == null) {
      return "";
    }
    if(tokenListModel.list[index].price==null){
      return "";
    }
    if (BoxApp.language == "cn" && priceModel.tether != null) {
      if (priceModel.tether.cny == null) {
        return "";
      }
      if (double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) < 1000) {
        return "≈ " + (priceModel.tether.cny * (double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) * double.parse(tokenListModel.list[index].price))).toStringAsFixed(2) + " (CNY)";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "≈ " + (priceModel.tether.cny * (double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) * double.parse(tokenListModel.list[index].price))).toStringAsFixed(2) + " (CNY)";
      }
    } else {
      if (priceModel.tether.usd == null) {
        return "";
      }
      return "≈ " + ((double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) * double.parse(tokenListModel.list[index].price))).toStringAsFixed(2) + " (USD)";
    }
    return "-1";
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
}
