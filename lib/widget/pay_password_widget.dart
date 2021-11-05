import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/a.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
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
  final int color;
  final bool isSignOld;
  final bool isAddressPassword;
  final PayPasswordCallBackFuture passwordCallBackFuture;
  final PayPasswordCallBackFuture dismissCallBackFuture;

  const PayPasswordWidget({Key key, this.title = "请输入你的安全密码", this.passwordCallBackFuture, this.dismissCallBackFuture, this.color = 0xFFFC2365, this.isSignOld = false, this.isAddressPassword = false}) : super(key: key);

  @override
  _PayPasswordWidgetState createState() {
    return _PayPasswordWidgetState();
  }
}

class _PayPasswordWidgetState extends State<PayPasswordWidget> {
  String text = '';
  FocusNode _commentFocus = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  var marginBottom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) FocusScope.of(context).requestFocus(_commentFocus);
    });



  }

  //异步加载方法
  Future<int> _loadFuture() async {
    var account = await WalletCoinsManager.instance.getCurrentAccount();
    print( account.accountType);
    return account.accountType;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _loadFuture(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot == null || snapshot.data == null) {
            return Container();
          }
          if(snapshot.data == AccountType.ADDRESS && widget.isAddressPassword == false){

            return  Material(
              color: Color(0x00000000).withAlpha(100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
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
                                  // ignore: unnecessary_statements
                                  if (widget.dismissCallBackFuture != null) widget.dismissCallBackFuture("");
                                  Navigator.of(context).pop(); //关闭对话框
                                },
                                child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              S.of(context).PayPasswordWidget_account_look_msg,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 20),
                            child: Container(
                              height: 40,
                              width: 120,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); //关闭对话框
                                  if (widget.dismissCallBackFuture != null) widget.dismissCallBackFuture("");

                                },
                                child: Text(
                                  S.of(context).password_widget_conform,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
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
                  ),
                ],
              ),
            );
          }
        return Material(
          color: Color(0x00000000).withAlpha(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 260,
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
                              // ignore: unnecessary_statements
                              if (widget.dismissCallBackFuture != null) widget.dismissCallBackFuture("");
                              Navigator.of(context).pop(); //关闭对话框
                            },
                            child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          ),
                        ),
                      ),

                      Container(
                        height: 45,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
//                      padding: EdgeInsets.only(left: 10, right: 10),
                        //边框设置
                        decoration: new BoxDecoration(
                          color: Color(0xFFedf3f7),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: TextField(
                          controller: _textEditingController,
                          focusNode: _commentFocus,
                          inputFormatters: [
                          ],
                          obscureText:true,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                            hintText: "",
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
                        margin: const EdgeInsets.only(top: 30, bottom: 20),
                        child: Container(
                          height: 40,
                          width: 120,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(); //关闭对话框
                              if(widget.isSignOld){
                                widget.passwordCallBackFuture(_textEditingController.text);
                              }else{
                                widget.passwordCallBackFuture(Utils.generateMD5(_textEditingController.text + a));
                              }

                            },
                            child: Text(
                              S.of(context).password_widget_conform,
                              maxLines: 1,
                              style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
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
              ),
            ],
          ),
        );
      }
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
