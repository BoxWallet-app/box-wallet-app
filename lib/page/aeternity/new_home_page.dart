import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:box/config.dart';
import 'package:box/dao/aeternity/ae_account_error_list_dao.dart';
import 'package:box/dao/aeternity/host_dao.dart';
import 'package:box/dao/aeternity/version_dao.dart';
import 'package:box/dao/urls.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/plugin_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/host_model.dart';
import 'package:box/model/aeternity/version_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_rpc_model.dart';
import 'package:box/page/aeternity/ae_aepps_page.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/confux/cfx_dapps_page.dart';
import 'package:box/page/confux/cfx_home_page.dart';
import 'package:box/page/ethereum/eth_dapps_page.dart';
import 'package:box/page/ethereum/eth_home_page.dart';
import 'package:box/page/setting_page.dart';
import 'package:box/page/general/wallet_select_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../manager/data_center_manager.dart';
import '../general/wallet_select_page_new.dart';
import '../mnemonic_copy_page.dart';
import 'ae_records_page.dart';

class NewHomePage extends BaseWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends BaseWidgetState<NewHomePage> with TickerProviderStateMixin {
  PageController pageControllerTitle = PageController();
  BuildContext? buildContext;
  Account? account;
  CfxRpcModel? cfxRpcModel;

  List<Widget> aeWidget = [];
  List<Widget> cfxWidget = [];
  List<Widget> ethWidget = [];
  var _currentIndex = 0;

  bool isNodeError = false;
  bool isNodeLoading = true;

  _NewHomePageState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aeWidget.add(AeHomePage());
    eventBus.on<AccountUpdateEvent>().listen((event) {
      getAddress();
    });

    eventBus.on<AccountUpdateNameEvent>().listen((event) {
      getAddress();
    });
    netHost();
    netVersion();
    getAddress();
    netNodeHeight();

    Future.delayed(const Duration(milliseconds: 3000), () {
      Timer.periodic(Duration(milliseconds: 600000), (timer) {
        netNodeHeight();
      });
    });

