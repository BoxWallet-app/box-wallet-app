import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/price_model.dart';
import 'package:box/dao/aeternity/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/chains_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/price_model.dart';
import 'package:box/model/aeternity/token_list_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/page/aeternity/ae_token_add_page.dart';
import 'package:box/page/aeternity/ae_token_record_page.dart';
import 'package:box/page/set_password_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../a.dart';
import 'box_code_mnemonic_page.dart';

typedef SelectMnemonicCallBackFuture = Future Function(String);

class LookMnemonicPage extends StatefulWidget {
  final String mnemonic;

  const LookMnemonicPage({Key key, this.mnemonic}) : super(key: key);

  @override
  _SelectMnemonicPathState createState() => _SelectMnemonicPathState();
}

class _SelectMnemonicPathState extends State<LookMnemonicPage> {
  var loadingType = LoadingType.finish;
  List<String> mnemonics = List();
  PriceModel priceModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "助记词",
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
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {},
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
              child: Text(
                "以下当前账户的助记词,可以用于恢复钱包，请不要泄漏给他人",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withAlpha(180),
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Color(0xFFedf3f7),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  onTap: () {
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 36,
                          decoration: BoxDecoration(border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 0, left: 15),
                                child: Row(
                                  children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 10, bottom: 15, right: 10, left: 10),
                                        child: Text(
                                          widget.mnemonic,
                                          style: new TextStyle(
                                            fontSize: 20,
                                            height: 1.5,
                                            color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
              child: Text(
                "生成快钱包速恢复码，可用于快速登录钱包，免去输入助记词烦恼",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withAlpha(180),
                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: FlatButton(
                  onPressed: () {

                    showGeneralDialog(
                        context: context,
                        pageBuilder: (context, anim1, anim2) {},
                        barrierColor: Colors.grey.withOpacity(.4),
                        barrierDismissible: true,
                        barrierLabel: "",
                        transitionDuration: Duration(milliseconds: 0),
                        transitionBuilder: (_, anim1, anim2, child) {
                          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(0.0, 0, 0.0),
                            child: Opacity(
                              opacity: anim1.value,
                              // ignore: missing_return
                              child: PayPasswordWidget(
                                title: "设置助记词保护码",
                                dismissCallBackFuture: (String password) {
                                  return;
                                },
                                passwordCallBackFuture: (String password) async {
                                  var aesDecode = Utils.aesEncode(widget.mnemonic, Utils.generateMd5Int(password));
                                  print("box_" + aesDecode);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BoxCodeMnemonicPage(code: "box_"+aesDecode)));

                                },
                              ),
                            ),
                          );
                        });



                    return;
                  },
                  child: Text(
                    "生成",
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
      ),
    );
  }
}
