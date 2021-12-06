import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/mnemonic_confirm_page.dart';
import 'package:box/widget/custom_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

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

//    String mnemonic = " track gravity";
//    List mnemonicList = mnemonic.split(" ");

    List mnemonicList = widget.mnemonic.split(" ");
    for( var i = 0 ; i < mnemonicList.length; i++ ) {
      mnemonicWord[mnemonicList[i]+"_"+i.toString()] = false;
    }

//    for (String item in mnemonicList) {
//      mnemonicWord[item] = false;
//    }
    WidgetsBinding.instance.addPostFrameCallback((_){
      updateData();
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "备份助记词",
            style: TextStyle(color: Color(0xFF000000), fontSize: 18,fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
          ),
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(

          child: Container(
            child: Column(
              children: <Widget>[

                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(
                    S.of(context).mnemonic_copy_content,
                    style:TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(180),
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  ),
                ),


                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(color: Color(0xFFedf3f7), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(15))),
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
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(
                    "注意\n"
                        "· 请勿将助记词透漏给任何人\n"
                        "· 助记词一旦丢失，资产将无法恢复\n"
                        "· 请勿通过任何截屏，网络传输的方式进行备份\n"
                        "· 遇到任何情况，请不要轻易卸载钱包APP",
                    style:TextStyle(
                      fontSize: 14,
                      color: Colors.red,
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
                        if (Platform.isIOS) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>MnemonicConfirmPage(mnemonic:widget.mnemonic)));
                        } else {
                          Navigator.push(context, SlideRoute( MnemonicConfirmPage(mnemonic:widget.mnemonic)));
                        }


                      },
                      child: Text(
                        S.of(context).mnemonic_copy_confrom,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xffffffff)),
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
    return Container(
      width: MediaQuery.of(context).size.width/3-26,
      child: Material(
        color: Color(0x00000000),
        child: Ink(
          decoration: BoxDecoration(color: Color(0xFFFFFFFF),  border: Border.all(color: Color(0xFFCCCCCC)),borderRadius: BorderRadius.all(Radius.circular(10)),),
          child: InkWell(
         // borderRadius: BorderRadius.all(Radius.circular(15)),
            onTap: () {},
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: Text(
                  item.split("_")[0],
                  style: TextStyle(color: Color(0xFF000000),fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
