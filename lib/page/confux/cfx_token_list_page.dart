import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/conflux/cfx_nft_balance_dao.dart';
import 'package:box/dao/conflux/cfx_token_address_dao.dart';
import 'package:box/dao/conflux/cfx_token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/model/aeternity/ct_token_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/model/conflux/cfx_tokens_list_model.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'cfx_token_add_page.dart';
import 'cfx_token_record_page.dart';

class CfxTokenListPage extends StatefulWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<CfxTokenListPage> with SingleTickerProviderStateMixin{
  var tokenLoadingType = LoadingType.loading;
  var nftLoadingType = LoadingType.loading;
  List<Tokens>? cfxCtTokens = [];
  PriceModel? priceModel;
  PriceModel? priceModelCfx;
  int tabIndex = 0;
  List<String> tabs = <String>[];
  List<String?> tabsCt = <String?>[];

  PageController pageController = PageController();
  TabController? tabBarController ;

  Future<void> _onRefresh() async {
    // await netTokenBaseData();
    netNftBalance();
    var address = await BoxApp.getAddress();
    cfxCtTokens = await CtTokenManager.instance.getCfxCtTokens(address);
    if (cfxCtTokens!.length == 0) {
      tokenLoadingType = LoadingType.no_data;
      setState(() {});
      return;
    }
    tokenLoadingType = LoadingType.finish;

    setState(() {});
    getBalance(address);
  }

  bool isLoadBalance = false;

  void getBalance(String address) {
    if (isLoadBalance) {
      return;
    }
    bool isReturn = true;
    late Tokens token;

    for (int i = 0; i < cfxCtTokens!.length; i++) {
      if (cfxCtTokens![i].balance == null) {
        isReturn = false;
        token = cfxCtTokens![i];
        break;
      }
    }

    if (isReturn) return;
    isLoadBalance = true;
    if (token.balance == null) {
      BoxApp.getErcBalanceCFX((balance,decimal) async {
        balance = AmountDecimal.parseUnits(balance, decimal);
        token.balance = Utils.formatBalanceLength(double.parse(balance));

        if (!mounted) {
          return;
        }
        setState(() {});
        getBalance(address);
        return;
      }, address, token.ctId!);
    }
    isLoadBalance = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netTokenBaseData();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
    tabBarController = new TabController(length:2, vsync: this);
    // pageController.addListener(() {
    //   print(pageController.keepScrollOffset);
    //   if (pageController.page == 0) {
    //     tabBarController.index = 0;
    //   } else {
    //     tabBarController.index = 1;
    //
    //   }
    // });
  }

  Future<void> netTokenBaseData() async {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    priceModel = await PriceDao.fetch("tether", type);
  }

  String getTokenPrice(int index) {
//     if (priceModel == null) {
//       return "";
//     }
//
//     if(tokenListModel.list[index].price==null){
//       return "";
//     }
//     if (BoxApp.language == "cn" && priceModel.tether != null) {
//       if (priceModel.tether.cny == null) {
//         return "";
//       }
//       if (double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) < 1000) {
//         return "??? " + (priceModel.tether.cny * (double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) * double.parse(tokenListModel.list[index].price))).toStringAsFixed(2) + " (CNY)";
//       } else {
// //        return "??? " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
//         return "??? " + (priceModel.tether.cny * (double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) * double.parse(tokenListModel.list[index].price))).toStringAsFixed(2) + " (CNY)";
//       }
//     } else {
//       if (priceModel.tether.usd == null) {
//         return "";
//       }
//       return "??? " + ((double.parse(Utils.cfxFormatAsFixed(tokenListModel.list[index].balance, 2)) * double.parse(tokenListModel.list[index].price))).toStringAsFixed(2) + " (USD)";
//     }
    return "-1";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          elevation: 0,
          // ????????????
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
          actions: <Widget>[
            IconButton(
              splashRadius: 40,
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Color(0xFF000000),
                size: 22,
              ),
              onPressed: () {
                if (Platform.isIOS) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CfxTokenAddPage(
                                cfxTokenAddPageCallBackFuture: () {
                                  _onRefresh();
                                  return;
                                },
                              )));
                } else {
                  Navigator.push(context, SlideRoute(CfxTokenAddPage(
                    cfxTokenAddPageCallBackFuture: () {
                      _onRefresh();
                      return;
                    },
                  )));
                }

