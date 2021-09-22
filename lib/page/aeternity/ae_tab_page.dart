import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:box/a.dart';
import 'package:box/dao/aeternity/version_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/plugin_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/version_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_rpc_model.dart';
import 'package:box/page/aeternity/ae_aepps_page.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/confux/cfx_aepps_page.dart';
import 'package:box/page/confux/cfx_home_page.dart';
import 'package:box/page/setting_page.dart';
import 'package:box/page/wallet_select_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final StreamController<int> _streamController1 = StreamController<int>();
  final StreamController<int> _streamController2 = StreamController<int>();
  final StreamController<int> _streamController3 = StreamController<int>();
  final StreamController<double> _streamControllerLine = StreamController<double>();

  PageController pageControllerBody = PageController();
  PageController pageControllerTitle = PageController();
  BuildContext buildContext;
  Account account;
  CfxRpcModel cfxRpcModel;

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

    eventBus.on<AccountUpdateEvent>().listen((event) {
      getAddress();
      showHint();
    });

    eventBus.on<AccountUpdateNameEvent>().listen((event) {
      getAddress();
    });
    netVersion();
    getAddress();
    showHint();

    MethodChannel _platform = const MethodChannel('BOX_NAV_TO_DART');
    _platform.setMethodCallHandler(myUtilsHandler);
  }

  Future<dynamic> myUtilsHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getGasCFX':
        var data = jsonDecode(methodCall.arguments.toString());
        cfxRpcModel = CfxRpcModel.fromJson(data);

        await BoxApp.getGasCFX((data) async {
          var split = data.split("#");
          cfxRpcModel.payload.storageLimit = split[2].toString();
          cfxRpcModel.payload.gasPrice = "1";
          cfxRpcModel.payload.gas = split[0].toString();

          String value = "- 0 CFX";
          var decimal = Decimal.parse('1000000000000000000');
          if (cfxRpcModel.payload.value != null) {
            value = "- " + (Decimal.parse(int.parse(cfxRpcModel.payload.value).toString()) / decimal).toString() + " CFX";
          }

          var decimal2 = Decimal.parse(int.parse(cfxRpcModel.payload.gas).toString());
          var decimal3 = decimal2 / decimal;
          var storageLimit = Decimal.parse((int.parse(cfxRpcModel.payload.storageLimit).toString()));
          var formatGas = double.parse(decimal3.toString()) + (double.parse(storageLimit.toString()) / 1024);
          await PluginManager.getGasCFX({
            'type': methodCall.method,
            'from': cfxRpcModel.payload.from,
            'to': cfxRpcModel.payload.to,
            'value': value,
            'gas': "- " + formatGas.toString() + " CFX",
            'data': cfxRpcModel.payload.data,
          });
          return;
        }, cfxRpcModel.payload.from, cfxRpcModel.payload.to, cfxRpcModel.payload.value != null ? cfxRpcModel.payload.value : "0", cfxRpcModel.payload.data);

        return 'SUCCESS';
      case 'signTransaction':
        if (cfxRpcModel == null) {
          return 'SUCCESS';
        }
        var password = methodCall.arguments.toString();
        password = Utils.generateMD5(password + a);
        var signingKey = await BoxApp.getSigningKey();
        var address = await BoxApp.getAddress();
        final key = Utils.generateMd5Int(password + address);
        var aesDecode;
        try {
          aesDecode = Utils.aesDecode(signingKey, key);
        } catch (err) {
          await PluginManager.signTransactionError({
            'type': "signTransactionError",
            'data': "ERROR:password error",
          });
          return "SUCCESS";
        }

        if (aesDecode == "") {
          await PluginManager.signTransactionError({
            'type': "signTransactionError",
            'data': "ERROR:password error",
          });
          return 'SUCCESS';
        }
        BoxApp.signTransactionCFX((hash) async {
          await PluginManager.signTransaction({
            'type': methodCall.method,
            'data': hash,
          });
          return 'SUCCESS';
        }, (error) {
          return;
        }, aesDecode, cfxRpcModel.payload.storageLimit != null ? cfxRpcModel.payload.storageLimit : "0", cfxRpcModel.payload.gas != null ? cfxRpcModel.payload.gas : "0", cfxRpcModel.payload.gasPrice != null ? cfxRpcModel.payload.gasPrice : "0", cfxRpcModel.payload.value != null ? cfxRpcModel.payload.value : "0", cfxRpcModel.payload.to, cfxRpcModel.payload.data);

        return 'SUCCESS';

      default:
        throw MissingPluginException('notImplemented');
    }
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account account) {
      AeHomePage.address = account.address;
      this.account = account;
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
          oldVersion = 1000;
          if (newVersion > oldVersion) {
            if (model.data.msgCN == null) {
              model.data.msgCN = "发现新版本";
            }
            if (model.data.msgEN == null) {
              model.data.msgEN = "Discover a new version";
            }
            Future.delayed(Duration.zero, () {
              model.data.isMandatory == "1"
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
                              BoxApp.language == "cn" ? model.data.msgCN : model.data.msgEN,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: new Text(
                                  S.of(context).dialog_conform,
                                ),
                                onPressed: () {
                                  if (Platform.isIOS) {
                                    _launchURL(model.data.urlIos);
                                  } else if (Platform.isAndroid) {
                                    _launchURL(model.data.urlAndroid);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ).then((value) {
                      if (value) {}
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
                            BoxApp.language == "cn" ? model.data.msgCN : model.data.msgEN,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: new Text(
                                S.of(context).dialog_cancel,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: new Text(
                                S.of(context).dialog_conform,
                              ),
                              onPressed: () {
                                if (Platform.isIOS) {
                                  _launchURL(model.data.urlIos);
                                } else if (Platform.isAndroid) {
                                  _launchURL(model.data.urlAndroid);
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

  void showHint() {
    Future.delayed(Duration(seconds: 0), () {
      BoxApp.getSaveMnemonic().then((account) {
        if (account) {
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
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
                        Navigator.of(context, rootNavigator: false).pop(true);
                      },
                    ),
                  ],
                ),
              );
            },
          ).then((val) {
            if (val) {
              showGeneralDialog(
                  useRootNavigator: false,
                  context: super.context,
                  pageBuilder: (context, anim1, anim2) {
                    return;
                  },
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
                            var mnemonic = await BoxApp.getMnemonic();
                            if (mnemonic == "") {
                              showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                                  return new AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                    title: Text(S.of(context).dialog_hint),
                                    content: Text(S.of(context).dialog_login_user_no_save),
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
                            var address = await BoxApp.getAddress();
                            final key = Utils.generateMd5Int(password + address);
                            var aesDecode = Utils.aesDecode(mnemonic, key);

                            if (aesDecode == "") {
                              showErrorDialog(context, null);
                              return;
                            }
                            Navigator.push(context, SlideRoute(MnemonicCopyPage(mnemonic: aesDecode)));
                          },
                        ),
                      ),
                    );
                  });
            }
          });
        }
      });
    });
  }

  DateTime lastPopTime;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: "再按一次退出", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            exit(0);
          }
        },

        child: Scaffold(
          backgroundColor: Color(0xFFfafbfc),
          resizeToAvoidBottomInset: false,
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
                      buildTitleRightIcon(context),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      itemCount: 3,
                      controller: pageControllerBody,
                      itemBuilder: (context, position) {
                        if (position == 0) {
                          if (account == null) {
                            return Container();
                          }
                          if (account.coin == "AE") {
                            return AeHomePage();
                          }
                          if (account.coin == "CFX") {
                            return CfxHomePage();
                          }
                        } else if (position == 1) {
                          if (account == null) {
                            return Container();
                          }
                          if (account.coin == "AE") {
                            return AeAeppsPage();
                          }
                          if (account.coin == "CFX") {
                            return CfxDappsPage();
                          }
                        } else {
                          return SettingPage();
                        }
                        return Container();
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
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                //设置四周边框
                border: new Border.all(width: 1, color: Color(0xFFedf3f7)),
                //设置四周边框
              ),
              padding: EdgeInsets.only(left: 4, right: 4),
              margin: const EdgeInsets.only(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (account != null)
                    ClipOval(
                      child: Container(
                        width: 27.0,
                        height: 27.0,
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
                            image: AssetImage("images/" + account.coin + ".png"),
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
                    //边框设置
                    decoration: new BoxDecoration(
                      // color: Color(0xFFfafbfc),
                      //设置四周圆角 角度
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
    if (account.name == null || account.name == "") {
      return Utils.formatAccountAddress(account.address);
    } else {
      return account.name;
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
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }
}
