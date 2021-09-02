import 'dart:convert';
import 'dart:typed_data';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/aeternity/ae_token_add_page.dart';
import 'package:box/page/aeternity/ae_token_record_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import 'cfx_token_record_page.dart';

class CfxTokenListPage extends StatefulWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<CfxTokenListPage> {
  var loadingType = LoadingType.loading;
  CfxTokensListModel tokenListModel;
  PriceModel priceModel;

  Future<void> _onRefresh() async {
    CfxTokenListDao.fetch().then((CfxTokensListModel model) {
      model.list.sort((t1,t2){
        return (double.parse(t2.price)*double.parse(t2.balance)).compareTo((double.parse(t1.price)*double.parse(t1.balance)));
      });
      tokenListModel = model;
      if(tokenListModel.total == 0){
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netBaseData();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
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

  String getAePrice(int index) {
    if (priceModel == null) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).home_token,
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
          child: ListView.builder(
            itemCount: tokenListModel == null ? 0 : tokenListModel.total,
            itemBuilder: (BuildContext context, int index) {
              return itemListView(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget itemListView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CfxTokenRecordPage(
                          ctId: tokenListModel.list[index].address,
                          coinCount: tokenListModel.list[index].balance,
                          coinImage: tokenListModel.list[index].icon,
                          coinName: tokenListModel.list[index].symbol,
                        )));
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
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: getIconImage(tokenListModel.list[index].icon,tokenListModel.list[index].symbol),
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
                                if (getAePrice(index) != "")
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      getAePrice(index),
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

  Widget getIconImage(String data,String name) {
    if(name=="FC"){
      return Container(
        width: 27.0,
        height: 27.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(36.0),
          image: DecorationImage(
            image: AssetImage("images/" + name+ ".png"),
          ),
        ),
      );
    }
    String icon = data.split(',')[1]; //
    if(data.contains("data:image/png")){
      Uint8List bytes = Base64Decoder().convert(icon);
      return Image.memory(bytes, fit: BoxFit.contain);
    }

    if(data.contains("data:image/svg")){
      Uint8List bytes = Base64Decoder().convert(icon);

      return SvgPicture.memory(
        bytes,
        semanticsLabel: 'A shark?!',
        placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator()),
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
            image: AssetImage("images/" + "CFX"+ ".png"),
          ),
        ),
      );

  }
}
