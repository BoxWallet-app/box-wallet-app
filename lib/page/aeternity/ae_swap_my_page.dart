import 'dart:io';
import 'dart:ui';

import 'package:box/dao/aeternity/swap_coin_my_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/swap_coin_account_model.dart';
import 'package:box/page/aeternity/ae_swaps_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:package_info/package_info.dart';

class AeSwapMyPage extends StatefulWidget {
  @override
  _SwapPageMyState createState() => _SwapPageMyState();
}

class _SwapPageMyState extends State<AeSwapMyPage> with AutomaticKeepAliveClientMixin {
  var mnemonic = "";
  var version = "";
  SwapCoinAccountModel swapModels;
  EasyRefreshController controller = EasyRefreshController();
  var loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFfafbfc),
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).swap_title_my,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
            minWidth: 10,
            child: new Text(
              S.of(context).swap_buy_sell_order,
              style: TextStyle(
                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
              ),
            ),
            onPressed: () {
              if (Platform.isIOS) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AeSwapsPage()));
              } else {
                Navigator.push(context, SlideRoute(AeSwapsPage()));
              }
            },
          ),
        ],
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
          return;
        },
        child: Container(
//          padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top + 55),
          child: AnimationLimiter(
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              controller: controller,
              header: BoxHeader(),
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: swapModels == null ? 1 : swapModels.data.length + 1,
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
    var model = await SwapCoinMyDao.fetch();
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
    if (index == 0) {
      return Column(
        children: [
          swapModels != null
              ? Container()
              : Container(
                  height: 200,
                  child: Center(child: Text(S.of(context).loading_widget_no_data)),
                ),
//          Container(
//            child: Center(
//              child: Container(
//                width: 400,
//                height: 400,
//                child: Lottie.asset(
//                  'images/16294-404-space-error.json',
//
//                ),
//              ),
//            )
//          ),
        ],
      );
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
//          Navigator.push(context, SlideRoute( TxDetailPage(recordData: contractRecordModel.data[index])));
        },
        child: Container(
          color: Color(0xFFfafbfc),
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 0),
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // if (Platform.isIOS) {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) =>PhotoPage(address: swapModels.data[index - 1].account)));
                        // } else {
                        //   Navigator.push(context, SlideRoute( PhotoPage(address: swapModels.data[index - 1].account)));
                        // }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Color(0xFFe0e0e0), width: 0.5),
                          color: Color(0xFFFFFFFF), // 底色
                          //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                          borderRadius: new BorderRadius.all(Radius.circular(50)), // 也可控件一边圆角大小
                        ),
                        child: ClipOval(
                            child: CircularProfileAvatar(
                          '', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                          radius: 15,
                          // sets radius, default 50.0
                          backgroundColor: Colors.transparent,
                          // sets background color, default Colors.white
//                            borderWidth: 10,  // sets border, default 0.0
                          initialsText: Text(
                            swapModels.data[index - 1].account.substring(swapModels.data[index - 1].account.length - 2, swapModels.data[index - 1].account.length).toUpperCase(),
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          // sets initials text, set your own style, default Text('')
                          borderColor: Color(0xFFE51363),
                          // sets border color, default Colors.white
                          elevation: 5.0,
                          // sets elevation (shadow of the profile picture), default value is 0.0
                          foregroundColor: Color(0xFFE51363).withOpacity(0.5),
                          //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                          cacheImage: true,
                          // allow widget to cache image against provided url
                          onTap: () {},
                          // sets on tap
                          showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                        )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(Utils.formatAddress(swapModels.data[index - 1].account), style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000))),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              S.of(context).swap_item_1 + " : ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              swapModels.data[index - 1].rate.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFF666666),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 18, left: 0),
                            child: Text(
                              S.of(context).swap_item_2 + " (" + swapModels.data[index - 1].coinName + ")",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 5, left: 0),
                            child: Text(
                              swapModels.data[index - 1].tokenCount + " " + S.of(context).swap_item_6,
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFF000000),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 18, left: 0),
                            child: Text(
                              S.of(context).swap_send_2 + " (AE)",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 5, left: 0),
                            child: Text(
                              swapModels.data[index - 1].aeCount + " " + S.of(context).swap_item_6,
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFF22B79),
                                  //词间距
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 25,
                  margin: const EdgeInsets.only(top: 18),
                  child: FlatButton(
                    onPressed: () {
                      netBuy(index);
                    },
                    child: Text(
                      S.of(context).swap_item_5,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                    ),
                    color: Color(0xFFE61665).withAlpha(16),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
          ),
        ),
      ),
    );
  }

  void netBuy(int index) {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              // ignore: missing_return
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
                        return new AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          title: Text(S.of(context).dialog_hint),
                          content: Text(S.of(context).dialog_dismiss_sucess),
                          actions: <Widget>[
                            TextButton(
                              child: new Text(
                                S.of(context).dialog_conform,
                              ),
                              onPressed: () {
                                eventBus.fire(SwapEvent());
                                swapModels.data.removeAt(index - 1);
                                setState(() {});
                                if (swapModels.data.length == 0) {
                                  loadingType = LoadingType.no_data;
                                  setState(() {});
                                }

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
                  }, aesDecode, address, BoxApp.SWAP_CONTRACT, swapModels.data[index - 1].token);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showChainLoading() {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
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
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
