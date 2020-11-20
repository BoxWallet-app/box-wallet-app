import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/mnemonic_confirm_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class MnemonicCopyPage extends StatefulWidget {

  final String mnemonic;

  const MnemonicCopyPage({Key key, this.mnemonic}) : super(key: key);

  @override
  _MnemonicCopyPagePageState createState() => _MnemonicCopyPagePageState();
}

class _MnemonicCopyPagePageState extends State<MnemonicCopyPage> {
  var mnemonicWord = Map<String, bool>();
  var childrenFalse = List<Widget>();
  var childrenTrue = List<Widget>();
  var childrenWordTrue = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    String mnemonic = "memory pool equip lesson limb naive endorse advice lift result track gravity track gravity";
//    List mnemonicList = mnemonic.split(" ");
    List mnemonicList = widget.mnemonic.split(" ");
    for( var i = 0 ; i < mnemonicList.length; i++ ) {
      mnemonicWord[mnemonicList[i]+"_"+i.toString()] = false;
    }


//    for (String item in mnemonicList) {
//      mnemonicWord[item] = false;
//    }
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
                  S.of(context).mnemonic_copy_title,
                  style: TextStyle(color: Color(0xFF000000), fontSize: 24,fontFamily: "Ubuntu",),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  S.of(context).mnemonic_copy_content,
                  style: TextStyle(color: Color(0xFF000000), fontSize: 14,fontFamily: "Ubuntu",),
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
//                      color: Color(0xFF000000),
                        child: const Icon(
                          Icons.report,
                          size: 50,
                          color: Colors.red,
                        )),
                    Container(
                      width: 10,
                    ),
                    Container(
                      child: Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Color(0xffff0000), fontSize: 14.0),
                            children: <TextSpan>[
                              TextSpan(text: S.of(context).mnemonic_copy_hint1),
                              TextSpan(
                                  text: S.of(context).mnemonic_copy_hint2,
                                  style: TextStyle(color: Color(0xFF000000),fontFamily: "Ubuntu",),
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
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MnemonicConfirmPage(mnemonic:widget.mnemonic)));

                    },
                    child: Text(
                      S.of(context).mnemonic_copy_confrom,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, fontFamily: "Ubuntu", color: Color(0xffffffff)),
                    ),
                    color: Color(0xFFFC2365),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),

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
                item.split("_")[0],
                style: TextStyle(color: Color(0xFF000000),fontFamily: "Ubuntu",),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
