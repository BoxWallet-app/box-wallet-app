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
import '../mnemonic_copy_page.dart';

class AeTabPage extends StatefulWidget {
  @override
  _AeTabPageState createState() => _AeTabPageState();
}

class _AeTabPageState extends State<AeTabPage> with TickerProviderStateMixin {
  PageController pageControllerTitle = PageController();
  BuildContext? buildContext;
  Account? account;
  CfxRpcModel? cfxRpcModel;

  List<Widget> aeWidget = [];
  List<Widget> cfxWidget = [];
  List<Widget> ethWidget = [];
  var _currentIndex = 0;

  _AeTabPageState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    aeWidget.add(AeHomePage());
    aeWidget.add(AeAeppsPage());
    aeWidget.add(SettingPage());

    cfxWidget.add(CfxHomePage());
    cfxWidget.add(CfxDappsPage());
    cfxWidget.add(SettingPage());

    ethWidget.add(EthHomePage());
    ethWidget.add(EthDappsPage());
    ethWidget.add(SettingPage());

    eventBus.on<AccountUpdateEvent>().listen((event) {
      getAddress();
    });

    eventBus.on<AccountUpdateNameEvent>().listen((event) {
      getAddress();
    });
    netHost();
    netVersion();
    getAddress();
    showHint();

    MethodChannel _platform = const MethodChannel('BOX_NAV_TO_DART');
    _platform.setMethodCallHandler(channelHandler);

