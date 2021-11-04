import 'dart:io';
import 'dart:ui';

import 'package:box/dao/aeternity/banner_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/banner_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_dapp_list_model.dart';
import 'package:box/page/confux/cfx_nft_page.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'cfx_apps_page.dart';
import 'cfx_nft_new_page.dart';


class CfxDappsPage extends StatefulWidget {
  @override
  _CfxDappsPageState createState() => _CfxDappsPageState();
}

class _CfxDappsPageState extends State<CfxDappsPage> with AutomaticKeepAliveClientMixin {
  BannerModel bannerModel;
  CfxDappListModel cfxDappListModel;
  List<Widget> childrens = List<Widget>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netBanner();
    eventBus.on<LanguageEvent>().listen((event) {
      netBanner();
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EasyRefresh(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width - 36,
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
                                  ? bannerModel.cn.url
                                  : bannerModel.en.url,
                            );
                          },
                          child: Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width - 30,
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
                        ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
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
                                  ? bannerModel.cn.title
                                  : bannerModel.en.title,
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 0, top: 16, bottom: 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    S.of(context).CfxDappPage_title_nft,
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
                  margin: const EdgeInsets.only(top: 16, left: 15, right: 15),
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
                        if (Platform.isIOS) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CfxNftNewPage()));
                        } else {
                          Navigator.push(context, SlideRoute(CfxNftNewPage()));
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
                                          image: AssetImage("images/home_nft.png"),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(
                                          "NFTs",
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
                                      margin: const EdgeInsets.only(top: 5, left: 20,right: 20),
                                      child: Text(
                                        S.of(context).CfxDappPage_nft_content,
                                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.6, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1.2,
                                          color: Color(0xFF666666),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10, left: 20, bottom: 18),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF37A1DB).withAlpha(16),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                                S.of(context).CfxDappPage_nft_tab1,
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1.2,
                                                //字体间距

                                                //词间距
                                                color: Color(0xFF37A1DB),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF37A1DB).withAlpha(16),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                              S.of(context).CfxDappPage_nft_tab2,
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1.2,
                                                //字体间距

                                                //词间距
                                                color: Color(0xFF37A1DB),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF37A1DB).withAlpha(16),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                              S.of(context).CfxDappPage_nft_tab3+"...",
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1.2,
                                                //字体间距

                                                //词间距
                                                color: Color(0xFF37A1DB),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 0, top: 16, bottom: 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Conflux Dapps",
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
                  margin: const EdgeInsets.only(top: 16, left: 15, right: 15),
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
                      onTap: () async {

                        var currentAccount =await WalletCoinsManager.instance.getCurrentAccount();
                        if(currentAccount.accountType == AccountType.ADDRESS){
                          showGeneralDialog(
                              useRootNavigator: false,
                              context: context,
                              pageBuilder: (context, anim1, anim2) {
                                return;
                              },
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
                                      child: PayPasswordWidget(
                                          title: S.of(context).password_widget_input_password,
                                          passwordCallBackFuture: (String password) async {

                                            return;
                                          }),
                                    ));
                              });
                          return;
                        }

                        if (Platform.isIOS) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CfxAppsPage()));
                        } else {
                          Navigator.push(context, SlideRoute(CfxAppsPage()));
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
                                          S.of(context).CfxDappPage_app,
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
                                      margin: const EdgeInsets.only(top: 0, left: 20,right: 20),
                                      child: Text(
                                        S.of(context).CfxDappPage_app_content,
                                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.6, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1.2,

                                          color: Color(0xFF666666),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8, left: 20, bottom: 18),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF37A1DB).withAlpha(16),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                              "MoonSwap",
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1.2,
                                                //字体间距

                                                //词间距
                                                color: Color(0xFF37A1DB),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF37A1DB).withAlpha(16),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                              "Trust",
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1.2,
                                                //字体间距

                                                //词间距
                                                color: Color(0xFF37A1DB),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF37A1DB).withAlpha(16),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                              "NFTBox...",
                                              style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 1.2,
                                                //字体间距

                                                //词间距
                                                color: Color(0xFF37A1DB),
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
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



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
