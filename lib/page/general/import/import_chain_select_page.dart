import 'dart:io';
import 'dart:ui';

import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../config.dart';
import 'import_account_common_page.dart';
import '../create/create_mnemonic_copy_page.dart';
import 'import_account_ae_page.dart';
import 'import_account_cfx_page.dart';
import 'import_account_eth_page.dart';

class ImportChainSelectPage extends StatefulWidget {
  const ImportChainSelectPage({Key key}) : super(key: key);

  @override
  _SelectChainCreatePathState createState() => _SelectChainCreatePathState();
}

class _SelectChainCreatePathState extends State<ImportChainSelectPage> {
  var loadingType = LoadingType.finish;
  List<ChainsModel> chains;
  PriceModel priceModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chains = WalletCoinsManager.instance.getChains();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).ImportChainSelectPage_title,
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
        onPressedError: () {},
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: EasyRefresh(
                  header: BoxHeader(),
                  child: ListView.builder(
                    itemCount: chains.length + 3,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: itemListView(context, index),
                            ),
                          ));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemListView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: Text(
         S.of(context).ImportChainSelectPage_group1,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withAlpha(180),
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
      );
    }
    if (index == 1) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              if (Platform.isIOS) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImportAccountCommonPage(type: CreateMnemonicCopyPage.LOGIN)));
              } else {
                Navigator.push(context, SlideRoute(ImportAccountCommonPage(type: CreateMnemonicCopyPage.LOGIN)));
              }
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
                                  child: Container(
                                    width: 45.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Color(0xFFfafbfc), width: 1.0), top: BorderSide(color: Color(0xFFfafbfc), width: 1.0), left: BorderSide(color: Color(0xFFfafbfc), width: 1.0), right: BorderSide(color: Color(0xFFfafbfc), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(36.0),
                                      image: DecorationImage(
                                        image: AssetImage("images/logo.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  S.of(context).ImportChainSelectPage_group1_content,
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                width: 25,
                                height: 25,
                                padding: const EdgeInsets.only(left: 0),
                                //边框设置
                                decoration: new BoxDecoration(
                                  color: Color(0xFFfafbfc),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Color(0xFFCCCCCC),
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

    if (index == 2) {
      return Container(
        margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
        child: Text(
          S.of(context).ImportChainSelectPage_group2,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withAlpha(180),
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
      );
    }
    index = index - 3;
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if (chains[index].name == "AE") {
              if (Platform.isIOS) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImportAccountAePage(
                              coinName: chains[index].name,
                              fullName: chains[index].nameFull,
                            )));
              } else {
                Navigator.push(
                    context,
                    SlideRoute(ImportAccountAePage(
                      coinName: chains[index].name,
                      fullName: chains[index].nameFull,
                    )));
              }
              return;
            }
            if (chains[index].name == "CFX") {
              if (Platform.isIOS) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImportAccountCfxPage(
                          coinName: chains[index].name,
                          fullName: chains[index].nameFull,
                        )));
              } else {
                Navigator.push(
                    context,
                    SlideRoute(ImportAccountCfxPage(
                      coinName: chains[index].name,
                      fullName: chains[index].nameFull,
                    )));
              }
              return;
            }

            if (chains[index].name == "BNB" || chains[index].name =="HT"|| chains[index].name =="OKT" || chains[index].name =="ETH") {
              if (Platform.isIOS) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImportAccountEthPage(
                          coinName: chains[index].name,
                          fullName: chains[index].nameFull,
                        )));
              } else {
                Navigator.push(
                    context,
                    SlideRoute(ImportAccountEthPage(
                      coinName: chains[index].name,
                      fullName: chains[index].nameFull,
                    )));
              }
              return;
            }
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
                                child: Container(
                                  width: 45.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFfafbfc), width: 1.0), top: BorderSide(color: Color(0xFFfafbfc), width: 1.0), left: BorderSide(color: Color(0xFFfafbfc), width: 1.0), right: BorderSide(color: Color(0xFFfafbfc), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(36.0),
                                    image: DecorationImage(
                                      image: AssetImage("images/" + chains[index].name + ".png"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  chains[index].nameFull + " (" + chains[index].name + ")",
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 25,
                              height: 25,
                              padding: const EdgeInsets.only(left: 0),
                              //边框设置
                              decoration: new BoxDecoration(
                                color: Color(0xFFfafbfc),
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Color(0xFFCCCCCC),
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

}
