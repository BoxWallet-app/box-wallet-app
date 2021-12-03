import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
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
import 'cfx_token_record_page.dart';


typedef CfxTokenAddPageCallBackFuture = Future Function();

class CfxTokenAddPage extends StatefulWidget {

  final CfxTokenAddPageCallBackFuture cfxTokenAddPageCallBackFuture;

  const CfxTokenAddPage({Key key, this.cfxTokenAddPageCallBackFuture}) : super(key: key);

  @override
  _TokenAddPathState createState() => _TokenAddPathState();
}

class _TokenAddPathState extends State<CfxTokenAddPage> {
  var loadingType = LoadingType.loading;
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  List<TokensData> tokenData = [];
  CfxTokensListModel tokenListModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(widget.cfxTokenAddPageCallBackFuture!=null){
      widget.cfxTokenAddPageCallBackFuture();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();

    _textEditingControllerNode.addListener(() {
      var data = _textEditingControllerNode.text;
      if (data == null || data == "") {
        tokenData = tokenListModel.list.sublist(0);
        setState(() {});

        return;
      }
      tokenData.clear();
      tokenListModel.list.forEach((element) {
        if (element.name.toLowerCase().contains(data.toLowerCase()) || element.symbol.toLowerCase().contains(data.toLowerCase()) || element.address.toLowerCase().contains(data.toLowerCase())) {
          tokenData.add(element);
        }
      });

      setState(() {});
    });
  }

  Future<void> _onRefresh() async {
    CfxTokenListDao.fetch().then((CfxTokensListModel model) async {
      var address = await BoxApp.getAddress();
      var cfxTokens = await CtTokenManager.instance.getCfxCtTokens(address);

      if(cfxTokens.isNotEmpty){
        model.list.forEach((element) {
          cfxTokens.forEach((element2) {
            if(element.address == element2.ctId){
              element.isSelect = true;
            }
          });
        });
      }

      
      tokenListModel = model;
      tokenData = tokenListModel.list.sublist(0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
         S.of(context).CfxTokenAddPage_title,
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
        },
        child: LoadingWidget(
          type: loadingType,
          onPressedError: () {
            _onRefresh();
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                child: Stack(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: Color(0xFFedf3f7),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: _textEditingControllerNode,
                        focusNode: focusNodeNode,
                        inputFormatters: [
                          // WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                        ],
                        maxLines: 1,
                        style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 18,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black,
                        ),

                        decoration: InputDecoration(
                          hintText: S.of(context).CfxTokenAdd_input,
                          icon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              color: Color(0xff999999),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0x00000000)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666).withAlpha(85),
                          ),
                        ),
                        cursorColor: Color(0xFFFC2365),
                        cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: EasyRefresh(
                    header: BoxHeader(),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
                      itemCount: tokenData.length,
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
      ),
    );
  }


  Widget itemListView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () async {
            tokenData[index].isSelect = !tokenData[index].isSelect;
            tokenListModel.list.forEach((element) {
              if (tokenData[index].address == element.address) {
                element.isSelect = tokenData[index].isSelect;
              }
            });
            var address = await BoxApp.getAddress();
            var tokens = await CtTokenManager.instance.getCfxCtTokens(address);
            var tokensTemp = tokens.sublist(0);
            if (tokenData[index].isSelect) {
              tokensTemp.forEach((element) {
                if (element.ctId == tokenData[index].address) {
                  return;
                }
              });
              Tokens token = Tokens();
              token.ctId = tokenData[index].address;
              token.name = tokenData[index].name;
              token.symbol = tokenData[index].symbol;
              token.quoteUrl = tokenData[index].quoteUrl;
              token.iconUrl = getRealIconUrl(index);
              tokens.add(token);
            } else {
              tokensTemp.forEach((element) {
                if (element.ctId == tokenData[index].address) {
                  tokens.remove(element);
                }
              });
            }

            await CtTokenManager.instance.updateCfxCtTokens(address,tokens);

            setState(() {});
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
                            Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: getCoinImage(index),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    getCoinName(index),
                                    style: new TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 3),
                                  child: Text(
                                    tokenData[index].address.substring(0, 10) + "...." + tokenData[index].address.substring(tokenData[index].address.length - 10, tokenData[index].address.length),
                                    style: new TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff999999),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Image(
                                width: 22,
                                height: 22,
                                image: AssetImage(tokenData[index].isSelect ? "images/check_box_select.png" : "images/check_box_normal.png"),
                              ),
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

  Widget getCoinImage(int index) {
    String iconUrl = getRealIconUrl(index);
    return Image.network(

      iconUrl,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOut,
        );
      },
      errorBuilder: (  BuildContext context,
          Object error,
          StackTrace stackTrace,) {
        return Container(color: Colors.grey.shade200,);
      },
    );
  }

  String getRealIconUrl(int index) {
     String iconUrl;
    iconUrl = tokenData[index].iconUrl == null ? "" : tokenData[index].iconUrl;
    if (iconUrl.contains(".svg")) {
      iconUrl = "https://ae-source.oss-cn-hongkong.aliyuncs.com/DEF.png";
    }
    if (tokenData[index].address == "cfx:achc8nxj7r451c223m18w2dwjnmhkd6rxawrvkvsy2") {
      iconUrl = "https://ae-source.oss-cn-hongkong.aliyuncs.com/FC.png";
    }
    if(iconUrl == null || iconUrl==""){
      iconUrl = "https://scan-icons.oss-cn-hongkong.aliyuncs.com/mainnet/"+tokenData[index].address;
    }
    return iconUrl;
  }

  String getCoinName(int index) {
    String name;
    if (tokenData[index].name.length < tokenData[index].symbol.length) {
      name = tokenData[index].name;
    } else {
      name = tokenData[index].symbol;
    }
    if (name.length > 10) {
      name = name.substring(0, 5) + "..." + name.substring(name.length - 4, name.length);
    }
    return name;
  }
}
