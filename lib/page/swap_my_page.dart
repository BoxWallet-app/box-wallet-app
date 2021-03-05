import 'dart:convert';
import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/swap_dao.dart';
import 'package:box/dao/swap_my_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/swap_model.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/photo_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/swap_initiate_page.dart';
import 'package:box/page/swaps_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login_page.dart';
import 'mnemonic_copy_page.dart';
import 'node_page.dart';

class SwapMyPage extends StatefulWidget {
  @override
  _SwapPageMyState createState() => _SwapPageMyState();
}

class _SwapPageMyState extends State<SwapMyPage> with AutomaticKeepAliveClientMixin {
  var mnemonic = "";
  var version = "";
  SwapModel swapModels;
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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF5F5F5),
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).swap_title_my,
          style: TextStyle(
            fontSize: 18,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
            minWidth: 10,
            child: new Text(
              S.of(context).swap_buy_sell_order,
              style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SwapsPage()));
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
              header: AEHeader(),
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
    var model = await SwapMyDao.fetch();
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
//          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: contractRecordModel.data[index])));
        },
        child: Container(
          color: Color(0xFFF5F5F5),
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
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoPage(address:swapModels.data[index - 1].account)));
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
                          child: Image.network(
                            "https://www.gravatar.com/avatar/" + Utils.generateMD5(swapModels.data[index - 1].account) + "?s=100&d=robohash&r=PG",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(Utils.formatAddress(swapModels.data[index - 1].account), style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFF000000))),
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
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              ((double.parse(swapModels.data[index - 1].ae)) / (double.parse(swapModels.data[index - 1].count))).toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFF666666),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
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
                              S.of(context).swap_item_2 + " (" + swapModels.data[index - 1].coin + ")",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 5, left: 0),
                            child: Text(
                              double.parse(swapModels.data[index - 1].count).toStringAsFixed(2) + " 个",
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,

                                  //词间距
                                  color: Color(0xFF000000),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
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
                              S.of(context).swap_item_3 + " (AE)",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 5, left: 0),
                            child: Text(
                              double.parse(swapModels.data[index - 1].ae).toStringAsFixed(2) + " 个",
                              style: TextStyle(
                                  fontSize: 19,
                                  letterSpacing: -1,
                                  //字体间距
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFF22B79),
                                  //词间距
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
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
                      style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFFF22B79)),
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
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
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
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(S.of(context).dialog_hint_check_error_content),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  // ignore: missing_return
                  BoxApp.contractSwapCancel((data) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_dismiss_sucess,
                        ),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                              ),
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
                      ),
                    );
                  }, (error) {
                    print(error);
                    showPlatformDialog(
                      context: context,
                      // ignore: missing_return
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            // ignore: missing_return
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              return;
                            },
                          ),
                        ],
                      ),
                    );
                  }, aesDecode, address, BoxApp.SWAP_CONTRACT, BoxApp.SWAP_CONTRACT_ABC);
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
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
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFF5F5F5)),
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
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
}
