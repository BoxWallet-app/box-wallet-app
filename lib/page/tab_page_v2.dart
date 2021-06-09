import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:box/dao/contract_info_dao.dart';
import 'package:box/dao/version_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/version_model.dart';
import 'package:box/page/aepps_page_v2.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/setting_page_v2.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import '../main.dart';
import 'mnemonic_copy_page.dart';

class TabPageV2 extends StatefulWidget {
  @override
  _TabPageV2State createState() => _TabPageV2State();
}

class _TabPageV2State extends State<TabPageV2> with TickerProviderStateMixin {
  final StreamController<int> _streamController1 = StreamController<int>();
  final StreamController<int> _streamController2 = StreamController<int>();
  final StreamController<int> _streamController3 = StreamController<int>();
  final StreamController<double> _streamControllerLine = StreamController<double>();

  PageController pageControllerBody = PageController();
  PageController pageControllerTitle = PageController();

  @override
  void dispose() {
    super.dispose();

    _streamController1.close();
    _streamController2.close();
    _streamController3.close();
    _streamControllerLine.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageControllerBody.addListener(() {
      if (pageControllerBody.offset < 0 || pageControllerBody.offset > MediaQuery.of(context).size.width + MediaQuery.of(context).size.width) {
        return;
      }
      pageControllerTitle.jumpTo(pageControllerBody.offset / 3);

      double zoom = (156) / (MediaQuery.of(context).size.width);
      double offset = (pageControllerBody.offset * zoom);
      _streamControllerLine.sink.add(pageControllerBody.offset / 3);
      if (pageControllerBody.page < 0.5) {
        _streamController1.sink.add(0xFFFC2365);
        _streamController2.sink.add(-1);
        _streamController3.sink.add(-1);
      }
      if (pageControllerBody.page > 0.6 && pageControllerBody.page < 1.5) {
        _streamController1.sink.add(-1);
        _streamController2.sink.add(0xFFFC2365);
        _streamController3.sink.add(-1);
      }

      if (pageControllerBody.page > 1.5) {
        _streamController1.sink.add(-1);
        _streamController2.sink.add(-1);
        _streamController3.sink.add(0xFFFC2365);
      }
    });
    _streamController1.sink.add(0xFFFC2365);
    _streamController2.sink.add(-1);
    _streamController3.sink.add(-1);
    _streamControllerLine.sink.add(0);
    showHint();
    netVersion();
//    netContractInfo();
    const timeout = const Duration(seconds: 1);
//    Timer.periodic(timeout, (timer) { //callback function
//      //1s 回调一次
//      print('afterTimer='+DateTime.now().toString());
//      getClipboardData();
//    });

    eventBus.on<DefiEvent>().listen((event) {
//      netContractInfo();
    });
  }

