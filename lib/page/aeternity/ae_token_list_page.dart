import 'dart:async';
import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_token_record_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import 'ae_home_page.dart';

class AeTokenListPage extends BaseWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends BaseWidgetState<AeTokenListPage> {
  var loadingType = LoadingType.loading;
  TokenListModel? tokenListModel;

  Future<void> _onRefresh() async {
    TokenListDao.fetch(AeHomePage.address, "easy").then((TokenListModel model) async {
      if (model.code == 200) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
        setState(() {});
      } else {
        tokenListModel = null;
        loadingType = LoadingType.error;
        setState(() {});
      }
      await getCacheBalance();
      await getBalance();
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
    });
  }

  getCacheBalance() async {
    for (int i = 0; i < tokenListModel!.data!.length; i++) {
      Account account = await getCurrentAccount();
      var cacheBalance = await CacheManager.instance.getTokenBalance(account.address!, tokenListModel!.data![i].ctAddress!, account.coin!);
      if (cacheBalance != "") {
        tokenListModel!.data![i].countStr = cacheBalance;
        setState(() {});
      }
    }
  }

  Future<void> getBalance() async {
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    for (int i = 0; i < tokenListModel!.data!.length; i++) {
      var params = {
        "name": "aeAex9TokenBalance",
        "params": {"ctAddress": tokenListModel!.data![i].ctAddress!, "address": account!.address}
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
        var ctAddress = jsonResponse["result"]["ctAddress"];

        if (!mounted) return;
        for (int j = 0; j < tokenListModel!.data!.length; j++) {
          if (tokenListModel!.data![j].ctAddress == ctAddress) {
            tokenListModel!.data![j].countStr = AmountDecimal.parseDecimal(balance);
            CacheManager.instance.setTokenBalance(address, ctAddress, account.coin!, AmountDecimal.parseDecimal(balance));
          }
        }
        setState(() {});
        return;
      }, channelJson);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
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
              showGeneralDialog(
                  useRootNavigator: false,
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: "",
                  transitionDuration: Duration(milliseconds: 0),
                  transitionBuilder: (context, anim1, anim2, child) {
                    return Transform(
                        transform: Matrix4.translationValues(0.0, 0, 0.0),
                        child: Opacity(
                            opacity: anim1.value,
                            // ignore: missing_return
                            child: Material(
                              type: MaterialType.transparency, //透明类型
                              child: Center(
                                child: Container(
                                  height: 470,
                                  width: MediaQuery.of(context).size.width - 40,
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  decoration: ShapeDecoration(
                                    color: Color(0xffffffff),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width - 40,
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.all(Radius.circular(60)),
                                            onTap: () {
                                              Navigator.pop(context); //关闭对话框
                                            },
                                            child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20, right: 20),
                                        child: Text(
                                          S.of(context).tokens_dialog_title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 270,
                                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            child: Text(
                                              S.of(context).tokens_dialog_content,
                                              style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 30, bottom: 20),
                                        child: ArgonButton(
                                          height: 40,
                                          roundLoadingShape: true,
                                          width: 120,
                                          onTap: (startLoading, stopLoading, btnState) async {
                                            Navigator.pop(context); //关闭对话框
                                          },
                                          child: Text(
                                            S.of(context).dialog_statement_btn,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                          loader: Container(
                                            padding: EdgeInsets.all(10),
                                            child: SpinKitRing(
                                              lineWidth: 4,
                                              color: Colors.white,
                                              // size: loaderWidth ,
                                            ),
                                          ),
                                          borderRadius: 30.0,
                                          color: Color(0xFFFC2365),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )));
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return Container();
                  });
            },
          ),
        ],
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
            itemCount: tokenListModel == null ? 0 : tokenListModel!.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return itemListView(context, index);
            },
          ),
        ),
      ),
    );
  }

//   void netContractBalance(int index) {
//     ContractBalanceDao.fetch(tokenListModel.data[index].ctAddress).then((ContractBalanceModel model) {
//       if (model.code == 200) {
//         tokenListModel.data[index].countStr = model.data.balance;
//         tokenListModel.data[index].rate = model.data.rate;
//         setState(() {});
//       } else {}
//     }).catchError((e) {
// //      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//     });
//   }

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
                    builder: (context) => AeTokenRecordPage(
                          ctId: tokenListModel!.data![index].ctAddress,
                          coinCount: tokenListModel!.data![index].count,
                          coinImage: tokenListModel!.data![index].image,
                          coinName: tokenListModel!.data![index].name,
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
                                  tokenListModel!.data![index].image!,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    tokenListModel!.data![index].name!,
                                    style: new TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    tokenListModel!.data![index].nameFull!,
                                    style: new TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
//                                            fontWeight: FontWeight.w600,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            tokenListModel!.data![index].countStr == null
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    child: Lottie.asset(
                                      'images/loading.json',
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(
                                        tokenListModel!.data![index].countStr!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 20, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
