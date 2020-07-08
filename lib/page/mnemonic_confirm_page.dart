import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MnemonicConfirmPage extends StatefulWidget {
  @override
  _AccountRegisterPageState createState() => _AccountRegisterPageState();
}

class _AccountRegisterPageState extends State<MnemonicConfirmPage> {
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
//            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  "请确认助记词",
                  style: TextStyle(color: Color(0xFF000000), fontSize: 24),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  "为了确认您的助记词正确抄写,请按照对应的顺序点击助记词",
                  style: TextStyle(color: Color(0xFF000000), fontSize: 14),
                ),
              ),
              Center(
                child: Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Wrap(
                    spacing: 10, //主轴上子控件的间距
                    runSpacing: 10, //交叉轴上子控件之间的间距
                    children: childrenTrue,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  spacing: 10, //主轴上子控件的间距
                  runSpacing: 10, //交叉轴上子控件之间的间距
                  children: childrenFalse,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: ArgonButton(
                  height: 50,
                  roundLoadingShape: true,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onTap: (startLoading, stopLoading, btnState) {},
                  child: Text(
                    "确 认",
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
                  color: Color(0xFFE71766),
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
        decoration: BoxDecoration(color:Colors.white,border: Border.all(color: Color(0xFFCCCCCC)), borderRadius: BorderRadius.all(Radius.circular(5))),
        child: InkWell(
//          borderRadius: BorderRadius.all(Radius.circular(5)),
          onTap: () {
            if (!isSelect) {
              childrenWordTrue.add(item);
            } else {
              childrenWordTrue.remove(item);
            }
            mnemonicWord[item] = !isSelect;
            updateData();
          },
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
