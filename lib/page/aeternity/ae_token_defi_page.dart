import 'dart:io';
import 'dart:ui';

import 'package:box/dao/aeternity/account_info_dao.dart';
import 'package:box/dao/aeternity/contract_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/contract_info_model.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../main.dart';
import 'ae_defi_in_page.dart';
import 'ae_defi_ranking_page.dart';

class AeTokenDefiPage extends StatefulWidget {
  static ContractInfoModel model;

  @override
  _AeTokenDefiPageState createState() => _AeTokenDefiPageState();
}

class _AeTokenDefiPageState extends State<AeTokenDefiPage> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isInput = true;

  int day = 1;

  int dayCheckColor = 0x333A66F5;
  int dayTextCheckColor = 0xFF3561ef;
  int dayUnCheckColor = 0xFFF1f1f1;
  int dayTextUnCheckColor = 0xFF666666;

  int errorCount = 0;

  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Subscribe

    eventBus.on<DefiEvent>().listen((event) {
      netContractBalance();
    });
    netContractBalance();
    netAccountInfo();
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        token = model.data.balance;
        setState(() {});
      } else {}
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
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFeeeeee),
          body: Container(
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            image: AssetImage('images/defi_bg.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: MediaQueryData.fromWindow(window).padding.top + 55,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/defi_logo.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 18, top: 150, right: 18),
                              child: Text(
                                S.of(context).defi_title,
                                strutStyle: StrutStyle(forceStrutHeight: true, height: 1.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                style: new TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                              ),
                            ),
                            buildContainerCount(context),
                            Container(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                S.of(context).defi_card_hint_base,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 22, top: 10, right: 22),
                            ),
                            Container(
                              child: Text(
                                S.of(context).defi_card_hint_base_content,
                                strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                style:
                                    TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.5, color: Color(0xFF999999)),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 22, top: 10, right: 22),
                            ),
                            Container(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
//                   Positioned(
//                     top: 0,
//                     child: ClipRect(
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                         //图片模糊过滤，横向竖向都设置5.0
//                         child: Opacity(
//                           opacity: 0.5,
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: MediaQueryData.fromWindow(window).padding.top,
//                                 ),
//                                 Row(
//                                   children: <Widget>[
//                                     Material(
//                                       color: Colors.transparent,
//                                       child: InkWell(
//                                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Container(
//                                           height: 55,
//                                           width: 55,
//                                           padding: EdgeInsets.all(15),
//                                           child: Icon(
//                                             Icons.arrow_back_ios,
//                                             size: 17,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Container(),
//                                     ),
// //                                    Material(
// //                                      color: Colors.transparent,
// //                                      child: InkWell(
// //                                        borderRadius: BorderRadius.all(Radius.circular(30)),
// //                                        onTap: () {
// //                                          Navigator.push(context, SlideRoute( SettingsPage()));
// //                                        },
// //                                        child: Container(
// //                                          height: 50,
// //                                          width: 50,
// //                                          padding: EdgeInsets.all(15),
// //                                          child: Image(
// //                                            width: 36,
// //                                            height: 36,
// //                                            color: Colors.white,
// //                                            image: AssetImage('images/defi_info.png'),
// //                                          ),
// //                                        ),
// //                                      ),
// //                                    ),
// //                                    Material(
// //                                      color: Colors.transparent,
// //                                      child: InkWell(
// //                                        borderRadius: BorderRadius.all(Radius.circular(30)),
// //                                        onTap: () {
// //                                          if ("ak_2g2yq6RniwW1cjKRu4HdVVQXa5GQZkBaXiaVogQXnRxUKpmhS\",270824000000000000000],	[\"ak_3i4bwAbXBRHBqTDYFVLUSa8byQUeBAFzEgjfYk6rSyjWEXL3i\",259200000000000000000],	[\"ak_9XhfcrCtEyPFWPM3GVPC2BCFqetcYV3fDv3EjPpVdR9juAofA\",129600000000000000000],	[\"ak_ELsVMRbBe4LWEuqNU1pn2UCNpnNfdpHjRJjDFjT4R4yzRTeXt\",1390979520000000015854],	[\"ak_Evidt2ZUPzYYPWhestzpGsJ8uWzB1NgMpEvHHin7GCfgWLpjv\",499977516107119999999972654],	[\"ak_GUpbJyXiKTZB1zRM8Z8r2xFq26sKcNNtz6i83fvPUpKgEAgjH\",0],	[\"ak_QyFYYpgJ1vUGk1Lnk8d79WJEVcAtcfuNHqquuP2ADfxsL6yKx\",321088000000000000000],	[\"ak_V9SApNmgDGNLQcZWTzYb3PKtmFuwRn8ENdAg7WjZUdiwgkyUP\",84384000000000000000],	[\"ak_XtJGJrJuvxduT1HFMye4PuEkfUnU9L5rUE5CQ2F9MkqYQVr3f\",648000000000000000000],	[\"ak_fGPGYbqkEyWMV8R4tvQZznpzt28jb54EinF84TRSVCi997kiJ\",2448000000000000000],	[\"ak_o27hkgCTN2WZBkHd4vPcbfJPM2tzddv8xy1yaQnoyFEvqpZQK\",3596400000000000000],	[\"ak_tM5FE5HZSxUvDNAcBKMpSM9iXdsLviJ6tXffiH3BNpFrvgRoR\",383304960000000000000],	[\"ak_22HBW4s8HoCSa6ZKkd7CtFhs7vdBQ5Sgahi7FbRhp7xQ429WG2\",301216320000000007927],	[\"ak_25rsqRgVpcaD3fSZxCQVcyi4VNK3CTqf8CbzsnGtHCeu3ivrM1\",842670000000000000000],	[\"ak_281fyU5kV5yG6ZEgV9nnprLxRznSUKzxmgn2ZnxBhfD8ryWcuk\",128952000000000000000],	[\"ak_28LuZ8CG4LF6LvL47seA2GuCtaNEdXKiVMZP46ykYW8bEcuoVg\",13219200000000000000000],	[\"ak_294D9LQa95ckuJi5z7Who4TzKZWwEGimsyv1ZKM7osPE9c8Bx7\",521424000000000000000],	[\"ak_2JJNMYcnqPaABiSY5omockmv4cCoZefv4XzStAxKe9gM2xYz2r\",582912000000000000000],	[\"ak_2MHJv6JcdcfpNvu4wRDZXWzq8QSxGbhUfhMLR7vUPzRFYsDFw6\",977560560000000001188],	[\"ak_2UCUD59aWZyyhZzZbUdxoyP94r3mz9GvkH49HzJjsfC8MYqVPn\",81000000000000000000],	[\"ak_2Xu6d6W4UJBWyvBVJQRHASbQHQ1vjBA7d1XUeY8SwwgzssZVHK\",1955121120000000002377],	[\"ak_2gEL91xaQwvdN7psiCcGpSwcEMctTX1CVMT2g8f6NEp48tkvAr\",133164000000000000000],	[\"ak_2j2iyGwDnmiDZC9Dc2T8W371MYD9CQxDGSZ2Ne7WT2thY6q888\",213984000000000000000],	[\"ak_2mhBmzVv82SvtKATNBxfD1JhbLBrRNZZmah3QMqRkcK1SP3Bka\",33264000000000000000]"
// //                                              .contains(HomePage.address)) {
// //                                            Navigator.push(context, SlideRoute( DefiRecordsPage(isShowTitle: true)));
// //                                          } else {
// //                                            Navigator.push(context, SlideRoute( DefiRecordsPage(isShowTitle: false)));
// //                                          }
// //                                        },
// //                                        child: Container(
// //                                          height: 50,
// //                                          width: 50,
// //                                          padding: EdgeInsets.all(15),
// //                                          child: Image(
// //                                            width: 36,
// //                                            height: 36,
// //                                            color: Colors.white,
// //                                            image: AssetImage('images/defi_list.png'),
// //                                          ),
// //                                        ),
// //                                      ),
// //                                    ),
//                                     Container(
//                                       width: 10,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQueryData.fromWindow(window).padding.top,
                          ),
                          Row(
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 55,
                                    width: 55,
                                    padding: EdgeInsets.all(15),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              if (AeHomePage.address == "ak_QyFYYpgJ1vUGk1Lnk8d79WJEVcAtcfuNHqquuP2ADfxsL6yKx")
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    onTap: () {
                                      if (Platform.isIOS) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>AeDefiRankingPage()));
                                      } else {
                                        Navigator.push(context, SlideRoute( AeDefiRankingPage()));
                                      }

                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(15),
                                      child: Image(
                                        width: 36,
                                        height: 36,
                                        color: Colors.white,
                                        image: AssetImage('images/defi_info.png'),
                                      ),
                                    ),
                                  ),
                                ),
