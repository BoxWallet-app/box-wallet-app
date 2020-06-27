import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'numeric_keyboard.dart';

//第一种自定义回调方法
typedef PayPasswordCallBackFuture = Future Function(String password);

class PayPasswordWidget extends StatefulWidget {
  final String title;
  final PayPasswordCallBackFuture passwordCallBackFuture;

  const PayPasswordWidget({Key key, this.title = "请输入你的临时密码", this.passwordCallBackFuture}) : super(key: key);

  @override
  _PayPasswordWidgetState createState() => _PayPasswordWidgetState();
}

class _PayPasswordWidgetState extends State<PayPasswordWidget> {
  String text = '';
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Container(
        height: 400,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 18),
              ),
            ),

            Container(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 35),
                margin: const EdgeInsets.only(bottom: 20),
                child: PinCodeTextField(
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v.length < 3) {
                      return "I'm from validator";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    //内框颜色
                    inactiveFillColor: Colors.white,
                    //边框颜色
                    inactiveColor: Colors.black,
                    //输入后边框颜色
                    activeColor: Colors.black,
                    //选中后边框颜色
                    selectedColor: Colors.purple,
                    //输入后内框颜色
                    activeFillColor: Colors.white,
                    //选中后内框颜色
                    selectedFillColor: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    fieldHeight: 50,
                    fieldWidth: 50,
                  ),
                  animationDuration: Duration(milliseconds: 300),
//                backgroundColor: Colors.red.shade50,
                  enableActiveFill: true,
//                errorAnimationController: errorController,
                  controller: _textEditingController,
                  onCompleted: (v) {
                    if (context != null) {}
                  },
                  onChanged: (value) {
                    setState(() {
                      text = value;
                    });
                    if (value != null && value.length >= 4) {
                      Navigator.pop(context);
                      widget.passwordCallBackFuture(value);
                    }
                  },
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                )),

//          Text(text),
            Container(
              child: NumericKeyboard(
                onKeyboardTap: _onKeyboardTap,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                rightButtonFn: () {
                  if (text.isEmpty) {
                    return;
                  }
                  setState(() {
                    text = text.substring(0, text.length - 1);
                    _textEditingController.text = text;
                  });
                },
                rightIcon: Icon(
                  Icons.backspace,
                ),
                leftButtonFn: () {},
              ),
            )
          ],
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
