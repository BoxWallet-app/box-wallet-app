// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:box/config.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthPage extends BaseWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends BaseWidgetState<AuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
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
    if (!mounted) return;

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
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xfffafafa),
      body: Container(
        margin: EdgeInsets.only(left: 18, right: 18),
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
                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                  if (value) {
                                    showPasswordDialog(context, (address, privateKey,mnemonic,  password) async {
                                      BoxApp.setPassword(Utils.aesEncode(password, Utils.generateMd5Int(AUTH_KEY)));
                                      setState(() {
                                        isOpenAuth = value;
                                      });
                                      BoxApp.setAuth(isOpenAuth);
                                    });
                                  } else {
                                    setState(() {
                                      isOpenAuth = value;
                                    });
                                    BoxApp.setPassword("");
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