//                              Material(
//                                color: Colors.transparent,
//                                child: InkWell(
//                                  borderRadius: BorderRadius.all(Radius.circular(30)),
//                                  onTap: () {
//                                    if ("ak_2g2yq6RniwW1cjKRu4HdVVQXa5GQZkBaXiaVogQXnRxUKpmhS\",270824000000000000000],	[\"ak_3i4bwAbXBRHBqTDYFVLUSa8byQUeBAFzEgjfYk6rSyjWEXL3i\",259200000000000000000],	[\"ak_9XhfcrCtEyPFWPM3GVPC2BCFqetcYV3fDv3EjPpVdR9juAofA\",129600000000000000000],	[\"ak_ELsVMRbBe4LWEuqNU1pn2UCNpnNfdpHjRJjDFjT4R4yzRTeXt\",1390979520000000015854],	[\"ak_Evidt2ZUPzYYPWhestzpGsJ8uWzB1NgMpEvHHin7GCfgWLpjv\",499977516107119999999972654],	[\"ak_GUpbJyXiKTZB1zRM8Z8r2xFq26sKcNNtz6i83fvPUpKgEAgjH\",0],	[\"ak_QyFYYpgJ1vUGk1Lnk8d79WJEVcAtcfuNHqquuP2ADfxsL6yKx\",321088000000000000000],	[\"ak_V9SApNmgDGNLQcZWTzYb3PKtmFuwRn8ENdAg7WjZUdiwgkyUP\",84384000000000000000],	[\"ak_XtJGJrJuvxduT1HFMye4PuEkfUnU9L5rUE5CQ2F9MkqYQVr3f\",648000000000000000000],	[\"ak_fGPGYbqkEyWMV8R4tvQZznpzt28jb54EinF84TRSVCi997kiJ\",2448000000000000000],	[\"ak_o27hkgCTN2WZBkHd4vPcbfJPM2tzddv8xy1yaQnoyFEvqpZQK\",3596400000000000000],	[\"ak_tM5FE5HZSxUvDNAcBKMpSM9iXdsLviJ6tXffiH3BNpFrvgRoR\",383304960000000000000],	[\"ak_22HBW4s8HoCSa6ZKkd7CtFhs7vdBQ5Sgahi7FbRhp7xQ429WG2\",301216320000000007927],	[\"ak_25rsqRgVpcaD3fSZxCQVcyi4VNK3CTqf8CbzsnGtHCeu3ivrM1\",842670000000000000000],	[\"ak_281fyU5kV5yG6ZEgV9nnprLxRznSUKzxmgn2ZnxBhfD8ryWcuk\",128952000000000000000],	[\"ak_28LuZ8CG4LF6LvL47seA2GuCtaNEdXKiVMZP46ykYW8bEcuoVg\",13219200000000000000000],	[\"ak_294D9LQa95ckuJi5z7Who4TzKZWwEGimsyv1ZKM7osPE9c8Bx7\",521424000000000000000],	[\"ak_2JJNMYcnqPaABiSY5omockmv4cCoZefv4XzStAxKe9gM2xYz2r\",582912000000000000000],	[\"ak_2MHJv6JcdcfpNvu4wRDZXWzq8QSxGbhUfhMLR7vUPzRFYsDFw6\",977560560000000001188],	[\"ak_2UCUD59aWZyyhZzZbUdxoyP94r3mz9GvkH49HzJjsfC8MYqVPn\",81000000000000000000],	[\"ak_2Xu6d6W4UJBWyvBVJQRHASbQHQ1vjBA7d1XUeY8SwwgzssZVHK\",1955121120000000002377],	[\"ak_2gEL91xaQwvdN7psiCcGpSwcEMctTX1CVMT2g8f6NEp48tkvAr\",133164000000000000000],	[\"ak_2j2iyGwDnmiDZC9Dc2T8W371MYD9CQxDGSZ2Ne7WT2thY6q888\",213984000000000000000],	[\"ak_2mhBmzVv82SvtKATNBxfD1JhbLBrRNZZmah3QMqRkcK1SP3Bka\",33264000000000000000]"
//                                        .contains(HomePage.address)) {
//                                      Navigator.push(context, SlideRoute( DefiRecordsPage(isShowTitle: true)));
//                                    } else {
//                                      Navigator.push(context, SlideRoute( DefiRecordsPage(isShowTitle: false)));
//                                    }
//                                  },
//                                  child: Container(
//                                    height: 50,
//                                    width: 50,
//                                    padding: EdgeInsets.all(15),
//                                    child: Image(
//                                      width: 36,
//                                      height: 36,
//                                      color: Colors.white,
//                                      image: AssetImage('images/defi_list.png'),
//                                    ),
//                                  ),
//                                ),
//                              ),
                              Container(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Container buildContainerCount(BuildContext context) {
    if (!isInput) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
//      height: 355,
      margin: const EdgeInsets.only(top: 38, left: 18, right: 18),
      //边框设置
      padding: const EdgeInsets.only(bottom: 30),
//                              height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
          color: Color(0xFFFFFFFF),
//          color: Color(0xE6FFFFFF),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: []),
      child: Column(
        children: [
          Container(
//            width: MediaQuery.of(context).size.width,
//            height: 155,
//            margin: const EdgeInsets.all(0),
//            //边框设置
//            decoration: new BoxDecoration(
////                                      color: Color(0xFFEEEEEE),
//              //设置四周圆角 角度
//              borderRadius: BorderRadius.all(Radius.circular(0.0)),
//
//              //设置四周边框
//            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    S.of(context).defi_card_my_get_hint,
                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF666666)),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, top: 18),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          AeTokenDefiPage.model == null ? "loading..." : "≈" + AeTokenDefiPage.model.data.token,
                          style: new TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: 1.5, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xff3460ee)),
