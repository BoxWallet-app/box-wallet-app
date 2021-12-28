// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:box/config.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool isOpenAuth = false;

  @override
  void initState() {
    super.initState();
    getAuth();
    availableBiometrics();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
        );
  }

  getAuth() async {
    isOpenAuth = await BoxApp.getAuth();
    setState(() {});
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  String title = "";

  Future<void> availableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    print(availableBiometrics);
    if (!mounted) return _availableBiometrics = availableBiometrics;

    if (availableBiometrics[0] == BiometricType.face) {
      title = S.current.auth_title_1;
    }
    if (availableBiometrics[0] == BiometricType.fingerprint) {
      title = S.current.auth_title_2;
    }
    if (availableBiometrics[0] == BiometricType.iris) {
      title = S.current.auth_title_3;
    }
    print(title);
    setState(() {});
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = '进行身份验证';
      });
      authenticated = await auth.authenticate(localizedReason: '让OS决定认证方法', useErrorDialogs: true, stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = '进行身份验证';
      });
      authenticated = await auth.authenticate(localizedReason: '扫描你的指纹(或脸或其他)来验证', useErrorDialogs: true, stickyAuth: true, biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = '进行身份验证';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? '授权' : '未授权';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xfffafafa),
      body: Container(
        margin: EdgeInsets.only(left: 18,right: 18),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                  child: Container(

                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              /*1*/
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*2*/
                                  Container(
                                    child: Text(
                                      S.of(context).auth_pay_title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              child: Switch(
                                value: isOpenAuth,
                                activeColor: Color(0xFFFC2365),
                                onChanged: (value) {

                                  if(value){
                                    showGeneralDialog(
                                        useRootNavigator: false,
                                        context: context,
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
                                                dismissCallBackFuture: (String password) {return;},
                                                passwordCallBackFuture: (String password) async {
                                                  var signingKey = await BoxApp.getSigningKey();
                                                  var address = await BoxApp.getAddress();
                                                  final key = Utils.generateMd5Int(password + address);
                                                  var signingKeyDecode = Utils.aesDecode(signingKey, key);

                                                  if (signingKeyDecode == "") {
                                                    showDialog<bool>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext dialogContext) {
                                                        return new AlertDialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                                          title: Text(S.of(context).dialog_hint_check_error),
                                                          content: Text(S.of(context).dialog_hint_check_error_content),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: new Text(
                                                                S.of(context).dialog_conform,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(dialogContext).pop(false);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ).then((val) {
                                                    });

                                                    return;
                                                  }
                                                  BoxApp.setPassword(Utils.aesEncode(password, Utils.generateMd5Int(AUTH_KEY)));
                                                  setState(() {
                                                    isOpenAuth = value;
                                                  });
                                                  BoxApp.setAuth(isOpenAuth);

                                                },
                                              ),
                                            ),
                                          );
                                        });
                                  }else{

                                    setState(() {
                                      isOpenAuth = value;
                                    });
                                    BoxApp.setAuth(isOpenAuth);
                                  }

                                },
                              ),
                            ),
                            /*3*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // if (_supportState == _SupportState.unknown) CircularProgressIndicator() else if (_supportState == _SupportState.supported) Text("支持此设备") else Text("不支持该设备"),
                // Divider(height: 100),
                // Text('可以检查生物识别技术:$_canCheckBiometrics\n'),
                // ElevatedButton(
                //   child: const Text('检查生物识别技术'),
                //   onPressed: _checkBiometrics,
                // ),
                // Divider(height: 100),
                // Text('可用的生物识别技术:$_availableBiometrics\n'),
                // ElevatedButton(
                //   child: const Text('获得可用的生物识别技术'),
                //   onPressed: availableBiometrics,
                // ),
                // Divider(height: 100),
                // Text('当前状态: $_authorized\n'),
                // (_isAuthenticating)
                //     ? ElevatedButton(
                //         onPressed: _cancelAuthentication,
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text("取消认证"),
                //             Icon(Icons.cancel),
                //           ],
                //         ),
                //       )
                //     : Column(
                //         children: [
                //           ElevatedButton(
                //             child: Row(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 Text('进行身份验证'),
                //                 Icon(Icons.perm_device_information),
                //               ],
                //             ),
                //             onPressed: _authenticate,
                //           ),
                //           ElevatedButton(
                //             child: Row(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 Text(_isAuthenticating ? '取消' : '验证:生物识别技术'),
                //                 Icon(Icons.fingerprint),
                //               ],
                //             ),
                //             onPressed: _authenticateWithBiometrics,
                //           ),
                //         ],
                //       ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
