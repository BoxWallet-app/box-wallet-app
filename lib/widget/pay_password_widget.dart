import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'numeric_keyboard.dart';

//第一种自定义回调方法
typedef PayPasswordCallBackFuture = Future Function(String password);
typedef PayDismissCallBackFuture = Future Function(String password);

class PayPasswordWidget extends StatefulWidget {
  final String title;
  final PayPasswordCallBackFuture passwordCallBackFuture;
  final PayPasswordCallBackFuture dismissCallBackFuture;

  const PayPasswordWidget({Key key, this.title = "请输入你的安全密码", this.passwordCallBackFuture, this.dismissCallBackFuture}) : super(key: key);

  @override
  _PayPasswordWidgetState createState() => _PayPasswordWidgetState();
}

class _PayPasswordWidgetState extends State<PayPasswordWidget> {
  String text = '';
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width - 40,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 40,
                alignment: Alignment.topLeft,
                child: Material(

                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    onTap: () {
                      Navigator.pop(context); //关闭对话框
                      // ignore: unnecessary_statements
                      widget.dismissCallBackFuture("");
                    },
                    child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 18,fontFamily: "Ubuntu",),
                ),
              ),

              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: TextField(
                            textAlign: TextAlign.center,
                            autofocus: true, //是否自动获取焦点
                            controller: _textEditingController,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 19,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            maxLength: 20,
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '',
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0x00000000)),
                              ),
// and:
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0x00000000)),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 19,
                                textBaseline: TextBaseline.alphabetic,
                                color: Colors.black.withAlpha(80),
                              ),
                            ),
                            cursorColor: Color(0xFFFC2365),
                            cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

        Container(
          margin: const EdgeInsets.only(top: 30,bottom: 20),
          child: ArgonButton(
            height: 40,
            roundLoadingShape: true,
            width: 120,
            onTap: (startLoading, stopLoading, btnState) {
              Navigator.pop(context); //关闭对话框
              widget.passwordCallBackFuture(_textEditingController.text);
            },
            child: Text(
              S.of(context).password_widget_conform,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,fontFamily: "Ubuntu",),
            ),
            loader: Container(
              padding: EdgeInsets.all(10),
              child: SpinKitRing(
                lineWidth: 4,
                color: Colors.white,
                // size: loaderWidth ,
              ),
            ),
            borderRadius: 30.0,
            color: Color(0xFFFC2365),
          ),
        ) ,

//          Text(text),
            ],
          ),
        ),
      ),
    ));
  }

  _onKeyboardTap(String value) {
    if (value.isEmpty) {
      return;
    }
    setState(() {
      text = text + value;
      _textEditingController.text = text;
    });
  }
}
