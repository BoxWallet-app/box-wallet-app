import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/banner_dao.dart';
import 'package:box/dao/base_name_data_dao.dart';
import 'package:box/dao/contract_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/banner_model.dart';
import 'package:box/model/base_name_data_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/page/swap_my_page.dart';
import 'package:box/page/swap_page.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/page/web_page.dart';
import 'package:box/page/wetrue_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/ae_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import 'aens_my_page.dart';
import 'aens_page.dart';
import 'base_page.dart';
import 'know_page.dart';

class AeppsPageV2 extends StatefulWidget {
  @override
  _AeppsPageV2State createState() => _AeppsPageV2State();
}

class _AeppsPageV2State extends State<AeppsPageV2> with AutomaticKeepAliveClientMixin {
  BaseNameDataModel baseNameDataModel;
  BannerModel bannerModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netBaseNameData();
    netContractBalance();
    netBanner();
    eventBus.on<LanguageEvent>().listen((event) {
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
        TokenDefiPage.model = model;
        setState(() {});
      } else {}
    }).catchError((e) {
      print(e.toString());
      EasyLoading.dismiss(animation: true);
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
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

  Future<void> _onRefresh() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: EasyRefresh(
      header: AEHeader(),
      onRefresh: _onRefresh,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
            decoration: new BoxDecoration(
              color: Color(0xE6FFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              onTap: () {
                if (bannerModel == null) {
                  return;
                }
                if (BoxApp.isOpenStore){
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebPage(
                            url: bannerModel == null
                                ? ""
                                : BoxApp.language == "cn"
                                    ? bannerModel.cn.url
                                    : bannerModel.en.url,
                            title: BoxApp.language == "cn" ? bannerModel.cn.title : bannerModel.en.title)));
              },
              child: Column(
                children: [
                  if (!BoxApp.isOpenStore)
                    Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width - 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
                        child: Image.network(
                          bannerModel == null
                              ? ""
                              : BoxApp.language == "cn"
                                  ? bannerModel.cn.image
                                  : bannerModel.en.image,
                          fit: BoxFit.cover,

                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Container(
                              alignment: Alignment.center,
                              child: new Center(
                                child: new CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
                                ),
                              ),
                              width: 160.0,
                              height: 90.0,
                            );
                          },
                          //设置图片的填充样式
//                        fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bannerModel == null
                          ? "-"
                          : BoxApp.language == "cn"
                              ? bannerModel.cn.title
                              : bannerModel.en.title,
                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!BoxApp.isOpenStore)
            Container(
              height: 90,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
              //边框设置
              decoration: new BoxDecoration(
                color: Color(0xE6FFFFFF),
                //设置四周圆角 角度
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
                              height: 90,
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
                                      S.of(context).home_page_function_defi,
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
          if (!BoxApp.isOpenStore)
            Container(
              height: 90,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
              //边框设置
              decoration: new BoxDecoration(
                color: Color(0xE6FFFFFF),
                //设置四周圆角 角度
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
                            Container(
                              height: 90,
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
                                      S.of(context).swap_title,
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
            //边框设置
            decoration: new BoxDecoration(
              color: Color(0xE6FFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                onTap: () {
                  if (BoxApp.isOpenStore){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AensMyPage()));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AensPage()));
                  }

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
                                    S.of(context).home_page_function_names,
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
                              //边框设置
                              decoration: new BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                //设置四周圆角 角度
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
                                  S.of(context).home_page_function_name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    wordSpacing: 30.0, //词间距
                                    color: Color(0xFF666666),
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  baseNameDataModel == null ? "-" : baseNameDataModel.data.sum.toString() + S.of(context).home_page_function_name_count_number,
                                  style: TextStyle(
                                    fontSize: 19,
                                    letterSpacing: -1,
                                    //字体间距
                                    fontWeight: FontWeight.w600,

                                    //词间距
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
                                  S.of(context).home_page_function_name_count + "(ae)",
                                  style: TextStyle(
                                    fontSize: 14,
                                    wordSpacing: 30.0, //词间距
                                    color: Color(0xFF666666),
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  baseNameDataModel == null ? "-" : baseNameDataModel.data.sumPrice.toString() + S.of(context).home_page_function_name_count_number,
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
          if (!BoxApp.isOpenStore)
            Container(
              height: 48,
              margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).aepps_friend,
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
          if (!BoxApp.isOpenStore)
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: MediaQuery.of(context).padding.bottom),
              padding: EdgeInsets.only(bottom: 16, top: 16),
              //边框设置
              decoration: new BoxDecoration(
                color: Color(0xE6FFFFFF),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Column(
                    children: [
                      if (!BoxApp.isOpenStore)
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WeTruePage()));
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
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    //设置四周边框
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
                                          "Wetrue",
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
                                          S.of(context).aepp_item_4_1,
                                          style: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: 1,
                                            //字体间距

                                            //词间距
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
                      if (!BoxApp.isOpenStore)
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BasePage()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 18, bottom: 18),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 16),
                                  height: 52,
                                  width: 52,
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    //设置四周边框
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
                                          "Base wallet",
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
                                          S.of(context).aepp_item_3_1,
                                          style: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: 1,
                                            //字体间距

                                            //词间距
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => KnowPage()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 18, bottom: 18),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                height: 52,
                                width: 52,
                                //边框设置
                                decoration: new BoxDecoration(
                                  //背景
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  //设置四周边框
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
                                        "Aeknow",
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
                                        S.of(context).aepp_item_2_1,
                                        style: TextStyle(
                                          fontSize: 13,
                                          letterSpacing: 1,
                                          //字体间距
                                          //词间距
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
    )));
  }

  void goDefi(BuildContext context) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
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
                                S.of(context).dialog_privacy_hint,
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
                                    S.of(context).dialog_defi_hint,
                                    style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", letterSpacing: 2, height: 2),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDefiPage()));
                                },
                                child: Text(
                                  S.of(context).dialog_privacy_confirm,
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

  void goSwap(BuildContext buildContext) {
    showGeneralDialog(
        context: context,
        pageBuilder: (con, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (transitionBuilderContext, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
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
                                    Navigator.pop(transitionBuilderContext); //关闭对话框
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
                                S.of(context).dialog_privacy_hint,
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
                                    S.of(context).dialog_swap_hint,
                                    style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", letterSpacing: 2, height: 2),
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
                                  Navigator.pop(transitionBuilderContext); //关闭对话框
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SwapPage()));
                                },
                                child: Text(
                                  S.of(context).dialog_privacy_confirm,
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
