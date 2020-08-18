import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MnemonicConfirmPage extends StatefulWidget {
  final String mnemonic;

  const MnemonicConfirmPage({Key key, this.mnemonic}) : super(key: key);

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

    List mnemonicList = widget.mnemonic.split(" ");
    mnemonicList.shuffle();
//    mnemonicList.sort((left,right)=>left.compareTo(right));
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
                  onTap: (startLoading, stopLoading, btnState) {

                    print(childrenWordTrue.toString());
                    print(widget.mnemonic.split(" ").toString());
                    if(childrenWordTrue.toString() == widget.mnemonic.split(" ").toString()){
                      print("111");


                      showPlatformDialog(
                        context: context,
                        builder: (_) => BasicDialogAlert(
                          title: Text("备份成功"),
                          content: Text("您已经成功备份助记词,请妥善保管,我们为了您的账号更加安全,将本地助记词进行删除."),
                          actions: <Widget>[
                            BasicDialogAction(
                              title: Text(
                                "确定",
                                style: TextStyle(color: Color(0xFFFC2365)),
                              ),
                              onPressed: () {
                                BoxApp.setMnemonic("");
                                Navigator.of(context, rootNavigator: true).pop();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/home", ModalRoute.withName("/home"));
                              },
                            ),
                          ],
                        ),
                      );
                      return;

                    }
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text("备份失败"),
                        content: Text("请按照正常顺序输入助记词."),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              "确定",
                              style: TextStyle(color: Color(0xFFFC2365)),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    return;
//                    testList6.forEach((item) => print(item));
//                    String s = JsonEncoder().convert(childrenWordTrue);
//                    print(s);

                  },
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
