import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/ct_token_manager.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_token_defi_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/page/ethereum/eth_home_page.dart';
import 'package:box/page/login_page_new.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'aeternity/ae_home_page.dart';
import 'confux/node_select_page.dart';
import 'language_page.dart';
import 'local_auth_page.dart';
import 'look_mnemonic_page.dart';
import 'general/node_page.dart';

class SettingPage extends BaseWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BaseWidgetState<SettingPage> with AutomaticKeepAliveClientMixin<SettingPage> {
  var mnemonic = "";
  var version = "";
  var authTitle = "";
  String? coin = "AE";
  Account? account;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMnemonic();
    availableBiometrics();
    eventBus.on<LanguageEvent>().listen((event) async {
      await availableBiometrics();
      setState(() {});
    });
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    eventBus.on<AccountUpdateEvent>().listen((event) {
      getAddress();
    });
    getAddress();
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? acc) {
      coin = acc!.coin;
      account = acc;
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> availableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    bool deviceSupported = await auth.isDeviceSupported();

    if (deviceSupported) {
      if (availableBiometrics.isNotEmpty) {
        if (availableBiometrics[0] == BiometricType.face) {
          authTitle = S.of(context).auth_title_1;
        }
        if (availableBiometrics[0] == BiometricType.fingerprint) {
          authTitle = S.of(context).auth_title_2;
        }
        if (availableBiometrics[0] == BiometricType.iris) {
          authTitle = S.of(context).auth_title_3;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //需要调用super

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFfafbfc),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 17,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).setting_page_title,
          style: new TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
      ),
      backgroundColor: Color(0xFFfafbfc),
      body: Container(

        child: EasyRefresh(
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
                if (authTitle != "")
                  Container(
//              color: Colors.white,
                    height: 12,
                  ),
                if (authTitle != "")
                  buildItem(context, authTitle, "images/setting_node.png", () {
                    if (Platform.isIOS) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
                    } else {
                      Navigator.push(context, SlideRoute(AuthPage()));
                    }
                  }, isLine: false),
                Container(
//              color: Colors.white,
                  height: 12,
                ),
                if (account != null && (account!.accountType == AccountType.MNEMONIC || account!.accountType == AccountType.PRIVATE_KEY))
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                      color: Color(0xE6FFFFFF),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        onTap: () {
                          showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LookMnemonicPage(
                                          mnemonic: mnemonic,
                                          privateKey: privateKey,
                                        )));
                          });
                        },
                        child: Container(
                          height: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Text(
                                        S.of(context).SettingPage_mnemonic,
                                        style: new TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 20,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Color(0xFFe0e0e0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  height: 12,
                ),
                buildItem(context, S.of(context).setting_page_node_set, "images/setting_node.png", () {
                  if (Platform.isIOS) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NodeSelectPage()));
                  } else {
                    Navigator.push(context, SlideRoute(NodeSelectPage()));
                  }
                }, isLine: false),
                Container(
                  height: 12,
                ),
                buildItem(context, S.of(context).setting_page_item_language, "images/setting_lanuage.png", () {
                  if (Platform.isIOS) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
                  } else {
                    Navigator.push(context, SlideRoute(LanguagePage()));
                  }
                }, isLine: false),
                Container(
//              color: Colors.white,
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      child: Container(
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Text(
                                      S.of(context).setting_page_item_version,
                                      style: new TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              right: 35,
                              child: Text("v" + version),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      onTap: () {
                        // Navigator.push(context, SlideRoute(MyApp()));
                        if (BoxApp.language == "cn") {
                          Share.share('AeBox 一个AE去中心化魔法盒子 https://aebox.io');
                        } else {
                          Share.share('AeBox is an AE decentralized magic box https://aebox.io');
                        }
                      },
                      child: Container(
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Text(
                                      S.of(context).setting_page_item_share,
                                      style: new TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
//              color: Colors.white,
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                    color: Color(0xE6FFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      onTap: () {
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return new AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              title: new Text(S.of(context).setting_clear_data_title),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text(S.of(context).setting_clear_data_content),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text(S.of(context).dialog_dismiss),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop(false);
                                  },
                                ),
                                new TextButton(
                                  child: new Text(S.of(context).dialog_conform),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop(true);
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((val) async {
                          if (val!) {
                            AeHomePage.token = "loading...";
                            AeHomePage.tokenABC = "loading...";
                            AeTokenDefiPage.model = null;
                            EthHomePage.account = null;
                            EthHomePage.token = "loading...";
                            EthHomePage.tokenABC = "0.000000";
                            EthHomePage.address = "";

                            var prefs = await SharedPreferences.getInstance();

                            var language = await BoxApp.getLanguage();
                            prefs.clear();
                            prefs.setString('is_language', "true");
                            BoxApp.setLanguage(language);
                            BoxApp.language = language;
                            WalletCoinsManager.instance.setCoins(null);
                            Navigator.pushReplacement(context, SlideRoute(LoginPageNew()));
                          }
                        });
                      },
                      child: Container(
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Center(
                                child: Container(
                              padding: const EdgeInsets.only(left: 7),
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).setting_page_item_logout,
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.red,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _launchURL("https://qm.qq.com/cgi-bin/qm/qr?k=jnFWHm16iJM888smlrKE5PUkbshkdUT5&authKey=dGXI17gaZNaGwlDfLxFt1vWYqQLrvxrzGZiEMWgSKytSjWabHnSLz/f/PG9EQsre&noverify=0");
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage("images/qq.png"),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("https://twitter.com/box_wallet_app");
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage("images/twitter.png"),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("https://t.me/boxaepp");
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage("images/telegram.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    S.of(context).settings_contact,
                    style: new TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getMnemonic() {
    BoxApp.getAddress().then((String mnemonic) {
      setState(() {
        this.mnemonic = mnemonic;
      });
    });
  }

  Widget buildItem(BuildContext context, String content, String assetImage, GestureTapCallback tab, {bool isLine = true}) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          onTap: tab,
          child: Container(
            decoration: new BoxDecoration(
              border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
              color: Color(0xE6FFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: <Widget>[
//                    Image(
//                      width: 30,
//                      height: 30,
//                      image: AssetImage(assetImage),
//                    ),
                      Container(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                          content,
                          style: new TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Color(0xFFe0e0e0),
                  ),
                ),
                if (isLine)
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFfafbfc)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
