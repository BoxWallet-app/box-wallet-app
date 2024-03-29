import 'package:box/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../main.dart';
import 'create_mnemonic_confirm_page.dart';

// ignore: must_be_immutable
class CreateMnemonicCopyPage extends StatefulWidget {
  static final int login = 0;
  static final int add = 1;
  final String? mnemonic;
  final int? type;

  const CreateMnemonicCopyPage({Key? key, this.mnemonic, this.type}) : super(key: key);

  @override
  _MnemonicCopyPagePageState createState() => _MnemonicCopyPagePageState();
}

class _MnemonicCopyPagePageState extends State<CreateMnemonicCopyPage> {
  var mnemonicWord = Map<String?, bool>();
  var childrenFalse = <Widget>[];
  var childrenTrue = <Widget>[];
  var childrenWordTrue = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List mnemonicList = widget.mnemonic!.split(" ");
    for (var i = 0; i < mnemonicList.length; i++) {
      mnemonicWord[mnemonicList[i] + "_" + i.toString()] = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFfafbfc),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFfafbfc),
          elevation: 0,
          title: Text(
            S.of(context).CreateMnemonicCopyPage_title,
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 18,
              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
            ),
          ),
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
                    child: Text(
                      S.of(context).mnemonic_copy_content,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withAlpha(180),
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(color: Color(0xFFedf3f7), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Wrap(
                        spacing: 10, //主轴上子控件的间距
                        runSpacing: 10, //交叉轴上子控件之间的间距
                        children: childrenFalse,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 10),
                    child: Text(
                      S.of(context).CreateMnemonicCopyPage_tips,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 30,left: 30,right: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width ,
                      child: TextButton(
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                        onPressed: () {
                          if (widget.type == CreateMnemonicCopyPage.login) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMnemonicConfirmPage(mnemonic: widget.mnemonic, type: CreateMnemonicCopyPage.login)));
                          } else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateMnemonicConfirmPage(mnemonic: widget.mnemonic, type: CreateMnemonicCopyPage.add)));
                          }
                        },
                        child: Text(
                          S.of(context).mnemonic_copy_confrom,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  updateData() {
    childrenFalse.clear();
    mnemonicWord.forEach((k, v) {
      if (!v) childrenFalse.add(getItemContainer(k!, false));
    });

    childrenTrue.clear();
    childrenWordTrue.forEach((v) {
      childrenTrue.add(getItemContainer(v, true));
    });
    setState(() {});
  }

  Widget getItemContainer(String item, bool isSelect) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 26,
      child: Material(
        color: Color(0x00000000),
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            border: Border.all(color: Color(0xFFCCCCCC)),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: Text(
                  item.split("_")[0],
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
