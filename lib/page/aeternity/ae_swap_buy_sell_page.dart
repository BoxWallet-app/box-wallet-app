import 'dart:ui';

import 'package:box/dao/aeternity/swap_coin_order_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/swap_coin_order_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AeSwapBuySellPage extends StatefulWidget {
  final int type;

  const AeSwapBuySellPage({Key key, this.type}) : super(key: key);

  @override
  _AeSwapBuySellPageState createState() => _AeSwapBuySellPageState();
}

class _AeSwapBuySellPageState extends State<AeSwapBuySellPage> with AutomaticKeepAliveClientMixin {
  var mnemonic = "";
  var version = "";
  SwapCoinOrderModel swapModels;
  EasyRefreshController controller = EasyRefreshController();
  var loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });

    _onRefresh();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
          return;
        },
        child: Container(

          child: AnimationLimiter(
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              controller: controller,

              header: BoxHeader(),
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: swapModels == null ? 0 : swapModels.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return getItem(context, index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    var model;
    if (widget.type == 0) {
      model = await SwapCoinOrderDao.fetch();
    } else {
      model = await SwapCoinOrderDao.fetch();
    }
    if (swapModels != null) {
      swapModels = null;
    }
    if (model != null || model.code == 200) {
      swapModels = model;
      loadingType = LoadingType.finish;
      if (swapModels.data == null || swapModels.data.length == 0) {
        loadingType = LoadingType.no_data;
      }
    } else {
      loadingType = LoadingType.error;
    }

    controller.finishRefresh();

    setState(() {});
  }


  Widget getItem(BuildContext context, int index) {
    return Material(
      child: InkWell(
        onTap: () {
        },
        child: Container(
          color: Color(0xFFfafbfc),
          child: Container(
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
            margin: index == swapModels.data.length-1 ? EdgeInsets.only(left: 16, right: 16, bottom:  MediaQueryData.fromWindow(window).padding.bottom, top: 0) : EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 0),
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 18, top: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).swap_buy_sell_order_item_1,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                Utils.formatAddress(swapModels.data[index].sellAddress),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).swap_buy_sell_order_item_2,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                Utils.formatAddress(swapModels.data[index].buyAddress),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).swap_buy_sell_order_item_4,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                Utils.formatTime( swapModels.data[index].payTime),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).swap_buy_sell_order_item_7 +" ("+swapModels.data[index].coinName+")",
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                swapModels.data[index].tokenCount.toString(),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).swap_buy_sell_order_item_8,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                swapModels.data[index].aeCount.toString(),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  " "+S.of(context).swap_buy_sell_order_item_9,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                (swapModels.data[index].currentHeight - swapModels.data[index].payHeight).toString(),
                                style: TextStyle(color: Color(0xFFE51363), fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void netBuy(int index) {
    showGeneralDialog(useRootNavigator:false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var signingKey = await BoxApp.getSigningKey();
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  var aesDecode = Utils.aesDecode(signingKey, key);

                  if (aesDecode == "") {
                    _onRefresh();
                   showErrorDialog(context, null);
                    return;
                  }
                  // ignore: missing_return
                  BoxApp.contractSwapCancel((data) {




                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                          title: Text(S.of(context).dialog_hint),
                          content:  Text(
                            S.of(context).dialog_dismiss_sucess,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: new Text(
                                S.of(context).dialog_conform,
                              ),
                              onPressed: () {
                                eventBus.fire(SwapEvent());
                                swapModels.data.removeAt(index - 1);
                                setState(() {});
                                loadingType = LoadingType.loading;
                                setState(() {});
                                _onRefresh();
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                          ],
                        );
                      },
                    ).then((val) {});
                  }, (error) {
                    showErrorDialog(context, error);
                    return;
                  }, aesDecode, address, BoxApp.SWAP_CONTRACT, BoxApp.SWAP_CONTRACT_ABC);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showChainLoading() {
    showGeneralDialog(useRootNavigator:false,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return;
        },
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          return ChainLoadingWidget();
        });
  }

  Material buildItem(BuildContext context, String content, String assetImage, GestureTapCallback tab, {bool isLine = true}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 13),
                child: Row(
                  children: <Widget>[
//                    Image(
//                      width: 40,
//                      height: 40,
//                      image: AssetImage(assetImage),
//                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 28,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              if (isLine)
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFfafbfc)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderItem(String content, String image, GestureTapCallback tapCallback) {
    return Material(
        color: Color(0xFFFC2365),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onTap: tapCallback,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Image(
                      width: 40,
                      height: 40,
                      image: AssetImage(image),
                    ),
                  ),
                  Text(
                    content,
                    style: new TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void showErrorDialog(BuildContext buildContext, String content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }
}
