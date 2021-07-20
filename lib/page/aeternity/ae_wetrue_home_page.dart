import 'dart:convert';
import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/swap_coin_order_dao.dart';
import 'package:box/dao/swap_dao.dart';
import 'package:box/dao/swap_my_buy_dao.dart';
import 'package:box/dao/swap_my_dao.dart';
import 'package:box/dao/swap_my_sell_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/swap_coin_order_model.dart';
import 'package:box/model/swap_model.dart';
import 'package:box/model/swap_order_model.dart';
import 'package:box/page/language_page.dart';
import 'package:box/page/photo_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/aeternity/ae_swap_initiate_page.dart';
import 'package:box/page/aeternity/ae_wetrue_list_page.dart';
import 'package:box/page/aeternity/ae_wetrue_sent_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ae_aens_my_page.dart';
import 'ae_aens_page.dart';
import '../login_page.dart';
import '../mnemonic_copy_page.dart';
import '../node_page.dart';

class AeWeTrueHomePage extends StatefulWidget {
  final int type;

  const AeWeTrueHomePage({Key key, this.type}) : super(key: key);

  @override
  _AeWeTrueHomePageState createState() => _AeWeTrueHomePageState();
}

class _AeWeTrueHomePageState extends State<AeWeTrueHomePage> with AutomaticKeepAliveClientMixin {
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            elevation: 0,
            // 隐藏阴影
            title: Image(
              height: kToolbarHeight / 2,
              image: AssetImage("images/wetrue_logo_h.png"),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close_outlined,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
//              Navigator.pop(context);
              },
            ),
//            actions: <Widget>[
//              MaterialButton(
//                minWidth: 10,
//                child: new Text(
//                 "白皮书",
//                  style: TextStyle(
//                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                  ),
//                ),
//                onPressed: () {
//                  _launchURL("https://wetrue.io/assets/Wetrue_White_Paper.pdf");
//                },
//              ),
//            ],
            bottom: TabBar(
              unselectedLabelColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.label,
              dragStartBehavior: DragStartBehavior.down,
              indicator: UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(
                    color: Color(0xFFFC2365),
                    width: 2,
                  ),
                  insets: EdgeInsets.only(bottom: 5)),
              tabs: <Widget>[
                Tab(
                    icon: Text(
                  "最新发布",
                  style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontSize: 14, fontWeight: FontWeight.w600),
                )),
                Tab(
                    icon: Text(
                  "热门推荐",
                  style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontWeight: FontWeight.w600),
                )),
                Tab(
                    icon: Text(
                  "最新图片",
                  style: TextStyle(fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", fontWeight: FontWeight.w600),
                )),
              ],
            ),
          ),
          backgroundColor: Color(0xFFF5F5F5),
          body: Container(
            padding: const EdgeInsets.only(top: 0),
            child: TabBarView(
              children: <Widget>[
                AeWeTrueListPage(type:0),
                AeWeTrueListPage(type:1),
                AeWeTrueListPage(type:2),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context) => AensRegister()));
//              BlockTopDao.fetch().then((BlockTopModel model) {
//                print(model.toJson());
//
//              }).catchError((e) {
//                print(e.toString() + "123123");
//
//              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AeWeTrueSendPage()));
            },
            child: new Icon(Icons.add),
            elevation: 3.0,
            highlightElevation: 2.0,
            backgroundColor: Color(0xFFFC2365),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50)),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
}