//                    style: new TextStyle(fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: 1.5, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Colors.black),
                        ),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 18, top: 5),
                      ),
                      Expanded(child: Container()),
                      beBtn(),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 18),
                    child: Container(
                      color: Color(0xFFEEEEEE),
                    ),
                    padding: EdgeInsets.only(left: 18, right: 18),
                    height: 1.0,
                    color: Color(0xFFFFFFFF)),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
//                        width: MediaQuery.of(context).size.width / 2 - 40 ,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                S.of(context).defi_head_card_my_token,
                                style:
                                    new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF666666)),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 18, top: 10),
                            ),
                            Container(
                              child: Text(
                                AeTokenDefiPage.model == null ? "loading..." : double.parse(AeTokenDefiPage.model.data.count).toStringAsFixed(2),
                                style: new TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    color: Color(0xff000000)),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 18, top: 5),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
//                        width: MediaQuery.of(context).size.width /2-40 ,
                        margin: EdgeInsets.only(right: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                S.of(context).defi_head_card_all_token,
                                style:
                                    new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF666666)),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 18, top: 10),
                            ),
                            Container(
                              child: Text(
                                AeTokenDefiPage.model == null ? "loading..." : AeTokenDefiPage.model.data.allCount + "",
                                style: new TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                    color: Color(0xff000000)),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 18, top: 5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                lockBtn(),
                unLockBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container beBtn() {
    if (AeTokenDefiPage.model == null || AeTokenDefiPage.model.data.height == -1) {
      return Container();
    }
    return Container(
      height: 30,
      margin: const EdgeInsets.only(right: 20, top: 5),
      child: FlatButton(
        onPressed: () {
          if (AeTokenDefiPage.model.data.token == null) {
            return;
          }
          if (AeTokenDefiPage.model.data.afterHeight <= AeTokenDefiPage.model.data.minHeight) {
            var waitHeight = (AeTokenDefiPage.model.data.minHeight + 1 - AeTokenDefiPage.model.data.afterHeight) * 3;

            showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                  title: Text(S.of(context).dialog_hint),
                  content: Text(S.of(context).dialog_defi_wait1 +" "+ waitHeight.toString()+" " + S.of(context).dialog_defi_wait2),
                  actions: <Widget>[
                    TextButton(
                      child: new Text(
                        S.of(context).dialog_conform,
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                      },
                    ),
                  ],
                );
              },
            ).then((val) {});
            return;
          }
          showGeneralDialog(useRootNavigator:false,
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
                         showErrorDialog(context, null);
                          return;
                        }
                        // ignore: missing_return
                        BoxApp.contractDefiV2Benefits((tx) {
                          netContractBalance();
                          eventBus.fire(DefiEvent());
                          if ("-1" == tx) {

                            showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                                return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                  title: Text(S.of(context).dialog_hint),
                                  content: Text(S.of(context).dialog_defi_blacklist),
                                  actions: <Widget>[
                                    TextButton(
                                      child: new Text(
                                        S.of(context).dialog_conform,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((val) {});
                            return;
                          }


                          showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                              return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                title: Text(S.of(context).dialog_defi_get),
                                content: Text(S.of(context).dialog_defi_get_msg + (double.parse(tx) / 1000000000000000000).toString() + "ABC"),
                                actions: <Widget>[
                                  TextButton(
                                    child: new Text(
                                      S.of(context).dialog_conform,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {});






                          // ignore: missing_return
                        }, (error) {
                         showErrorDialog(context, error);
                        }, aesDecode, address, BoxApp.DEFI_CONTRACT_V3);

                        showChainLoading();
                      },
                    ),
                  ),
                );
              });
        },
        child: Text(
          S.of(context).defi_card_get,
          maxLines: 1,
          style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xff3460ee)),
        ),
        color: Color(0xff3460ee).withAlpha(40),
        textColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Container lockBtn() {
    if (AeTokenDefiPage.model == null || AeTokenDefiPage.model.data.height != -1) {
      return Container();
    }
    return Container(
      height: 48,
      width: 260,
      margin: EdgeInsets.only(top: 40),
      child: FlatButton(
        onPressed: () {
          if (Platform.isIOS) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>AeDefiInPage()));
          } else {
            Navigator.push(context, SlideRoute( AeDefiInPage()));
          }

        },
        child: Text(
          S.of(context).defi_card_mine,
          maxLines: 1,
          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
        ),
        color: Color(0xff3460ee),
        textColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Container unLockBtn() {
    if (AeTokenDefiPage.model == null || AeTokenDefiPage.model.data.height == -1) {
      return Container();
    }

    return Container(
      height: 48,
      width: 260,
      margin: EdgeInsets.only(top: 40),
      child: FlatButton(
        onPressed: () {
          if (AeTokenDefiPage.model.data.afterHeight > AeTokenDefiPage.model.data.minHeight) {

            showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                  title: Text(S.of(context).dialog_hint),
                  content: Text(S.of(context).dialog_ae_no_get),
                  actions: <Widget>[
                    TextButton(
                      child: new Text(
                        S.of(context).dialog_dismiss,
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                      },
                    ),
                    TextButton(
                      child: new Text(
                        S.of(context).dialog_conform,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context, rootNavigator: true).pop();
                        showGeneralDialog(useRootNavigator:false,
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
                                        showErrorDialog(context, null);
                                        return;
                                      }
                                      // ignore: missing_return
                                      BoxApp.contractDefiV2UnLock((tx) {
                                        netContractBalance();
                                        eventBus.fire(DefiEvent());

                                        showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                                            return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                              title: Text(S.of(context).dialog_unlock_sucess),
                                              content: Text(S.of(context).dialog_unlock_sucess_msg + (double.parse(tx) / 1000000000000000000).toString() + "AE"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: new Text(
                                                    S.of(context).dialog_conform,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((val) {});


                                        // ignore: missing_return
                                      }, (error) {
                                        showErrorDialog(context, error);
                                      }, aesDecode, address, BoxApp.DEFI_CONTRACT_V3, "0");

                                      showChainLoading();
                                    },
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ],
                );
              },
            ).then((val) {});
            return;
          } else {
            showGeneralDialog(useRootNavigator:false,
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
                           showErrorDialog(context, null);
                            return;
                          }
                          // ignore: missing_return
                          BoxApp.contractDefiV2UnLock((tx) {
                            netContractBalance();
                            eventBus.fire(DefiEvent());

                            showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                                return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                  title: Text(S.of(context).dialog_hint),
                                  content: Text(S.of(context).dialog_unlock_sucess),
                                  actions: <Widget>[
                                    TextButton(
                                      child: new Text(
                                        S.of(context).dialog_conform,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((val) {});

                            return;
                            // ignore: missing_return
                          }, (error) {
                            showErrorDialog(context, error);
                          }, aesDecode, address, BoxApp.DEFI_CONTRACT_V3, "0");

                          showChainLoading();
                        },
                      ),
                    ),
                  );
                });
          }
        },
        child: Text(
          S.of(context).defi_card_out,
          maxLines: 1,
          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xff3460ee)),
        ),
        color: Color(0xff3460ee).withAlpha(40),
        textColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void showChainLoading() {
    showGeneralDialog(useRootNavigator:false,
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

  void showCopyHashDialog(BuildContext buildContext, String tx) {
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
          title: Text(S.current.dialog_hint_hash),
          content: Text(tx),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_copy,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: tx));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_dismiss,
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
