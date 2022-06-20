import 'dart:developer';
import 'dart:io';

import 'package:box/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(child: _buildQrView(context)),
              // Expanded(
              //   flex: 1,
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         if (result != null) Text('Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}') else const Text('Scan a code'),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                   onPressed: () async {
              //                     await controller?.toggleFlash();
              //                     setState(() {});
              //                   },
              //                   child: FutureBuilder(
              //                     future: controller?.getFlashStatus(),
              //                     builder: (context, snapshot) {
              //                       return Text('Flash: ${snapshot.data}');
              //                     },
              //                   )),
              //             ),
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                   onPressed: () async {
              //                     await controller?.flipCamera();
              //                     setState(() {});
              //                   },
              //                   child: FutureBuilder(
              //                     future: controller?.getCameraInfo(),
              //                     builder: (context, snapshot) {
              //                       if (snapshot.data != null) {
              //                         return Text('Camera facing ${describeEnum(snapshot.data)}');
              //                       } else {
              //                         return const Text('loading');
              //                       }
              //                     },
              //                   )),
              //             )
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                 onPressed: () async {
              //                   await controller?.pauseCamera();
              //                 },
              //                 child: const Text('pause', style: TextStyle(fontSize: 20)),
              //               ),
              //             ),
              //             Container(
              //               margin: const EdgeInsets.all(8),
              //               child: ElevatedButton(
              //                 onPressed: () async {
              //                   await controller?.resumeCamera();
              //                 },
              //                 child: const Text('resume', style: TextStyle(fontSize: 20)),
              //               ),
              //             )
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
          Positioned(
            bottom: 100,
            child: Container(
              width: MediaQuery.of(context).size.width ,
              alignment: Alignment.center,
              child: Text(

                S.of(context).scan_page_content,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          AppBar(
            backgroundColor: Color(0x22000000),
            // 隐藏阴影
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 17,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        if (this.controller != null) return;
        this.controller = controller;
        this.controller!.scannedDataStream.listen((scanData) {
          print(scanData.code);
          if (result != null) return;
          result = scanData;

          if (!mounted) return;
          Navigator.pop(context,scanData.code);
          return;
        });
        setState(() {});
      },
      overlay: QrScannerOverlayShape(borderColor: Color(0xFFFC2365), borderRadius: 10, borderLength: 20, borderWidth: 10, cutOutSize: 300),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
