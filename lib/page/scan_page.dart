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
        boxLineColor:Color(0xFFE71766),
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
              tooltip: 'Navigreation',
              onPressed: () => Navigator.pop(context),
            ),



          ),
        ),
        helpWidget: Text(
"扫二维码进行付款 / 授权登录"
        ),
      ),
    );
  }

  Future onScan(String data) async {
    if(data == null){
      print(data);
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