    DataCenterManager.instance.start();
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? account) {
      this.account = account;
      if (!mounted) return;
      setState(() {});
    });
  }

  void netNodeHeight() {
    var params = {
      "name": "aeGetCurrentHeight",
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      isNodeLoading = false;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var code = jsonResponse["code"];

      if (code == 200) {
        isNodeError = false;
      } else {
        isNodeError = true;
        // showConfirmDialog(S.of(context).dialog_hint, "error");
      }

      setState(() {});
      return;
    }, channelJson);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void netHost() {
    HostDao.fetch().then((HostModel model) {
      Host.baseHost = model.baseUrl;
      BoxApp.setBaseHost(Host.baseHost!);
    }).catchError((e) {});
  }

  void netVersion() {
    if (BoxApp.isDev()) {
      return;
    }
    VersionDao.fetch().then((VersionModel model) {
      if (model.code == 200) {
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          var newVersion = 0;
          if (Platform.isIOS) {
            newVersion = int.parse(model.data!.versionIos!.replaceAll(".", ""));
          } else {
            newVersion = int.parse(model.data!.version!.replaceAll(".", ""));
          }

//          var oldVersion = 100;
//          model.data.isMandatory = "1";
          var oldVersion = int.parse(packageInfo.version.replaceAll(".", ""));
          if (newVersion > oldVersion) {
            if (model.data!.msgCN == null) {
              model.data!.msgCN = "发现新版本";
            }
            if (model.data!.msgEN == null) {
              model.data!.msgEN = "Discover a new version";
            }
            Future.delayed(Duration.zero, () {
              model.data!.isMandatory == "1"
                  ? showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return WillPopScope(
                          onWillPop: () async {
                            return Future.value(false);
                          },
                          child: new AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            title: Text(
                              S.of(context).dialog_update_title,
                            ),
                            content: Text(
                              BoxApp.language == "cn" ? model.data!.msgCN! : model.data!.msgEN!,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: new Text(
                                  S.of(context).dialog_conform,
                                ),
                                onPressed: () {
                                  if (Platform.isIOS) {
                                    _launchURL(model.data!.urlIos!);
                                  } else if (Platform.isAndroid) {
                                    _launchURL(model.data!.urlAndroid!);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ).then((value) {
                      if (value!) {}
                    })
                  : showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return new AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                          title: Text(
                            S.of(context).dialog_update_title,
                          ),
                          content: Text(
                            BoxApp.language == "cn" ? model.data!.msgCN! : model.data!.msgEN!,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: new Text(
                                S.of(context).dialog_cancel,
                              ),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(false);
                              },
                            ),
                            TextButton(
                              child: new Text(
                                S.of(context).dialog_conform,
                              ),
                              onPressed: () {
                                if (Platform.isIOS) {
                                  _launchURL(model.data!.urlIos!);
                                } else if (Platform.isAndroid) {
                                  _launchURL(model.data!.urlAndroid!);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ).then((value) {});
            });
          }
        });
      } else {}
    }).catchError((e) {});
  }

  DateTime? lastPopTime;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null || DateTime.now().difference(lastPopTime!) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "Press exit again", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            exit(0);
          }
          return true;
        },

        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      color: Color(0xFFfafbfc),
                      height: MediaQueryData.fromWindow(window).padding.top,
                    ),
                    Container(
                      color: Color(0xFFfafbfc),
//              color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      child: Stack(
                        children: [
                          buildTitleAccount(),
                          buildTitleRecord(),
                          buildTitleSettings(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: getBody(),
                      ),
                    ),
                  ],
                ),
              ),
              if (isNodeLoading || isNodeError)
                Positioned(
                    bottom: MediaQueryData.fromWindow(window).padding.bottom + 10,
                    right: 0,
                    child: Container(
                      child: Container(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          // padding: const EdgeInsets.only(bottom: 6, top: 6),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                            color: Color.fromARGB(255, 223, 223, 223),
                          ),
                          child: Material(
                            color: isNodeError ? Color(0xFFFC2365) : Color(0xFFFC2365),
                            child: InkWell(
                              onTap: () async {
                                isNodeLoading = true;
                                setState(() {});
                                netNodeHeight();
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isNodeLoading
                                        ? Row(
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: Color(0xffffffff),
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 7),
                                                child: Text(
                                                  "Connect node...",
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color.fromARGB(255, 255, 255, 255)),
                                                ),
                                              ),
                                            ],
                                          )
                                        : isNodeError
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.error_outline_outlined,
                                                    color: Color.fromARGB(255, 255, 255, 255),
                                                    size: 15,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: Text(
                                                      "Network Error",
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color.fromARGB(255, 255, 255, 255)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
            ],
          ),

          drawer: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width - 60,
              child: WalletSelectPageNew(),
            ),
          ),
          // 右侧抽屉
          endDrawer: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            child: Container(width: MediaQuery.of(context).size.width - 60, child: SettingPage()),
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    if (account == null) return Container();
    return IndexedStack(
      index: _currentIndex,
      children: aeWidget,
    );
  }

  Positioned buildTitleAccount() {
    return Positioned(
      left: 18,
      child: Builder(builder: (context) {
        return Container(
          height: 52,
          alignment: Alignment.center,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                // showMaterialModalBottomSheet(
                //     expand: false,
                //     context: context,
                //     enableDrag: false,
                //     backgroundColor: Colors.transparent,
                //     builder: (context) {
                //       return WalletSelectPage();
                //     });
                Scaffold.of(context).openDrawer(); //打开右边抽屉
              },
              child: Container(
                height: 35,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: new Border.all(width: 1, color: Color(0xFFedf3f7)),
                ),
                padding: EdgeInsets.only(left: 4, right: 4),
                margin: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (account != null)
                      ClipOval(
                        child: Container(
                          width: 23.0,
                          height: 23.0,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFedf3f7), width: 1.0),
                              top: BorderSide(color: Color(0xFFedf3f7), width: 1.0),
                              left: BorderSide(color: Color(0xFFedf3f7), width: 1.0),
                              right: BorderSide(color: Color(0xFFedf3f7), width: 1.0),
                            ),
//                                                      shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(36.0),
                            image: DecorationImage(
                              image: AssetImage("images/" + account!.coin! + ".png"),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      width: 4,
                    ),
                    Text(
                      getAccountName(),
                      maxLines: 1,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Colors.black),
                    ),
                    Container(
                      width: 2,
                    ),
                    Container(
                      width: 15,
                      height: 15,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 13,
                        color: Color(0xFF000000),
                        // color: Color(0xFFE2E2E2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Positioned buildTitleSettings() {
    return Positioned(
      right: 18,
      child: Builder(builder: (context) {
        return Container(
          height: 52,
          width: 52,
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                Scaffold.of(context).openEndDrawer(); //打开右边抽屉
              },
              child: Container(
                padding: EdgeInsets.all(13),
                margin: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      color: Colors.black87,
                      image: AssetImage(
                        "images/home_settings.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Positioned buildTitleRecord() {
    return Positioned(
      right: 18 + 52,
      child: Builder(builder: (context) {
        return Container(
          height: 52,
          width: 52,
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AeRecordsPage()));
                // var signingKey = "A6gH0/HB2O5mDLazE38sLMoFMJyY24hTe8GwC83hfWHot9AHajg6aKqnfAq/MjBjPAemVhv3Q/jzut4PvGV6WwsC5QKxVT39VXnmcyicJWLFzTv2GZSBkmKCgkLepYc5EuVi9T7xgqupCO+t4in9dSy22K+VW02HNyIqaXpIvuZc3W4RLCVw1EiaAbx7Oe4F";
                // var address = "ak_2nu7x8cpJ88ownrxdpdVLAhHeSpG7ffbdQ8rsedvVHU9MZytzB";
                // final key = Utils.generateMd5Int("510808" + address);
                // var aesDecode = Utils.aesDecodeOld(signingKey, key);
                // print(aesDecode);

                //   {
                //     "name": "aeRestoreAccountSecretKey",
                //   "params": {
                //   "secretKey": "176e0383e672c6b76edead1899e9cf35471036fd150b4c9fd0e8c8d6e6402ceeebea1e1f3988302f8302c16ad98c2078e91f0ebb58a85de5753e2a2565f853c8"
                //   }
                // }
              },
              child: Container(
                padding: EdgeInsets.all(14),
                margin: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      color: Colors.black87,
                      image: AssetImage(
                        "images/ic_home_record.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  getAccountName() {
    if (account == null) {
      return "";
    }
    if (account!.name == null || account!.name == "") {
      return Utils.formatAccountAddress(account!.address);
    } else {
      return account!.name;
    }
  }
}
