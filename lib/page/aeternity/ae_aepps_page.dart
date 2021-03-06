import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/banner_dao.dart';
import 'package:box/dao/aeternity/base_name_data_dao.dart';
import 'package:box/dao/aeternity/contract_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/banner_model.dart';
import 'package:box/model/aeternity/base_name_data_model.dart';
import 'package:box/model/aeternity/contract_info_model.dart';
import 'package:box/page/aeternity/ae_swap_page.dart';
import 'package:box/page/aeternity/ae_token_defi_page.dart';
import 'package:box/page/aeternity/ae_wetrue_home_page.dart';
import 'package:box/page/aeternity/ae_wetrue_web_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'ae_aens_page.dart';
import 'ae_aex2_page.dart';

class AeAeppsPage extends StatefulWidget {
  @override
  _AeAeppsPageState createState() => _AeAeppsPageState();
}

class _AeAeppsPageState extends State<AeAeppsPage> with AutomaticKeepAliveClientMixin {
  BaseNameDataModel? baseNameDataModel;
  BannerModel? bannerModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
    eventBus.on<LanguageEvent>().listen((event) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void netBaseNameData() {
    BaseNameDataDao.fetch().then((BaseNameDataModel model) {
      baseNameDataModel = model;
      setState(() {});
    }).catchError((e) {});
  }

  void netContractBalance() {
    ContractInfoDao.fetch().then((ContractInfoModel model) {
      EasyLoading.dismiss(animation: true);
      if (model.code == 200) {
        AeTokenDefiPage.model = model;
        setState(() {});
      } else {}
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
//      Fluttertoast.showToast(msg: "????????????" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void showChainLoading() {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }

  Future<void> _onRefresh() async {
    netBaseNameData();
    netContractBalance();
    netBanner();
  }

  void netBanner() {
    BannerDao.fetch().then((BannerModel model) {
      bannerModel = model;
      setState(() {});
    }).catchError((e) {
      //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //????????????super
    return Container(
        child: EasyRefresh(
          header: BoxHeader(),
          onRefresh: _onRefresh,
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) =>
                  SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
              children: [
                Container(
                  height: 170,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 30,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      if (bannerModel != null)
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          onTap: () {
                            if (bannerModel == null) {
                              return;
                            }
                            _launchURL(
                              bannerModel == null
                                  ? ""
                                  : BoxApp.language == "cn"
                                  ? bannerModel!.cn!.url!
                                  : bannerModel!.en!.url!,
                            );
                          },
                          child: Container(
                            height: 170,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 30,
                            decoration: ShapeDecoration(
                              color: Colors.black12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              child: Image.network(
                                bannerModel == null
                                    ? ""
                                    : BoxApp.language == "cn"
                                    ? bannerModel!.cn!.image!
                                    : bannerModel!.en!.image!,
                                fit: BoxFit.cover,

                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    child: new Center(
                                      child: new CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
                                      ),
                                    ),
                                    width: 160.0,
                                    height: 90.0,
                                  );
                                },
                                //???????????????????????????
//                        fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 30,
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              color: Color(0x99000000),
                            ),
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                            margin: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
                            alignment: Alignment.center,
                            child: Text(
                              bannerModel == null
                                  ? "-"
                                  : BoxApp.language == "cn"
                                  ? bannerModel!.cn!.title!
                                  : bannerModel!.en!.title!,
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
//21000000
//10000000 > 200
//1000000
//

//                 Positioned(
//                   left: 15,
//                   child: Container(
//                     height: 170,
//                     margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
//                     decoration: new BoxDecoration(
//                       color: Color(0xE6FFFFFF),
//                       //?????????????????? ??????
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     width: MediaQuery.of(context).size.width,
//                     child: InkWell(
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       onTap: () {
//
// //                Navigator.push(
// //                    context,
// //                    MaterialPageRoute(
// //                        builder: (context) => WebPage(
// //                            url: bannerModel == null
// //                                ? ""
// //                                : BoxApp.language == "cn"
// //                                    ? bannerModel.cn.url
// //                                    : bannerModel.en.url,
// //                            title: BoxApp.language == "cn" ? bannerModel.cn.title : bannerModel.en.title)));
//                       },
//                     ),
//                   ),
//                 ),
                    ],
                  ),
                ),
//          if (!BoxApp.isOpenStore)
                Container(
                  height: 90,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  //????????????
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    //?????????????????? ??????
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      onTap: () {
                        goDefi(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: 88,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Image(
                                          width: 56,
                                          height: 56,
                                          image: AssetImage("images/home_financial.png"),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          S
                                              .of(context)
                                              .home_page_function_defi,
                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 18,
                                  child: Container(
                                    height: 30,
                                    margin: const EdgeInsets.only(top: 0),
                                    child: FlatButton(
                                      onPressed: () {
                                        goDefi(context);
                                      },
                                      child: Text(
                                        "GO",
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xff3460ee)),
                                      ),
                                      color: Color(0xff3460ee).withAlpha(16),
                                      textColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
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
                Container(
                  height: 90,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  //????????????
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    //?????????????????? ??????
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      onTap: () {
                        goSwap(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      height: 88,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Image(
                                              width: 56,
                                              height: 56,
                                              image: AssetImage("images/home_swap.png"),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .swap_title,
                                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 18,
                                  child: Container(
                                    height: 30,
                                    margin: const EdgeInsets.only(top: 0),
                                    child: FlatButton(
                                      onPressed: () {
                                        goSwap(context);
                                      },
                                      child: Text(
                                        "GO",
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                                      ),
                                      color: Color(0xFFE61665).withAlpha(16),
                                      textColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
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
                Container(
                  height: 130,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
                  //????????????
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    //?????????????????? ??????
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      onTap: () {
                        goNames(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Image(
                                          width: 56,
                                          height: 56,
                                          image: AssetImage("images/home_names.png"),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(
                                          S
                                              .of(context)
                                              .home_page_function_names,
                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 23,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    margin: const EdgeInsets.only(top: 23),
                                    padding: const EdgeInsets.only(left: 0),
                                    //????????????
                                    decoration: new BoxDecoration(
                                      color: Color(0xFFfafbfc),
                                      //?????????????????? ??????
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Color(0xFFCCCCCC),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(top: 0, left: 20),
                                      child: Text(
                                        S
                                            .of(context)
                                            .home_page_function_name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          wordSpacing: 30.0, //?????????
                                          color: Color(0xFF666666),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(top: 5, left: 20),
                                      child: Text(
                                        baseNameDataModel == null ? "-" : baseNameDataModel!.data!.sum.toString() + S
                                            .of(context)
                                            .home_page_function_name_count_number,
                                        style: TextStyle(
                                          fontSize: 19,
                                          letterSpacing: -1,
                                          //????????????
                                          fontWeight: FontWeight.w600,

                                          //?????????
                                          color: Color(0xFF000000),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(top: 0, left: 20),
                                      child: Text(
                                        S
                                            .of(context)
                                            .home_page_function_name_count + "(ae)",
                                        style: TextStyle(
                                          fontSize: 14,
                                          wordSpacing: 30.0, //?????????
                                          color: Color(0xFF666666),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(top: 5, left: 20),
                                      child: Text(
                                        baseNameDataModel == null ? "-" : baseNameDataModel!.data!.sumPrice.toString() + S
                                            .of(context)
                                            .home_page_function_name_count_number,
                                        style: TextStyle(
                                            fontSize: 19,
                                            letterSpacing: -1,
                                            //????????????
                                            fontWeight: FontWeight.w600,

                                            //?????????
                                            color: Color(0xFF000000),
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 86,
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S
                        .of(context)
                        .aepps_friend,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: BoxApp.language == "cn"
                          ? "Ubuntu"
                          : BoxApp.language == "cn"
                          ? "Ubuntu"
                          : "Ubuntu",
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: MediaQuery
                      .of(context)
                      .padding
                      .bottom),
                  padding: EdgeInsets.only(bottom: 16, top: 16),
                  //????????????
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    //?????????????????? ??????
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              showGeneralDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  pageBuilder: (con, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
                                  //barrierColor: Colors.grey.withOpacity(.4),
                                  barrierDismissible: true,
                                  barrierLabel: "",
                                  transitionDuration: Duration(milliseconds: 0),
                                  transitionBuilder: (transitionBuilderContext, anim1, anim2, child) {
                                    final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                                    return Material(
                                      type: MaterialType.transparency, //????????????
                                      child: Center(
                                        child: Container(
                                          height: 470,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width - 40,
                                          margin: EdgeInsets.only(bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom),
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
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width - 40,
                                                alignment: Alignment.topLeft,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.all(Radius.circular(60)),
                                                    onTap: () {
                                                      Navigator.pop(transitionBuilderContext); //???????????????
                                                      // ignore: unnecessary_statements
                                                      //                                  widget.dismissCallBackFuture("");
                                                    },
                                                    child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 20, right: 20),
                                                child: Text(
                                                  S
                                                      .of(context)
                                                      .dialog_privacy_hint,
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
                                                      S
                                                          .of(context)
                                                          .wetrue_risk,
                                                      style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 30, bottom: 20),
                                                child: TextButton(
                                                  //????????????????????????
                                                  style: ButtonStyle(
                                                    //???????????????????????????
                                                    shape: MaterialStateProperty.all(StadiumBorder()),
                                                    //?????????????????????
                                                    overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                                                    //????????????
                                                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                      //??????????????????????????????
                                                      if (states.contains(MaterialState.pressed)) {
                                                        return Color(0xFFFC2365).withAlpha(200);
                                                      }
                                                      //???????????????????????????
                                                      return Color(0xFFFC2365);
                                                    }),
                                                    //?????????????????????
                                                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                                                  ),

                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .dialog_privacy_confirm,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(transitionBuilderContext); //???????????????

                                                    if (Platform.isIOS) {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AeWetrueWebPage()));
                                                    } else {
                                                      Navigator.push(context, SlideRoute(AeWetrueWebPage()));
                                                    }
                                                  },
                                                ),
                                              ),

                                              //          Text(text),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 22, bottom: 22),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 16),
                                    height: 52,
                                    padding: EdgeInsets.all(6),
                                    width: 52,
                                    //????????????
                                    decoration: new BoxDecoration(
                                      //??????
                                      color: Colors.white,
                                      //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                      //??????????????????
                                      border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                    ),
                                    child: Image(
                                      width: 48,
                                      height: 48,
                                      image: AssetImage("images/apps_wetrue.png"),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 0, left: 20),
                                          child: Text(
                                            "WeTrue 2.0",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF333333),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                                          child: Text(
                                            S
                                                .of(context)
                                                .aepp_item_4_1,
                                            style: TextStyle(
                                              fontSize: 13,

                                              //????????????

                                              //?????????
                                              color: Color(0xFF666666),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL("https://aeknow.org");
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 18, bottom: 18),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 16),
                                    height: 52,
                                    width: 52,
                                    //????????????
                                    decoration: new BoxDecoration(
                                      //??????
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                                      //??????????????????
                                      border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image(
                                        width: 48,
                                        height: 48,
                                        image: AssetImage("images/ic_aeknow.png"),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 0, left: 20),
                                          child: Text(
                                            "AEKnow",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF333333),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                                          child: Text(
                                            S
                                                .of(context)
                                                .aepp_item_2_1,
                                            style: TextStyle(
                                              fontSize: 13,

                                              //????????????
                                              //?????????
                                              color: Color(0xFF666666),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL("https://superhero.com/");
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 22, bottom: 22),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 16),
                                    height: 52,
                                    padding: EdgeInsets.all(6),
                                    width: 52,
                                    //????????????
                                    decoration: new BoxDecoration(
                                      //??????
                                      color: Colors.white,
                                      //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                      //??????????????????
                                      border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                    ),
                                    child: Image(
                                      width: 48,
                                      height: 48,
                                      image: AssetImage("images/logo_superhero.png"),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 0, left: 20),
                                          child: Text(
                                            BoxApp.language == "cn" ? "????????????" : "SuperHero",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF333333),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                                          child: Text(
                                            S
                                                .of(context)
                                                .aepp_item_5_1,
                                            style: TextStyle(
                                              fontSize: 13,

                                              //????????????

                                              //?????????
                                              color: Color(0xFF666666),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              _launchURL("https://base.aepps.com/");
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 18, bottom: 18),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 16),
                                    height: 52,
                                    width: 52,
                                    //????????????
                                    decoration: new BoxDecoration(
                                      //??????
                                      color: Colors.white,
                                      //?????????????????? ?????? ???????????????????????? ???Container height ?????????
                                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                      //??????????????????
                                      border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image(
                                        width: 48,
                                        height: 48,
                                        image: AssetImage("images/base_logo.png"),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
                                          child: Text(
                                            "Base Wallet",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF333333),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                                          child: Text(
                                            S
                                                .of(context)
                                                .aepp_item_3_1,
                                            style: TextStyle(
                                              fontSize: 13,

                                              //????????????

                                              //?????????
                                              color: Color(0xFF666666),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 8,
                ),
              ],
            ),
          ),
        ));
  }

  void goNames(BuildContext context) {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (context, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Material(
            type: MaterialType.transparency, //????????????
            child: Center(
              child: Container(
                height: 470,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                margin: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          onTap: () {
                            Navigator.pop(context); //???????????????
                            // ignore: unnecessary_statements
                            //                                  widget.dismissCallBackFuture("");
                          },
                          child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        S
                            .of(context)
                            .dialog_privacy_hint,
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
                            S
                                .of(context)
                                .dialog_name_hint,
                            style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      child: TextButton(
                        //????????????????????????
                        style: ButtonStyle(
                          //???????????????????????????
                          shape: MaterialStateProperty.all(StadiumBorder()),
                          //?????????????????????
                          overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                          //????????????
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            //??????????????????????????????
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFFC2365).withAlpha(200);
                            }
                            //???????????????????????????
                            return Color(0xFFFC2365);
                          }),
                          //?????????????????????
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                        ),

                        child: Text(
                          S
                              .of(context)
                              .dialog_privacy_confirm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context); //???????????????

                          if (Platform.isIOS) {
                            Navigator.push(navigatorKey.currentState!.overlay!.context, MaterialPageRoute(builder: (context) => AeAensPage()));
                          } else {
                            Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(AeAensPage()));
                          }
                        },
                      ),
                    ),

                    //          Text(text),
                  ],
                ),
              ),
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Container();
        });
  }

  void goApp(BuildContext buildContext) {
    showGeneralDialog(
        useRootNavigator: false,
        context: buildContext,
        pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (context, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, 0, 0.0),
              child: Opacity(
                  opacity: anim1.value,
                  // ignore: missing_return
                  child: Material(
                    type: MaterialType.transparency, //????????????
                    child: Center(
                      child: Container(
                        height: 470,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        margin: EdgeInsets.only(bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 40,
                              alignment: Alignment.topLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(60)),
                                  onTap: () {
                                    Navigator.pop(context); //???????????????
                                    // ignore: unnecessary_statements
                                    //                                  widget.dismissCallBackFuture("");
                                  },
                                  child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                S
                                    .of(context)
                                    .dialog_privacy_hint,
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
                                    S
                                        .of(context)
                                        .dialog_name_hint,
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
                                onTap: (startLoading, stopLoading, btnState) {
                                  Navigator.pop(context); //???????????????

                                  showPay();
                                },
                                child: Text(
                                  S
                                      .of(context)
                                      .dialog_privacy_confirm,
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

                            //          Text(text),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }

  showPay() {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
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
                title: S
                    .of(context)
                    .password_widget_input_password,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  var aesDecode = Utils.aesDecode(signingKey, key);

                  if (aesDecode == "") {
                    showErrorDialog(context, null);
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AeAex2Page(
                                signingKey: aesDecode,
                                address: address,
                                title: BoxApp.language == "cn" ? "????????????" : "Governance",
//                                url: "https://superhero.com/voting",
                                url: "https://governance.aeternity.com/#/",
                              )));
                  // ignore: missing_return
                },
              ),
            ),
          );
        });
  }

  void goDefi(BuildContext context) {
    showDialog(
      context: context,

      //barrierColor: Colors.grey.withOpacity(.4),
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return Material(
            type: MaterialType.transparency, //????????????
            child: Center(
              child: Container(
                height: 470,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                margin: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          onTap: () async {
                            Navigator.of(context).pop(); //???????????????

                            // ignore: unnecessary_statements
                            //                                  widget.dismissCallBackFuture("");
                          },
                          child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        S
                            .of(context)
                            .dialog_privacy_hint,
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
                            S
                                .of(context)
                                .dialog_defi_hint,
                            style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      child: TextButton(
                        //????????????????????????
                        style: ButtonStyle(
                          //???????????????????????????
                          shape: MaterialStateProperty.all(StadiumBorder()),
                          //?????????????????????
                          overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                          //????????????
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            //??????????????????????????????
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFFC2365).withAlpha(200);
                            }
                            //???????????????????????????
                            return Color(0xFFFC2365);
                          }),
                          //?????????????????????
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                        ),

                        child: Text(
                          S
                              .of(context)
                              .dialog_privacy_confirm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          ),
                        ),
                        onPressed: () async {
                          final OkCancelResult result = await showOkAlertDialog(
                            context: context,
                            title: S
                                .of(context)
                                .dialog_defi_temp_hint,
                            message: S
                                .of(context)
                                .dialog_defi_temp_hint2,
                          );
                          if (result == OkCancelResult.ok) {
                            Navigator.of(context).pop(); //???????????????
                            if (Platform.isIOS) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AeTokenDefiPage()));
                            } else {
                              Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(AeTokenDefiPage()));
                            }
                          }
                        },
                      ),
                    ),

                    //          Text(text),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void goSwap(BuildContext buildContext) {
    showGeneralDialog(
        useRootNavigator: false,
        context: buildContext,
        pageBuilder: (con, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (transitionBuilderContext, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Material(
            type: MaterialType.transparency, //????????????
            child: Center(
              child: Container(
                height: 470,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                margin: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          onTap: () {
                            Navigator.pop(transitionBuilderContext); //???????????????
                            // ignore: unnecessary_statements
                            //                                  widget.dismissCallBackFuture("");
                          },
                          child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        S
                            .of(context)
                            .dialog_privacy_hint,
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
                            S
                                .of(context)
                                .dialog_swap_hint,
                            style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      child: TextButton(
                        //????????????????????????
                        style: ButtonStyle(
                          //???????????????????????????
                          shape: MaterialStateProperty.all(StadiumBorder()),
                          //?????????????????????
                          overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                          //????????????
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            //??????????????????????????????
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFFC2365).withAlpha(200);
                            }
                            //???????????????????????????
                            return Color(0xFFFC2365);
                          }),
                          //?????????????????????
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                        ),

                        child: Text(
                          S
                              .of(context)
                              .dialog_privacy_confirm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(transitionBuilderContext); //???????????????
                          if (Platform.isIOS) {
                            Navigator.push(navigatorKey.currentState!.overlay!.context, MaterialPageRoute(builder: (context) => AeSwapPage()));
                          } else {
                            Navigator.push(navigatorKey.currentState!.overlay!.context, SlideRoute(AeSwapPage()));
                          }
                        },
                      ),
                    ),

                    //          Text(text),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void showErrorDialog(BuildContext buildContext, String? content) {
    if (content == null) {
      content = S
          .of(buildContext)
          .dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(S
              .of(buildContext)
              .dialog_hint_check_error),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S
                    .of(buildContext)
                    .dialog_conform,
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
