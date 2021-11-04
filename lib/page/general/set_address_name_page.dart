import 'dart:ui';

import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/page/general/select_chain_create_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../main.dart';

typedef SetAddressNamePageCallBackFuture = Future Function();

class SetAddressNamePage extends StatefulWidget {
  final SetAddressNamePageCallBackFuture setAddressNamePageCallBackFuture;
  final String address;
  final String name;

  const SetAddressNamePage({Key key, this.address, this.name, this.setAddressNamePageCallBackFuture}) : super(key: key);

  @override
  _SetAddressNamePageState createState() => _SetAddressNamePageState();
}

class _SetAddressNamePageState extends State<SetAddressNamePage> {
  var loadingType = LoadingType.finish;

  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).SetAddressNamePage_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: LoadingWidget(
          type: loadingType,
          onPressedError: () {},
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Container(
                  margin: EdgeInsets.only(left: 18, top: 10,right: 18),
                  alignment: Alignment.topLeft,
                  child: Text(
                  S.of(context).SetAddressNamePage_title2,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 18, top: 10,right: 18),
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.address,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12, left: 15, right: 15),
                  child: Stack(
                    children: [
                      Container(
                        // height: 70,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                        //边框设置
                        decoration: new BoxDecoration(
                          color: Color(0xFFedf3f7),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _textEditingControllerNode,
                          focusNode: focusNodeNode,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                          inputFormatters: [
                            // WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                          ],
                          maxLines: 1,

                          style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: 18,
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                            color: Colors.black,
                            letterSpacing: 1.0,
                          ),
                          maxLength: 8,
                          // maxLength: 8,
                          decoration: InputDecoration(
                            counterText: "",//此处控制最大字符是否显示

                            // contentPadding: EdgeInsets.only(left: 10.0),
                            hintText: widget.name,
                            contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xFFFC2365)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF666666).withAlpha(85),
                            ),
                          ),

                          cursorColor: Color(0xFFFC2365),
                          cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      onPressed: () {
                        if (_textEditingControllerNode.text == null || _textEditingControllerNode.text == "") {
                          if(widget.setAddressNamePageCallBackFuture!=null){
                            widget.setAddressNamePageCallBackFuture();
                            Navigator.of(context).pop();
                          }
                          return;
                        }
                        EasyLoading.show();
                        WalletCoinsManager.instance.getCoins().then((walletCoinsModel) async {
                          for (var i = 0; i < walletCoinsModel.coins.length; i++) {
                            for (var j = 0; j < walletCoinsModel.coins[i].accounts.length; j++) {
                              var address =walletCoinsModel.coins[i].accounts[j].address;
                              if(address == widget.address){
                                walletCoinsModel.coins[i].accounts[j].name = _textEditingControllerNode.text;
                                break;
                              }
                            }
                          }
                          EasyLoading.dismiss();
                          WalletCoinsManager.instance.setCoins(walletCoinsModel);
                          eventBus.fire(AccountUpdateNameEvent());
                          if(widget.setAddressNamePageCallBackFuture!=null){
                            widget.setAddressNamePageCallBackFuture();
                            Navigator.of(context).pop();
                          }

                        });
                        return;
                      },
                      child: Text(
                        S.of(context).account_login_page_conform,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                      ),
                      color: Color(0xFFFC2365),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),

            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment:  CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