    tab1Controller = AnimationController(vsync: this);
    tab2Controller = AnimationController(vsync: this);
    tab3Controller = AnimationController(vsync: this);
  }

  Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getGasCFX':
        var data = jsonDecode(methodCall.arguments.toString());
        cfxRpcModel = CfxRpcModel.fromJson(data);

        await BoxApp.getGasCFX((data) async {
          var split = data.split("#");
          cfxRpcModel!.payload!.storageLimit = split[2].toString();
          cfxRpcModel!.payload!.gasPrice = "1000000000";
          cfxRpcModel!.payload!.gas = split[0].toString();
          String value = "- 0 CFX";
          var decimalBase = Decimal.parse('1000000000000000000');
          if (cfxRpcModel!.payload!.value != null) {
            value = "- " + (Decimal.parse(int.parse(cfxRpcModel!.payload!.value!).toString()) / decimalBase).toString() + " CFX";
          }

          var decimalGasPrice = Decimal.parse(int.parse(cfxRpcModel!.payload!.gasPrice!).toString());

          var decimalGas = Decimal.parse(int.parse(cfxRpcModel!.payload!.gas!).toString());
          var decimalGasBase = decimalGas / decimalBase;

          var storageLimit = Decimal.parse((int.parse(cfxRpcModel!.payload!.storageLimit!).toString()));

          var formatGas = double.parse(decimalGasPrice.toString()) * double.parse(decimalGasBase.toString());
          await PluginManager.cfxGetGas({
            'type': methodCall.method,
            'from': cfxRpcModel!.payload!.from,
            'to': cfxRpcModel!.payload!.to,
            'value': value,
            'gas': "- " + formatGas.toStringAsFixed(10) + " CFX",
            'data': cfxRpcModel!.payload!.data,
          });
          return;
        }, cfxRpcModel!.payload!.from!, cfxRpcModel!.payload!.to!, cfxRpcModel!.payload!.value != null ? cfxRpcModel!.payload!.value! : "0", cfxRpcModel!.payload!.data!);

        return 'SUCCESS';
      case 'signTransaction':
        if (cfxRpcModel == null) {
          return 'SUCCESS';
        }
        var password = methodCall.arguments.toString();
        password = Utils.generateMD5(password + PSD_KEY);
        var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
        var address = await BoxApp.getAddress();
        final key = Utils.generateMd5Int(password + address);
        var aesDecode;
        try {
          aesDecode = Utils.aesDecode(signingKey, key);
        } catch (err) {
          await PluginManager.passwordError({
            'type': "signTransactionError",
            'data': "ERROR:password error",
          });
          return "SUCCESS";
        }

        if (aesDecode == "") {
          await PluginManager.passwordError({
            'type': "signTransactionError",
            'data': "ERROR:password error",
          });
          return 'SUCCESS';
        }
        BoxApp.signTransactionCFX((hash) async {
          await PluginManager.cfxSignTransaction({
            'type': methodCall.method,
            'data': hash,
          });
          return 'SUCCESS';
        }, (error) {
          return;
        }, aesDecode, cfxRpcModel!.payload!.storageLimit != null ? cfxRpcModel!.payload!.storageLimit! : "0", cfxRpcModel!.payload!.gas != null ? cfxRpcModel!.payload!.gas! : "0", cfxRpcModel!.payload!.gasPrice != null ? cfxRpcModel!.payload!.gasPrice! : "0",
            cfxRpcModel!.payload!.value != null ? cfxRpcModel!.payload!.value! : "0", cfxRpcModel!.payload!.to!, cfxRpcModel!.payload!.data!);

        return 'SUCCESS';

      default:
        throw MissingPluginException('notImplemented');
    }
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? account) {
      // AeHomePage.address = account.address;
      this.account = account;
      if (!mounted) return;
      setState(() {});
    });
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
              model.data!.msgCN = "???????????????";
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
  AnimationController? tab1Controller;
  AnimationController? tab2Controller;
  AnimationController? tab3Controller;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // ????????????????????????
          if (lastPopTime == null || DateTime.now().difference(lastPopTime!) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "Press exit again", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          } else {
            lastPopTime = DateTime.now();
            // ??????app
            exit(0);
          }
          return true;
        } ,

        child: Scaffold(
          // backgroundColor: Color(0xFFffffff),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            // child: BottomNavigationBar(
            //   selectedLabelStyle:   TextStyle(fontSize: 12, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
            //   unselectedLabelStyle:   TextStyle(fontSize: 12, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
            //   selectedItemColor:Color(0xFF000000),
            //     selectedFontSize:12,
            //   backgroundColor: Color(0xFFffffff),
            //   items: [
            //     BottomNavigationBarItem(
            //         icon: Image(
            //           width: 24,
            //           height: 24,
            //           image: AssetImage("images/tab_home.png"),
            //         ),
            //         activeIcon: Image(
            //           width: 24,
            //           height: 24,
            //           image: AssetImage("images/tab_home_p.png"),
            //         ),
            //       label: S.of(context).tab_1,),
            //     BottomNavigationBarItem(
            //         icon: Image(
            //           width: 24,
            //           height: 24,
            //           image: AssetImage("images/tab_swap.png"),
            //         ),
            //         activeIcon: Image(
            //           width: 24,
            //           height: 24,
            //           image: AssetImage("images/tab_swap_p.png"),
            //         ),
            //       label:S.of(context).tab_2,),
            //     BottomNavigationBarItem(
            //         icon: Image(
            //           width: 24,
            //           height: 24,
            //           image: AssetImage("images/tab_app.png"),
            //         ),
            //         activeIcon: Image(
            //           width: 24,
            //           height: 24,
            //           image: AssetImage("images/tab_app_p.png"),
            //         ),
            //         label: S.of(context).tab_3,
            //     ),
            //   ],
            //   currentIndex: _currentIndex,
            //   onTap: (int index) {
            //
            //     setState(() {
            //       _currentIndex = index;
            //     });
            //     pageControllerTitle.jumpToPage(_currentIndex);
            //   },
            // ),
            child: BottomNavigationBar(
              selectedLabelStyle:   TextStyle(fontSize: 11, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
              unselectedLabelStyle:   TextStyle(fontSize: 11, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
              selectedItemColor:Color(0xFF000000),
                selectedFontSize:10,
              unselectedFontSize:10,
              backgroundColor: Color(0xFFffffff),
              items: [
                BottomNavigationBarItem(
                    icon: Image(
                      width: 24,
                      height: 24,
                      image: AssetImage("images/tab_home.png"),
                    ),
                    activeIcon: Image(
                      width: 24,
                      height: 24,
                      image: AssetImage("images/tab_home_p.png"),
                    ),
                  label: S.of(context).tab_1,),
                BottomNavigationBarItem(
                    icon: Image(
                      width: 24,
                      height: 24,
                      image: AssetImage("images/tab_swap.png"),
                    ),
                    activeIcon: Image(
                      width: 24,
                      height: 24,
                      image: AssetImage("images/tab_swap_p.png"),
                    ),
                  label:S.of(context).tab_2,),
                BottomNavigationBarItem(
                    icon: Image(
                      width: 24,
                      height: 24,
                      image: AssetImage("images/tab_app.png"),
                    ),
                    activeIcon: Image(
                      width: 24,
                      height: 24,
                      image: AssetImage("images/tab_app_p.png"),
                    ),
                    label: S.of(context).tab_3,
                ),
              ],
              currentIndex: _currentIndex,
              onTap: (int index) {

                setState(() {
                  _currentIndex = index;
                });
                pageControllerTitle.jumpToPage(_currentIndex);
              },
            ),
          ),
          body: Container(
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
                      Positioned(
                        height: 52,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Container(
                          child: Container(
                            decoration: new BoxDecoration(
                              //??????
                              //?????????????????? ??????
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
                      buildTitleRightIcon(context),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: getBody(),
                    // child: PageView.builder(
                    //   itemCount: 3,
                    //   controller: pageControllerBody,
                    //   itemBuilder: (context, position) {
                    //     if (position == 0) {
                    //       if (account == null) {
                    //         return Container();
                    //       }
                    //       if (account.coin == "AE") {
                    //         return AeHomePage();
                    //       }
                    //       if (account.coin == "CFX") {
                    //         return CfxHomePage();
                    //       }
                    //     } else if (position == 1) {
                    //       if (account == null) {
                    //         return Container();
                    //       }
                    //       if (account.coin == "AE") {
                    //         return AeAeppsPage();
                    //       }
                    //       if (account.coin == "CFX") {
                    //         return CfxDappsPage();
                    //       }
                    //     } else {
                    //       return SettingPage();
                    //     }
                    //     return Container();
                    //   },
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
//         child: Scaffold(
//           backgroundColor: Color(0xFFfafbfc),
//           resizeToAvoidBottomInset: false,
//           bottomNavigationBar: BottomNavigationBar(
//             items: [
//               BottomNavigationBarItem(
//                   icon: Container(
//                     width: 23,
//                     height: 23,
//                     child: Lottie.asset(
//                       'images/home.json',
//                       repeat: false,
//                       controller: tab1Controller,
//                       onLoaded: (composition) {
//                         tab1Controller..duration = composition.duration;
//                         // ..forward();
//                       },
//                     ),
//                   ),
//                   title: Container()),
//               BottomNavigationBarItem(
//                   icon: Container(
//                     width: 23,
//                     height: 23,
//                     child: Lottie.asset(
//                       'images/discover.json',
//                       repeat: false,
//                       controller: tab2Controller,
//                       onLoaded: (composition) {
//                         tab2Controller..duration = composition.duration;
//                         // ..forward();
//                       },
//                     ),
//                   ),
//                   title: Container()),
//               BottomNavigationBarItem(
//                   icon:Container(
//                     width: 23,
//                     height: 23,
//                     child: Lottie.asset(
//                       'images/profile.json',
//                       repeat: false,
//                       controller: tab3Controller,
//                       onLoaded: (composition) {
//                         tab3Controller..duration = composition.duration;
//                         // ..forward();
//                       },
//                     ),
//                   ),
//
//                   title: Container()),
//             ],
//             currentIndex: _currentIndex,
//             onTap: (int index) {
//               tab1Controller.reset();
//               tab2Controller.reset();
//               tab3Controller.reset();
//               if (index == 0) {
//
//                 tab1Controller.forward();
//               }
//               if (index == 1) {
//
//                 tab2Controller.forward();
//               }
//               if (index == 2) {
//
//                 tab3Controller.forward();
//               }
//               setState(() {
//                 _currentIndex = index;
//               });
//               pageControllerTitle.jumpToPage(_currentIndex);
//             },
//           ),
//           body: Container(
//             child: Column(
//               children: [
//                 Container(
//                   color: Color(0xFFfafbfc),
//                   height: MediaQueryData.fromWindow(window).padding.top,
//                 ),
//                 Container(
//                   color: Color(0xFFfafbfc),
// //              color: Colors.blue,
//                   width: MediaQuery.of(context).size.width,
//                   height: 52,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         height: 52,
//                         width: MediaQuery.of(context).size.width / 3,
//                         child: Container(
//                           child: Container(
//                             decoration: new BoxDecoration(
//                               //??????
//                               //?????????????????? ??????
//                               borderRadius: BorderRadius.all(Radius.circular(25)),
//                             ),
//                             child: PageView.builder(
//                               itemCount: 3,
//                               controller: pageControllerTitle,
//                               physics: NeverScrollableScrollPhysics(),
//                               allowImplicitScrolling: true,
//                               pageSnapping: false,
//                               itemBuilder: (context, position) {
//                                 if (position == 0) {
//                                   return Container(
//                                     height: 52,
//                                     margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       S.of(context).tab_1,
//                                       style: TextStyle(
//                                         color: Color(0xFF000000),
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 24,
//                                         fontFamily: BoxApp.language == "cn"
//                                             ? "Ubuntu"
//                                             : BoxApp.language == "cn"
//                                                 ? "Ubuntu"
//                                                 : "Ubuntu",
//                                       ),
//                                     ),
//                                   );
//                                 } else if (position == 1) {
//                                   return Container(
//                                     height: 52,
//                                     margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       S.of(context).tab_2,
//                                       style: TextStyle(
//                                         color: Color(0xFF000000),
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 24,
//                                         fontFamily: BoxApp.language == "cn"
//                                             ? "Ubuntu"
//                                             : BoxApp.language == "cn"
//                                                 ? "Ubuntu"
//                                                 : "Ubuntu",
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   return Container(
//                                     height: 52,
//                                     margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       S.of(context).tab_3,
//                                       style: TextStyle(
//                                         color: Color(0xFF000000),
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 24,
//                                         fontFamily: BoxApp.language == "cn"
//                                             ? "Ubuntu"
//                                             : BoxApp.language == "cn"
//                                                 ? "Ubuntu"
//                                                 : "Ubuntu",
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                             width: MediaQuery.of(context).size.width / 2,
//                             height: 52,
//                           ),
//                         ),
//                       ),
//                       buildTitleRightIcon(context),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: getBody(),
//                     // child: PageView.builder(
//                     //   itemCount: 3,
//                     //   controller: pageControllerBody,
//                     //   itemBuilder: (context, position) {
//                     //     if (position == 0) {
//                     //       if (account == null) {
//                     //         return Container();
//                     //       }
//                     //       if (account.coin == "AE") {
//                     //         return AeHomePage();
//                     //       }
//                     //       if (account.coin == "CFX") {
//                     //         return CfxHomePage();
//                     //       }
//                     //     } else if (position == 1) {
//                     //       if (account == null) {
//                     //         return Container();
//                     //       }
//                     //       if (account.coin == "AE") {
//                     //         return AeAeppsPage();
//                     //       }
//                     //       if (account.coin == "CFX") {
//                     //         return CfxDappsPage();
//                     //       }
//                     //     } else {
//                     //       return SettingPage();
//                     //     }
//                     //     return Container();
//                     //   },
//                     // ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
      ),
    );
  }

  Future<void> showHint() async {
    var address = await BoxApp.getAddress();
    var accountErrorList = await AeAccountErrorListDao.fetch();

    //?????????????????????????????????????????????
    if (!accountErrorList.contains(address)) {
      return;
    }
    Future.delayed(Duration(seconds: 0), () {
      BoxApp.getMnemonic().then((account) {
        if (account != null) {
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext buildContext) {
              return WillPopScope(
                onWillPop: () async {
                  return Future.value(false);
                },
                child: new AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  title: Text(S.of(context).dialog_hint),
                  content: Text(S.of(context).dialog_save_word),
                  actions: <Widget>[
                    TextButton(
                      child: new Text(
                        S.of(context).dialog_save_go,
                      ),
                      onPressed: () {
                        Navigator.of(buildContext, rootNavigator: false).pop(true);
                      },
                    ),
                  ],
                ),
              );
            },
          ).then((val) async {
            if (val!) {
              var mnemonic = await (BoxApp.getMnemonic() as FutureOr<String>);
              var signKey = await (BoxApp.getSigningKey() as FutureOr<String>);
              var address = await BoxApp.getAddress();

              var msg = "address:" +
                  address +
                  "\n"
                      "mnemonic:" +
                  mnemonic +
                  "\n"
                      "signKey:" +
                  signKey;

              Clipboard.setData(ClipboardData(text: msg));
              Fluttertoast.showToast(msg: "????????????????????????????????????", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
            }
          });
        }
      });
    });
  }

  Widget getBody() {
    if (account == null) return Container();

    if (account!.coin == "AE") {
      return IndexedStack(
        index: _currentIndex,
        children: aeWidget,
      );
    }
    if (account!.coin == "CFX") {
      return IndexedStack(
        index: _currentIndex,
        children: cfxWidget,
      );
    }
    if (account!.coin == "OKT" || account!.coin == "BNB" || account!.coin == "HT" || account!.coin == "ETH") {
      return IndexedStack(
        index: _currentIndex,
        children: ethWidget,
      );
    }
    return Container();
  }

  Positioned buildTitleRightIcon(BuildContext context) {
//    if (TokenDefiPage.model == null || TokenDefiPage.model.data.height == -1) {
//      return Positioned(
//        child: Container(),
//      );

    return Positioned(
      right: 18,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            onTap: () {
              showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  enableDrag: false,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return WalletSelectPage();
                  });
              // Navigator.push(context, SlideRoute( AddAccountPage(coin:coin,password: password,)));
              // Navigator.push(context, SlideRoute( AeTokenSendOnePage()));
            },
            child: Container(
              height: 35,
              decoration: new BoxDecoration(
                //?????????????????? ??????
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                //??????????????????
                border: new Border.all(width: 1, color: Color(0xFFedf3f7)),
                //??????????????????
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                  ),
                  Container(
                    width: 2,
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    margin: const EdgeInsets.only(right: 4),
                    //????????????
                    decoration: new BoxDecoration(
                      // color: Color(0xFFfafbfc),
                      //?????????????????? ??????
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  void showErrorDialog(BuildContext buildContext, String content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
                showHint();
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }
}
