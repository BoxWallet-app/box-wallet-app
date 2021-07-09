import 'package:box/generated/l10n.dart';
import 'package:box/widget/qrcode_reader_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScanPage extends StatefulWidget {

  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrcodeReaderView(
        key: _key,
        onScan: onScan,
        boxLineColor:Color(0xFFFC2365),
        headerWidget: Container(
          child: AppBar(
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
        ),
        helpWidget: Text(
          S.of(context).scan_page_content,
        ),
      ),
    );
  }

  Future onScan(String data) async {
    if(data == null){
      return;
    }
    Navigator.pop(context,data);
//    await showCupertinoDialog(
//      context: context,
//      builder: (context) {
//
//        return CupertinoAlertDialog(
//          title: Text("扫码结果"),
//          content: Text(data),
//          actions: <Widget>[
//            CupertinoDialogAction(
//              child: Text("确认"),
//              onPressed: () => Navigator.pop(context),
//            )
//          ],
//        );
//      },
//    );
//    _key.currentState.startScan();
  }
}
