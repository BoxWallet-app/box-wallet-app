import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String currentLanguage = "en";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BoxApp.getLanguage().then((String value) {

      setState(() {
        currentLanguage = value;
      });
    });
  }

  bool getLanguageStatus(String language, String currentLanguage) {
    if (language == currentLanguage) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).title,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SizedBox(
            child: Container(
          child: Column(
            children: <Widget>[
              buildItem("中文", getLanguageStatus("cn", currentLanguage), () {
                BoxApp.setLanguage("cn");
                setState(() {
                  currentLanguage = "cn";
                  S.load(Locale('cn', 'CN'));
                });
              }),
              Container(
                height: 1.0,
                padding: EdgeInsets.only(left: 18, right: 18),
                color: Colors.white,
                child: Container(width: MediaQuery.of(context).size.width - 36, color: Color(0xFFEEEEEE)),
              ),
              buildItem("英文", getLanguageStatus("en", currentLanguage), () {
                BoxApp.setLanguage("en");
                setState(() {
                  currentLanguage = "en";
                  S.load(Locale('en', 'US'));
                });
              }),
              Container(
                height: 1.0,
                color: Colors.white,
                child: Container(width: MediaQuery.of(context).size.width, color: Color(0xFFEEEEEE)),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Material buildItem(String key, bool isSelect, GestureTapCallback tab) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          padding: const EdgeInsets.only(left: 18, right: 21, top: 20, bottom: 20),
          child: Row(
            children: [
              /*1*/
              Column(
                children: [
                  /*2*/
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              /*3*/
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image(
                    width: 20,
                    height: 20,
                    image: AssetImage(isSelect ? "images/check_box_select.png" : "images/check_box_normal.png"),
                  ),
                  margin: const EdgeInsets.only(left: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
