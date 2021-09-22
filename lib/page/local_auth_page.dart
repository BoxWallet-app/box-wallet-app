// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// // ignore_for_file: public_member_api_docs
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
//
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool _canCheckBiometrics;
//   List<BiometricType> _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (isSupported) => setState(() => _supportState = isSupported
//           ? _SupportState.supported
//           : _SupportState.unsupported),
//     );
//   }
//
//   Future<void> _checkBiometrics() async {
//      bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }
//
//   Future<void> _getAvailableBiometrics() async {
//      List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _availableBiometrics = availableBiometrics;
//     });
//   }
//
//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = '进行身份验证';
//       });
//       authenticated = await auth.authenticate(
//           localizedReason: '让OS决定认证方法',
//           useErrorDialogs: true,
//           stickyAuth: true);
//       setState(() {
//         _isAuthenticating = false;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;
//
//     setState(
//             () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
//   }
//
//   Future<void> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = '进行身份验证';
//       });
//       authenticated = await auth.authenticate(
//           localizedReason:
//           '扫描你的指纹(或脸或其他)来验证',
//           useErrorDialogs: true,
//           stickyAuth: true,
//           biometricOnly: true);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = '进行身份验证';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;
//
//     final String message = authenticated ? '授权' : '未授权';
//     setState(() {
//       _authorized = message;
//     });
//   }
//
//   void _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (_supportState == _SupportState.unknown)
//                   CircularProgressIndicator()
//                 else if (_supportState == _SupportState.supported)
//                   Text("支持此设备")
//                 else
//                   Text("不支持该设备"),
//                 Divider(height: 100),
//                 Text('可以检查生物识别技术:$_canCheckBiometrics\n'),
//                 ElevatedButton(
//                   child: const Text('检查生物识别技术'),
//                   onPressed: _checkBiometrics,
//                 ),
//                 Divider(height: 100),
//                 Text('可用的生物识别技术:$_availableBiometrics\n'),
//                 ElevatedButton(
//                   child: const Text('获得可用的生物识别技术'),
//                   onPressed: _getAvailableBiometrics,
//                 ),
//                 Divider(height: 100),
//                 Text('当前状态: $_authorized\n'),
//                 (_isAuthenticating)
//                     ? ElevatedButton(
//                   onPressed: _cancelAuthentication,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("取消认证"),
//                       Icon(Icons.cancel),
//                     ],
//                   ),
//                 )
//                     : Column(
//                   children: [
//                     ElevatedButton(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('进行身份验证'),
//                           Icon(Icons.perm_device_information),
//                         ],
//                       ),
//                       onPressed: _authenticate,
//                     ),
//                     ElevatedButton(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(_isAuthenticating
//                               ? '取消'
//                               : '验证:生物识别技术'),
//                           Icon(Icons.fingerprint),
//                         ],
//                       ),
//                       onPressed: _authenticateWithBiometrics,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }
