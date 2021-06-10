import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'numeric_keyboard.dart';


//第一种自定义回调方法
typedef PayPasswordCallBackFuture = Future Function(String password);
typedef PayDismissCallBackFuture = Future Function(String password);

class WeTrueCommentInputWidget extends StatefulWidget {
  final String title;
  final int color;
  final PayPasswordCallBackFuture passwordCallBackFuture;
  final PayPasswordCallBackFuture dismissCallBackFuture;

  const WeTrueCommentInputWidget({Key key, this.title = "请输入你的安全密码", this.passwordCallBackFuture, this.dismissCallBackFuture, this.color = 0xFFFC2365}) : super(key: key);

  @override
  _WeTrueCommentInputWidgetState createState() => _WeTrueCommentInputWidgetState();
}

class _WeTrueCommentInputWidgetState extends State<WeTrueCommentInputWidget> {
  String text = '';
  FocusNode _commentFocus = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  var marginBottom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 800), () {
      FocusScope.of(context).requestFocus(_commentFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent.withAlpha(0),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width ,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: ShapeDecoration(
          color: Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0),

            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              height: 40,
              width: MediaQuery.of(context).size.width-20,
              margin: EdgeInsets.only(left: 16, right: 16),
//                      padding: EdgeInsets.only(left: 10, right: 10),
              //边框设置
              decoration: new BoxDecoration(
                color: Color(0xFFeeeeee),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: TextField(
                controller: _textEditingController,
                focusNode: _commentFocus,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                inputFormatters: [
//                    WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
                ],
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10.0),
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFFeeeeee),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFFFC2365)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: "有爱评论，说点好听的~",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withAlpha(180),
                  ),
                ),
                cursorColor: Color(0xFFFC2365),
                cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width-32,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context); //关闭对话框
                    widget.passwordCallBackFuture(_textEditingController.text);
                  },
                  child: Text(
                    S.of(context).password_widget_conform+" "+widget.title+"AE",
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xffffffff)),
                  ),
                  color: Color(0xFFFC2365),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
//          Text(text),
          ],
        ),
      ),
    );
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
