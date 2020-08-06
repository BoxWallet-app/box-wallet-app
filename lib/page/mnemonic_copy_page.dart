import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/page/mnemonic_confirm_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MnemonicCopyPage extends StatefulWidget {
  @override
  _AccountRegisterPageState createState() => _AccountRegisterPageState();
}

class _AccountRegisterPageState extends State<MnemonicCopyPage> {
  var mnemonicWord = Map<String, bool>();
  var childrenFalse = List<Widget>();
  var childrenTrue = List<Widget>();
  var childrenWordTrue = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String mnemonic = "memory pool equip lesson limb naive endorse advice lift result track gravity";
    List mnemonicList = mnemonic.split(" ");
    for (String item in mnemonicList) {
      mnemonicWord[item] = false;
    }

    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
            tooltip: 'Navigreation',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  "请抄写助记词",
                  style: TextStyle(color: Color(0xFF000000), fontSize: 24),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  "助记词用于恢复钱包,按照顺序将下方12个单词抄写纸上,并保存到安全的地方",
                  style: TextStyle(color: Color(0xFF000000), fontSize: 14),
                ),
              ),

              Container(
                height: 60,
                padding: EdgeInsets.only(left: 18, right: 18),
                color: Color(0xFFEEEEEE),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                        height: 50,
                      color: Color(0xFF000000),
//                      child: Image(
//                        width: 50,
//                        height: 50,
//                        color: Color(0xffff0000),
//                        image: AssetImage("images/profile_info.png"),
//                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                    Container(

                      child: Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Color(0xffff0000), fontSize: 14.0),
                            children: <TextSpan>[
                              TextSpan(text: '请勿截图! '),
                              TextSpan(
                                  text: '如果有人获取了你的助记词将直接获取你的资产!',
                                  style: TextStyle(color: Color(0xFF000000)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
//                        }
                                    }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Wrap(
                    spacing: 10, //主轴上子控件的间距
                    runSpacing: 10, //交叉轴上子控件之间的间距
                    children: childrenFalse,
                  ),
                ),
              ),
//              Container(
//                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//                width: MediaQuery.of(context).size.width,
//                child: Wrap(
//                  spacing: 10, //主轴上子控件的间距
//                  runSpacing: 10, //交叉轴上子控件之间的间距
//                  children: childrenFalse,
//                ),
//              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: ArgonButton(
                  height: 50,
                  roundLoadingShape: true,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onTap: (startLoading, stopLoading, btnState) {
                    print("123");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MnemonicConfirmPage()));
                  },
                  child: Text(
                    "我已安全保存",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
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
              )
            ],
          ),
        ));
  }

  updateData() {
    childrenFalse.clear();

    mnemonicWord.forEach((k, v) {
      if (!v) childrenFalse.add(getItemContainer(k, false));
    });

    childrenTrue.clear();
    childrenWordTrue.forEach((v) {
      childrenTrue.add(getItemContainer(v, true));
    });
    setState(() {});
  }

  Widget getItemContainer(String item, bool isSelect) {
    return Material(
      color: Color(0x00000000),
      child: Ink(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Color(0xFFCCCCCC)), borderRadius: BorderRadius.all(Radius.circular(5))),
        child: InkWell(
//          borderRadius: BorderRadius.all(Radius.circular(5)),
          onTap: () {},
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Container(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: Text(
                item,
                style: TextStyle(color: Color(0xFF000000)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