                return;
              },
            ),
          ],
        ),
        body: LoadingWidget(
          type: tokenLoadingType,
          onPressedError: () {
            _onRefresh();
          },
          child: Column(
            children: [
              TabBar(
                // controller: tabBarController,
                onTap: (index) {
                  setState(() {
                    tabIndex = index;
                    // pageController.animateToPage(tabIndex,   curve: Curves.ease,
                    //     duration: Duration(milliseconds: 200));
                  });
                },
                tabs: [
                  Tab(text: "CRC20"),
                  Tab(text: "NFTs",),
                ],
                labelColor: Colors.black,
                // add it here
                indicator: MaterialIndicator(
                  color: Color(0xFFFC2365),
                  height: 3,
                  topLeftRadius: 8,
                  topRightRadius: 8,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                  horizontalPadding: 80,
                  tabPosition: TabPosition.bottom,
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    // controller: pageController,
                    children: [
                      EasyRefresh(
                        header: BoxHeader(),
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: MediaQueryData.fromWindow(window).padding.bottom),
                          itemCount: cfxCtTokens!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return itemListView(context, index);
                          },
                        ),
                      ),
                      LoadingWidget(
                        child: tabs.length != 0
                            ? EasyRefresh(
                                child: ListView.builder(
                                  itemBuilder: _renderRow,
                                  itemCount: tabs.length,
                                ),
                              )
                            : Container(),
                        type: nftLoadingType,
                        onPressedError: () {
                          setState(() {
                            nftLoadingType = LoadingType.loading;
                          });
                          netNftBalance();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if (index < list.length) {
    return Container(margin: EdgeInsets.only(left: 15, right: 15, top: 12), child: buildColumn(context, index));
  }

  Column buildColumn(BuildContext context, int position) {
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () async {
              String url = "https://confluxscan.io/nft-checker/" + await BoxApp.getAddress() + "?NFTAddress=" + tabsCt[position]!;
              _launchURL(url);
              return;
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              child: Text(
                                tabs[position],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
                    ],
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

  Tab createTab(BuildContext context, String tab) {
    return Tab(
        icon: Text(
      tab,
      style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w600),
    ));
  }

  void netNftBalance() {
    CfxNftBalanceDao.fetch().then((CfxNftBalanceModel model) {

      if (model == null) {
        return;
      }
      tabs.clear();
      for (var i = 0; i < model.data!.length; i++) {
        tabs.add(model.data![i].name!.zh! + "(" + model.data![i].balance.toString() + ")");
        tabsCt.add(model.data![i].address);
      }
      if (tabs.isEmpty) {
        nftLoadingType = LoadingType.no_data;
      } else {
        nftLoadingType = LoadingType.finish;
      }

      if (!mounted) {
        return;
      }
      setState(() {});

    }).catchError((e) {});
  }

  Widget itemListView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            if (cfxCtTokens![index].balance == null) {
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CfxTokenRecordPage(
                          ctId: cfxCtTokens![index].ctId,
                          coinCount: cfxCtTokens![index].balance,
                          coinImage: cfxCtTokens![index].iconUrl,
                          coinName: getCoinName(index),
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
                                child: Image.network(
                                  cfxCtTokens![index].iconUrl!,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                    );
                                  },
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
                                getCoinName(index)!,
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
                                if (cfxCtTokens![index].balance != null)
                                  Text(
                                    cfxCtTokens![index].balance!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  ),
                                if (cfxCtTokens![index].balance == null)
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
                                      'images/loading.json',
//              'images/animation_khzuiqgg.json',
                                    ),
                                  ),
                                if (cfxCtTokens![index].price != null)
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      cfxCtTokens![index].price!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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

  String? getCoinName(int index) {
    String? name;
    if (cfxCtTokens![index].name!.length < cfxCtTokens![index].symbol!.length) {
      name = cfxCtTokens![index].name;
    } else {
      name = cfxCtTokens![index].symbol;
    }
    if (name!.length > 10) {
      name = name.substring(0, 5) + "..." + name.substring(name.length - 4, name.length);
    }
    return name;
  }
}