  void netContractInfo() {
    ContractInfoDao.fetch().then((ContractInfoModel model) {
      if (model.code == 200) {
        TokenDefiPage.model = model;
        setState(() {});
      } else {}
    }).catchError((e) {
      print(e.toString());
//
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
      if (model.code == 200) {
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          var newVersion = 0;
          if (Platform.isIOS) {
            newVersion = int.parse(model.data.versionIos.replaceAll(".", ""));
          } else {
            newVersion = int.parse(model.data.version.replaceAll(".", ""));
          }

//          var oldVersion = 100;
//          model.data.isMandatory = "1";
          var oldVersion = int.parse(packageInfo.version.replaceAll(".", ""));
//return;
          if (newVersion > oldVersion) {
            Future.delayed(Duration.zero, () {
              model.data.isMandatory == "1"
                  ? showPlatformDialog(
                      androidBarrierDismissible: false,
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () async => false,
                        child: BasicDialogAlert(
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
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
//                        Navigator.of(context, rootNavigator: true).pop();
                                if (Platform.isIOS) {
                                  _launchURL(model.data.urlIos);
                                } else if (Platform.isAndroid) {
                                  _launchURL(model.data.urlAndroid);
                                }
                              },
                            ),
                          ],
                        ),
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
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
    }).catchError((e) {});
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
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
              content: Text(
                S.of(context).dialog_save_word_hint,
                style: TextStyle(
                  color: Color(0xFF000000),
                  height: 1.2,
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    S.of(context).dialog_dismiss,
                    style: TextStyle(
                      color: Color(0xFFFC2365),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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

  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async{
          // 点击返回键的操作
          if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "再按一次退出", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          }else{
            lastPopTime = DateTime.now();
            // 退出app
            exit(0);
          }
        },

        child: Scaffold(
          
          backgroundColor: Color(0xfffafafa),
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              children: [
                Container(
                  color: Color(0xfffafafa),
                  height: MediaQueryData.fromWindow(window).padding.top,
                ),
                Container(
                  color: Color(0xfffafafa),
//              color: Colors.blue,
                  width: MediaQuery.of(context).size.width,
                  height: 52,
                  child: Stack(
                    children: [
                      Positioned(
                        height: 52,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Container(
                          child: Container(
                            decoration: new BoxDecoration(
                              //背景
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            child: PageView.builder(
                              itemCount: 3,
                              controller: pageControllerTitle,
                              physics: NeverScrollableScrollPhysics(),
                              allowImplicitScrolling: true,
                              pageSnapping: false,
                              itemBuilder: (context, position) {
                                if (position == 0) {
                                  return Container(
                                    height: 52,
                                    margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      S.of(context).tab_1,
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                        fontFamily: BoxApp.language == "cn"
                                            ? "Ubuntu"
                                            : BoxApp.language == "cn"
                                                ? "Ubuntu"
                                                : "Ubuntu",
                                      ),
                                    ),
                                  );
                                } else if (position == 1) {
                                  return Container(
                                    height: 52,
                                    margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      S.of(context).tab_2,
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                        fontFamily: BoxApp.language == "cn"
                                            ? "Ubuntu"
                                            : BoxApp.language == "cn"
                                                ? "Ubuntu"
                                                : "Ubuntu",
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 52,
                                    margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      S.of(context).tab_3,
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                        fontFamily: BoxApp.language == "cn"
                                            ? "Ubuntu"
                                            : BoxApp.language == "cn"
                                                ? "Ubuntu"
                                                : "Ubuntu",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            width: MediaQuery.of(context).size.width / 2,
                            height: 52,
                          ),
                        ),
                      ),
//                      buildTitleRightIcon()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - MediaQueryData.fromWindow(window).padding.bottom - 52,
                    child: PageView.builder(
                      itemCount: 3,
                      controller: pageControllerBody,
                      itemBuilder: (context, position) {
                        if (position == 0) {
                          return HomePageV2();
                        } else if (position == 1) {
                          return AeppsPageV2();
                        } else {
                          return SettingPageV2();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Color(0xffeeeeee),
                ),
                Container(
                  color: Colors.green,
                  height: 52,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                pageControllerBody.animateToPage(0, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
                              },
                              borderRadius: BorderRadius.all(Radius.circular(60)),
                              child: StreamBuilder<Object>(
                                  stream: _streamController1.stream,
                                  builder: (context, snapshot) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      padding: EdgeInsets.all(12),
                                      height: 52,
                                      child: Image(
                                        width: 30,
                                        height: 30,
                                        image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_home_p.png") : AssetImage("images/tab_home.png"),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                pageControllerBody.animateToPage(1, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
                              },
                              borderRadius: BorderRadius.all(Radius.circular(60)),
                              child: StreamBuilder<Object>(
                                  stream: _streamController2.stream,
                                  builder: (context, snapshot) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      padding: EdgeInsets.all(12),
                                      height: 52,
                                      child: Image(
                                        width: 30,
                                        height: 30,
                                        image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_swap_p.png") : AssetImage("images/tab_swap.png"),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                pageControllerBody.animateToPage(2, duration: new Duration(milliseconds: 1000), curve: new ElasticOutCurve(4));
                              },
                              borderRadius: BorderRadius.all(Radius.circular(60)),
                              child: StreamBuilder<Object>(
                                  stream: _streamController3.stream,
                                  builder: (context, snapshot) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      padding: EdgeInsets.all(12),
                                      height: 52,
                                      child: Image(
                                        width: 30,
                                        height: 30,
                                        image: snapshot.data == 0xFFFC2365 ? AssetImage("images/tab_app_p.png") : AssetImage("images/tab_app.png"),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<double>(
                          stream: _streamControllerLine.stream,
                          builder: (context, snapshot) {
                            return Positioned(
                                top: 2,
                                left: snapshot.data,
                                child: Container(
                                  height: 3,
                                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3 / 3, right: MediaQuery.of(context).size.width / 3 / 3),
                                  width: MediaQuery.of(context).size.width / 3 - MediaQuery.of(context).size.width / 3 / 3 - MediaQuery.of(context).size.width / 3 / 3,
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    //背景
                                    color: Color(0xFFf7296e),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                  ),
                                ));
                          })
                    ],
                  ),
                ),
                Container(
                  height: MediaQueryData.fromWindow(window).padding.bottom,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildTitleRightIcon() {
//    if (TokenDefiPage.model == null || TokenDefiPage.model.data.height == -1) {
//      return Positioned(
//        child: Container(),
//      );
//    }
    return Positioned(
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          onTap: () {
//            Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDefiPage()));
          if(BoxApp.language == "cn"){
            Share.share('AeBox 一个AE去中心化魔法盒子 https://aebox.io');
          }else{
            Share.share('AeBox is an AE decentralized magic box https://aebox.io');
          }

          },
          child: Container(
            height: 55,
            width: 55,
//            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.share_rounded,
              size: 17,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
