import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:box/dao/aeternity/banner_dao.dart';
import 'package:box/dao/conflux/cfx_dapp_list_dao.dart';
import 'package:box/dao/ethereum/eth_dapp_list_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/plugin_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/banner_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_dapp_list_model.dart';
import 'package:box/page/confux/cfx_nft_page.dart';
import 'package:box/page/web_page.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../dapp_webview_page.dart';

class EthDappsPage extends StatefulWidget {
  @override
  _EthDappsPageState createState() => _EthDappsPageState();
}

class _EthDappsPageState extends State<EthDappsPage> with AutomaticKeepAliveClientMixin {
  BannerModel? bannerModel;
  DappListModel? cfxDappListModel;
  List<Widget> childrens = <Widget>[];
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
    eventBus.on<LanguageEvent>().listen((event) {
      _onRefresh();
    });
    eventBus.on<AccountUpdateEvent>().listen((event) {
      cfxDappListModel = null;
      childrens.clear();
      if(!mounted)return;
      setState(() {

      });
      _onRefresh();
    });
  }

  void netDapp() {
    EthDappListDao.fetch(BoxApp.language).then((DappListModel model) {
      cfxDappListModel = model;
      updateData();
      setState(() {});
    }).catchError((e) {
      //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void updateData() {
    if (cfxDappListModel == null) {
      return;
    }
    childrens.clear();
    for (var i = 0; i < cfxDappListModel!.data!.length; i++) {
      var groupTitle = getGroupTitle(cfxDappListModel!.data![i].type!);
      childrens.add(groupTitle);
      for (var j = 0; j < cfxDappListModel!.data![i].dataList!.length; j++) {
        var childItem = getChildItem(cfxDappListModel!.data![i].dataList![j]);
        childrens.add(childItem);
      }
    }
  }

  Container getChildItem(DataList data) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 12),
      //边框设置
      decoration: new BoxDecoration(
        color: Color(0xE6FFFFFF),
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                onTap: () async {
                  var currentAccount = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
                  if (currentAccount.accountType == AccountType.ADDRESS) {
                    showGeneralDialog(
                        useRootNavigator: false,
                        context: context,
                        pageBuilder: (context, anim1, anim2) {
                          return;
                        } as Widget Function(BuildContext, Animation<double>, Animation<double>),
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

                  showGeneralDialog(
                      useRootNavigator: false,
                      context: context,
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
                                                onTap: () async {
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
                                                  S.of(context).cfx_dapp_mag1 + " " + data.name! + " " + S.of(context).cfx_dapp_mag2,
                                                  style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 30, bottom: 20),
                                            child: TextButton(
                                              //定义一下文本样式
                                              style: ButtonStyle(
                                                //更优美的方式来设置
                                                shape: MaterialStateProperty.all(StadiumBorder()),
                                                //设置水波纹颜色
                                                overlayColor: MaterialStateProperty.all(Color(0xFFFC2365).withAlpha(150)),

                                                //背景颜色
                                                backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                  //设置按下时的背景颜色
                                                  if (states.contains(MaterialState.pressed)) {
                                                    return Color(0xFFFC2365).withAlpha(200);
                                                  }
                                                  //默认不使用背景颜色
                                                  return Color(0xFFFC2365);
                                                }),
                                                //设置按钮内边距
                                                padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                                              ),

                                              child: Text(
                                                S.of(context).dialog_privacy_confirm,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                ),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context); //关闭对话框
                                                if (Platform.isIOS) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DappWebViewPage(title: data.name,url: data.url,)));
                                                } else {
                                                  Navigator.push(context, SlideRoute(DappWebViewPage(title: data.name,url: data.url,)));
                                                }

                                                // if (Platform.isAndroid) {
                                                //   String resultString;
                                                //   try {
                                                //     resultString = await PluginManager.pushCfxWebViewActivity({'url': data.url, 'address': await BoxApp.getAddress(), 'language': await BoxApp.getLanguage(), 'signingKey': await BoxApp.getSigningKey()});
                                                //   } on PlatformException {
                                                //     resultString = '失败';
                                                //   }
                                                //   // print(resultString);
                                                //   return;
                                                // }

                                                // Navigator.push(
                                                //     navigatorKey.currentState.overlay.context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => CfxRpcPage(
                                                //               url: data.url,
                                                //             )));
                                              },
                                            ),
                                          ),

                                          //          Text(text),
                                        ],
                                      ),
                                    ),
                                  ),
                                )));
                      });
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 18, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
                            child: Text(
                              data.name!,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                height: 45,
                                width: 45,
                                //边框设置
                                decoration: new BoxDecoration(
                                  //背景
                                  color: Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  //设置四周边框
                                  border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    data.icon!,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 0),
                      child: Text(
                        data.content!,
                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        style: TextStyle(color: Color(0xFF666666),  fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, left: 20, bottom: 18),
                      child: Row(
                        children: getTabs(data.tabs!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getTabs(List<String> tabs) {
    List<Widget> tabsWidget = <Widget>[];
    for (var i = 0; i < tabs.length; i++) {
      tabsWidget.add(Container(
        margin: const EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        decoration: new BoxDecoration(
          color: Color(0xFF37A1DB).withAlpha(16),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(
          tabs[i],
          style: TextStyle(
            fontSize: 14,

            //字体间距

            //词间距
            color: Color(0xFF37A1DB),
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
      ));
    }
    return tabsWidget;
  }

  Container getGroupTitle(String title) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
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
    );
  }

  Future<void> _onRefresh() async {
    netBanner();
    netDapp();
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
          child: EasyRefresh(
        onRefresh: _onRefresh,
        header: BoxHeader(),
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
                                    ? bannerModel!.cn!.url!
                                    : bannerModel!.en!.url!,
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
                          child: bannerModel == null
                              ? Container()
                              : ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  child: Image.network(
                                    bannerModel == null
                                        ? ""
                                        : BoxApp.language == "cn"
                                            ? bannerModel!.cn!.image!
                                            : bannerModel!.en!.image!,
                                    fit: BoxFit.cover,

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
                                    ? bannerModel!.cn!.title!
                                    : bannerModel!.en!.title!,
                            style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              getGroupTitle(S.of(context).input_search),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 12),
                //边框设置
                decoration: new BoxDecoration(
                  color: Color(0xE6FFFFFF),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          onTap: () async {
                            var currentAccount = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
                            if (currentAccount.accountType == AccountType.ADDRESS) {
                              showGeneralDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    return;
                                  } as Widget Function(BuildContext, Animation<double>, Animation<double>),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WebPage()));
                            } else {
                              Navigator.push(context, SlideRoute(WebPage()));
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 18, bottom: 5),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
                                      child: Text(
                                        S.of(context).CfxDappsPage_browser,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF333333),
                                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 20),
                                          height: 45,
                                          width: 45,
                                          //边框设置
                                          decoration: new BoxDecoration(
                                            //背景
                                            color: Colors.white,
                                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            //设置四周边框
                                            border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.network(
                                              Platform.isIOS ? "https://ae-source.oss-cn-hongkong.aliyuncs.com/ic_web_ios.png" : "https://ae-source.oss-cn-hongkong.aliyuncs.com/ic_web_android.png",
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 18),
                                child: Text(
                                  S.of(context).CfxDappsPage_browser_content,
                                  strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                  style: TextStyle(color: Color(0xFF666666),  fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
              if (childrens.isEmpty)
                Center(
                  child: Container(
                      height: 200,
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
                            'images/loading.json',
//              'images/animation_khzuiqgg.json',
                            onLoaded: (composition) {
                              // Configure the AnimationController with the duration of the
                              // Lottie file and start the animation.
                            },
                          ),
                        ),
                      )),
                ),
              Column(
                children: childrens,
              ),

              Container(
                height: MediaQueryData.fromWindow(window).padding.bottom + 12,
              ),
              Container(
                height: 8,
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
