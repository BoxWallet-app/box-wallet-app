import 'dart:async';
import 'dart:ui';
import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/base_data_dao.dart';
import 'package:box/dao/base_name_data_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/version_dao.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/base_data_model.dart';
import 'package:box/model/base_name_data_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/version_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/login_page.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/page/tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/password_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'aens_register.dart';
import 'mnemonic_copy_page.dart';

class HomePage extends StatefulWidget {
  static var token = "loading...";
  static var tokenABC = "loading...";
  static var height = 0;
  static var address = "";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TextEditingController _textEditingController = TextEditingController();
  var loadingType = LoadingType.loading;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  final pageController = PageController(viewportFraction: 1);
  final pageControllerBg = PageController(viewportFraction: 1);
  WalletTransferRecordModel walletRecordModel;
  BlockTopModel blockTopModel;
  BaseDataModel baseDataModel;
  BaseNameDataModel baseNameDataModel;

  var address = '';
  var page = 1;

  var contentText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    showHint();
    getAddress();
    netContractBalance();
    netAccountInfo();
    netBaseData();
    netTopHeightData();
    netBaseNameData();
    netVersion();
  }

  void showHint() {
    Future.delayed(Duration.zero, () {
      BoxApp.getMnemonic().then((account) {
        if (account != null && account.length > 0) {
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text(
                S.of(context).dialog_save_word,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontFamily: "Ubuntu",
                ),
              ),
              content: Text(
                S.of(context).dialog_save_word_hint,
                style: TextStyle(
                  color: Color(0xFF000000),
                  height: 1.2,
                  fontFamily: "Ubuntu",
                ),
              ),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    S.of(context).dialog_dismiss,
                    style: TextStyle(
                      color: Color(0xFFFC2365),
                      fontFamily: "Ubuntu",
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                BasicDialogAction(
                  title: Text(
                    S.of(context).dialog_save_go,
                    style: TextStyle(
                      color: Color(0xFFFC2365),
                      fontFamily: "Ubuntu",
                    ),
                  ),
                  onPressed: () {
                    showGeneralDialog(
                        context: context,
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
                                  var mnemonic = await BoxApp.getMnemonic();
                                  if (mnemonic == "") {
                                    showPlatformDialog(
                                      context: context,
                                      builder: (_) => BasicDialogAlert(
                                        title: Text(S.of(context).dialog_hint),
                                        content: Text(S.of(context).dialog_login_user_no_save),
                                        actions: <Widget>[
                                          BasicDialogAction(
                                            title: Text(
                                              S.of(context).dialog_conform,
                                              style: TextStyle(color: Color(0xFFFC2365)),
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
                                  var address = await BoxApp.getAddress();
                                  final key = Utils.generateMd5Int(password + address);
                                  var aesDecode = Utils.aesDecode(mnemonic, key);

                                  if (aesDecode == "") {
                                    showPlatformDialog(
                                      context: context,
                                      builder: (_) => BasicDialogAlert(
                                        title: Text(S.of(context).dialog_hint_check_error),
                                        content: Text(S.of(context).dialog_hint_check_error_content),
                                        actions: <Widget>[
                                          BasicDialogAction(
                                            title: Text(
                                              S.of(context).dialog_conform,
                                              style: TextStyle(color: Color(0xFFFC2365)),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MnemonicCopyPage(mnemonic: aesDecode)));
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          );
        }
      });
    });
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        print(model.data.balance);
        // HomePage.token = "8888.88888";
        HomePage.token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netContractBalance() {
    ContractBalanceDao.fetch().then((ContractBalanceModel model) {
      if (model.code == 200) {
        HomePage.tokenABC = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netWalletRecord() {
    WalletRecordDao.fetch(page).then((WalletTransferRecordModel model) {
      loadingType = LoadingType.finish;
      if (model.code == 200) {
        if (page == 1) {
          page++;
          if (model.data == null || model.data.length == 0) {
            loadingType = LoadingType.no_data;
            _easyRefreshController.finishRefresh();
            _easyRefreshController.finishLoad();
            setState(() {});
            return;
          }
          walletRecordModel = model;
        } else {
          walletRecordModel.data.addAll(model.data);
        }

        setState(() {});
      } else {}
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netBaseNameData() {
    BaseNameDataDao.fetch().then((BaseNameDataModel model) {
      baseNameDataModel = model;
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void netVersion() {
    VersionDao.fetch().then((VersionModel model) {
      print(model.code);
      if (model.code == 200) {
        print(model.data.version);
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          print(model.data.version);
          print(packageInfo.version);
          var newVersion = int.parse(model.data.version.replaceAll(".", ""));
          var oldVersion = int.parse(packageInfo.version.replaceAll(".", ""));

          if (newVersion > oldVersion) {
            Future.delayed(Duration.zero, () {
              model.data.isMandatory == "1"
                  ? showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_update_title,
                        ),
                        content: Text(
                          S.of(context).dialog_update_content,
                        ),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              if (Platform.isIOS) {
                                _launchURL(model.data.urlIos);
                              } else if (Platform.isAndroid) {
                                _launchURL(model.data.urlAndroid);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_update_title,
                        ),
                        content: Text(
                          S.of(context).dialog_update_content,
                        ),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              if (Platform.isIOS) {
                                _launchURL(model.data.urlIos);
                              } else if (Platform.isAndroid) {
                                _launchURL(model.data.urlAndroid);
                              }
                            },
                          ),
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_cancel,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
            });
          }

//          String appName = packageInfo.appName;
//          String packageName = packageInfo.packageName;
//          String version = packageInfo.version;
//          String buildNumber = packageInfo.buildNumber;
        });
      } else {}
    }).catchError((e) {
      print(e.toString());
    });
  }

  void netTopHeightData() {
    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        blockTopModel = model;
//        setState(() {});
        HomePage.height = blockTopModel.data.height;
        netWalletRecord();
      } else {}
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netBaseData() {
    BaseDataDao.fetch().then((BaseDataModel model) {
      if (model.code == 200) {
        baseDataModel = model;
        print(baseDataModel.toJson());
        setState(() {});
      } else {}
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
//    _top = 356.00;
//    netWalletRecord();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFF5F5F5),
        body: Container(
            child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQueryData.fromWindow(window).padding.top,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 18),
                          alignment: Alignment.topLeft,
//                          child: Image(
//                            width: 153,
//                            height: 36,
//                            image: AssetImage('images/home_logo_left.png'),
//                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
//                          onTap: () {
//                            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
//                          },
                          child: Container(
                            height: 55,
                            width: 55,
                            padding: EdgeInsets.all(15),
//                            child: Image(
//                              width: 36,
//                              height: 36,
//                              color: Colors.black,
//                              image: AssetImage('images/home_settings.png'),
//                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 55 - MediaQueryData.fromWindow(window).padding.top,
              width: MediaQuery.of(context).size.width,
              child: EasyRefresh(
                header: TaurusHeader(backgroundColor: Color(0xFFFC2365)),
                onRefresh: _onRefresh,
                child: Container(
//                height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            boxShadow: [
//                                BoxShadow(
//                                    color: Color(0xFFFC2365).withAlpha(20),
//                                    offset: Offset(0.0, 55.0), //阴影xy轴偏移量
//                                    blurRadius: 50.0, //阴影模糊程度
//                                    spreadRadius: 0.1 //阴影扩散程度
//                                    )
                            ],
                          ),
                          child: PageView(
                            controller: pageControllerBg,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 160,
                                    margin: const EdgeInsets.only(left: 16, right: 16),
                                    decoration: new BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFFFC2365).withAlpha(20),
                                            offset: Offset(0.0, 55.0), //阴影xy轴偏移量
                                            blurRadius: 50.0, //阴影模糊程度
                                            spreadRadius: 0.1 //阴影扩散程度
                                            )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 160,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(left: 16, right: 16),
                                    decoration: new BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF3D7BF6).withAlpha(20),
                                            offset: Offset(0.0, 55.0), //阴影xy轴偏移量
                                            blurRadius: 50.0, //阴影模糊程度
                                            spreadRadius: 0.1 //阴影扩散程度
                                            )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        child: AnimationLimiter(

                          child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 375),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                verticalOffset: 200.0,
                                child: FadeInAnimation(
                                  child: widget,
                                ),
                              ),
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          height: 156,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(80.0),
                                            boxShadow: [],
                                          ),
                                          child: PageView(
                                            controller: pageController,
                                            onPageChanged: (value) {
                                              pageControllerBg.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                              setState(() {});
                                            },
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 16, right: 16),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 156,
                                                          decoration: new BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                            gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                                              Color(0xFFE51363),
                                                              Color(0xFFFF428F),
                                                            ]),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          top: 0,
                                                          child: Container(
                                                            width: 87,
                                                            height: 58,
                                                            child: Image(
                                                              image: AssetImage("images/card_top.png"),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          bottom: 0,
                                                          child: Container(
                                                            width: 120,
                                                            height: 46,
                                                            child: Image(
                                                              image: AssetImage("images/card_bottom.png"),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 156,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Container(
                                                                margin: const EdgeInsets.only(left: 18),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Text(
                                                                      S.of(context).home_page_my_count + " (AE)",
                                                                      style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: "Ubuntu"),
                                                                    ),
//                                              Expanded(child: Container()),
//                                              baseDataModel == null
//                                                  ? Container()
//                                                  : Container(
//                                                      margin: const EdgeInsets.only(left: 2,right: 15),
//                                                      child: Text(
////                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
//                                                    600    " ≈ " + (double.parse(baseDataModel.data.priceUsdt) * double.parse(HomePage.token)).toStringAsFixed(2) + " (USD)",
//                                                        overflow: TextOverflow.ellipsis,
//                                                        style: TextStyle(fontSize: 13, color: Colors.white, letterSpacing: 1.0, fontFamily: "Ubuntu"),
//                                                      ),
//                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 8, left: 15),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                                                    Text(
                                                                      HomePage.token == "loading..."
                                                                          ? "loading..."
                                                                          : double.parse(HomePage.token) > 1000
                                                                          ? double.parse(HomePage.token).toStringAsFixed(2)
                                                                          : double.parse(HomePage.token).toStringAsFixed(5),
//                                      "9999999.00000",
                                                                      overflow: TextOverflow.ellipsis,

                                                                      style: TextStyle(fontSize: 35, color: Colors.white, letterSpacing: 1.3, fontFamily: "Ubuntu"),
                                                                    ),
                                                                    baseDataModel == null
                                                                        ? Container()
                                                                        : Container(
                                                                      margin: const EdgeInsets.only(bottom: 5, left: 2),
                                                                      child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                                        "≈ " + (double.parse(baseDataModel.data.priceUsdt) * double.parse(HomePage.token)).toStringAsFixed(2) + " (USD)",
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                                                                child: Text(
                                                                  address,
                                                                  strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: "Ubuntu"),
                                                                  style: TextStyle(fontSize: 13, letterSpacing: 1.0, color: Colors.white70, fontFamily: "Ubuntu", height: 1.3),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 16, right: 16),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 156,
                                                          decoration: new BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                            gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                                              Color(0xFF3C5DE3),
                                                              Color(0xFF3F8BFF),
                                                            ]),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          top: 0,
                                                          child: Container(
                                                            width: 87,
                                                            height: 58,
                                                            child: Image(
                                                              image: AssetImage("images/card_top.png"),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          bottom: 0,
                                                          child: Container(
                                                            width: 120,
                                                            height: 46,
                                                            child: Image(
                                                              image: AssetImage("images/card_bottom.png"),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 156,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Container(
                                                                margin: const EdgeInsets.only(left: 18),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Text(
                                                                      S.of(context).home_page_my_count + " (ABC)",
                                                                      style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: "Ubuntu"),
                                                                    ),
//
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 8, left: 15),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                                                    Text(
                                                                      HomePage.tokenABC,
//                                      "9999999.00000",
                                                                      overflow: TextOverflow.ellipsis,

                                                                      style: TextStyle(fontSize: 35, color: Colors.white, letterSpacing: 1.3, fontFamily: "Ubuntu"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.topLeft,
                                                                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                                                                child: Text(
                                                                  address,
                                                                  strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: "Ubuntu"),
                                                                  style: TextStyle(fontSize: 13, letterSpacing: 1.0, color: Colors.white70, fontFamily: "Ubuntu", height: 1.3),
                                                                ),
                                                              ),
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
                                      Positioned(
                                        bottom: 11,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          child: SmoothPageIndicator(
                                            controller: pageController,
                                            count: 2,
                                            effect: ExpandingDotsEffect(
                                              dotHeight: 4,
                                              spacing: 3,
                                              strokeWidth: 3,
                                              dotWidth: 5,
                                              activeDotColor: Color(0xFFFFFFFF),
                                              dotColor: Color(0xFFFFFFFF).withAlpha(120),
                                              expansionFactor: 3,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDefiPage()));
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
                                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Colors.black),
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
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDefiPage()));
                                                      },
                                                      child: Text(
                                                        S.of(context).home_page_function_defi_go,
                                                        maxLines: 1,
                                                        style: TextStyle(fontSize: 13, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                                      },
                                      child: Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    child: Image(
                                                      width: 56,
                                                      height: 56,
                                                      image: AssetImage("images/home_send_token.png"),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Text(
                                                      S.of(context).home_page_function_send,
                                                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Colors.black),
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
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 160,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
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
                                                          image: AssetImage("images/home_receive_token.png"),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left: 0),
                                                        child: Text(
                                                          S.of(context).home_page_function_receive,
                                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Colors.black),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 18,
                                                  child: Container(
                                                    height: 30,
                                                    margin: const EdgeInsets.only(top: 20),
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        Clipboard.setData(ClipboardData(text: address));
                                                        setState(() {
                                                          contentText = S.of(context).token_receive_page_copy_sucess;
                                                        });
                                                        Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                                      },
                                                      child: Text(
                                                        contentText == "" ? S.of(context).token_receive_page_copy : S.of(context).token_receive_page_copy_sucess,
                                                        maxLines: 1,
                                                        style: TextStyle(fontSize: 13, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
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
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 5, left: 18, right: 5),
                                                  child: Text(
                                                    address,
                                                    strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                    style: TextStyle(fontSize: 14, color: Color(0xFF999999), letterSpacing: 1.0, fontFamily: "Ubuntu", height: 1.3),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 0, right: 23),
                                                child: QrImage(
                                                  data: address,
                                                  version: QrVersions.auto,
                                                  size: 80.0,
                                                ),
                                              ),
                                            ],
                                          )
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AensPage()));
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
                                                          style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Colors.black),
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
                                                          fontFamily: "Ubuntu",
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
                                                          fontFamily: "Ubuntu",
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
                                                          fontFamily: "Ubuntu",
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
                                                            fontFamily: "Ubuntu"),
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
                                getRecordContainer(context),
                              ],
                            ),


                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Container getRecordContainer(BuildContext context) {
    if (walletRecordModel == null && page == 1 && blockTopModel == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
      );
    }
    if (walletRecordModel == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      margin:  EdgeInsets.only(top: 12, left: 15, right: 15, bottom: MediaQueryData.fromWindow(window).padding.bottom+80),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
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
                              image: AssetImage("images/home_record.png"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              S.of(context).home_page_transaction,
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Colors.black),
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
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15, top: 0),
                child: Text(
                  S.of(context).home_page_transaction_conform,
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontFamily: "Ubuntu"),
                ),
                height: 23,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    getItem(context, 0),
                    getItem(context, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getItem(BuildContext context, int index) {
    if (walletRecordModel == null || walletRecordModel.data.length <= index) {
      return Container();
    }
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //边框设置

                child: Text(
                  (blockTopModel.data.height - walletRecordModel.data[index].blockHeight).toString(),
                  style: TextStyle(color: Color(0xFFFC2365), fontSize: 14, fontFamily: "Ubuntu"),
                ),
                alignment: Alignment.center,
                height: 23,
                width: 40,
              ),
              Container(
                margin: EdgeInsets.only(left: 18),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                walletRecordModel.data[index].tx['type'],
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Ubuntu"),
                              ),
                            ),
                          ),
                          Container(
                            child: getFeeWidget(index),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        walletRecordModel.data[index].hash,
                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                        style: TextStyle(color: Colors.black.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: "Ubuntu"),
                      ),
                      width: 250,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                        DateTime.fromMicrosecondsSinceEpoch(walletRecordModel.data[index].time * 1000).toLocal().toString(),
                        style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 13, letterSpacing: 1.0, fontFamily: "Ubuntu"),
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
    );
  }

  Future<void> _onLoad() async {
    await Future.delayed(Duration(seconds: 1), () {
      netWalletRecord();
    });
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        HomePage.address = address;
        this.address = address;
      });
    });
  }

  Future<void> _onRefresh() async {
    page = 1;
    if (page == 1 && walletRecordModel == null) {
      loadingType = LoadingType.loading;
    }
    setState(() {});
    await Future.delayed(Duration(seconds: 1), () {
      netAccountInfo();
      netTopHeightData();
      netBaseData();
      getAddress();
      netContractBalance();
      netBaseNameData();
    });
  }

  double getListWidgetHeight(BuildContext context) {
    if (loadingType == LoadingType.finish) {
      return MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 200;
    } else {
      return MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 150 - 200;
    }
  }

  Text getFeeWidget(int index) {
    if (walletRecordModel.data[index].tx['type'].toString() == "SpendTx") {
      // ignore: unrelated_type_equality_checks

      if (walletRecordModel.data[index].tx['recipient_id'].toString() == address) {
        return Text(
          "+" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: "Ubuntu"),
        );
      } else {
        return Text(
          "-" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: "Ubuntu"),
        );
      }
    } else {
      return Text(
        "-" + (walletRecordModel.data[index].tx['fee'].toDouble() / 1000000000000000000).toString() + " AE",
        style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 14, fontFamily: "Ubuntu"),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
