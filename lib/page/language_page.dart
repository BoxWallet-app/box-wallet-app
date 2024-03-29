import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF000000),
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).setting_page_item_language,

          style: TextStyle(fontSize: 18,  color: Color(0xFF000000),fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SizedBox(
            child: Container(
          child: Column(
            children: <Widget>[
              buildItem("中文", getLanguageStatus("cn", currentLanguage), () {
                languageClick("cn");
              }),

              buildItem("English", getLanguageStatus("en", currentLanguage), () {
                languageClick("en");
              }),

//              buildItem("Français", getLanguageStatus("fr", currentLanguage), () {
//                languageClick("fr");
//              }),
//              Container(
//                height: 1.0,
//                padding: EdgeInsets.only(left: 15, right: 15),
//                color: Colors.white,
//                child: Container(width: MediaQuery.of(context).size.width - 36, color: Color(0xFFEEEEEE)),
//              ),
//              buildItem("한국어", getLanguageStatus("ko", currentLanguage), () {
//                languageClick("ko");
//              }),
//              Container(
//                height: 1.0,
//                padding: EdgeInsets.only(left: 15, right: 15),
//                color: Colors.white,
//                child: Container(width: MediaQuery.of(context).size.width - 36, color: Color(0xFFEEEEEE)),
//              ),
//              buildItem("にほんご", getLanguageStatus("ja", currentLanguage), () {
//                languageClick("ja");
//              }),
//              Container(
//                height: 1.0,
//                padding: EdgeInsets.only(left: 15, right: 15),
//                color: Colors.white,
//                child: Container(width: MediaQuery.of(context).size.width - 36, color: Color(0xFFEEEEEE)),
//              ),
//              buildItem("Русский", getLanguageStatus("py", currentLanguage), () {
//                languageClick("py");
//              }),
//              Container(
//                height: 1.0,
//                padding: EdgeInsets.only(left: 15, right: 15),
//                color: Colors.white,
//                child: Container(width: MediaQuery.of(context).size.width - 36, color: Color(0xFFEEEEEE)),
//              ),
//              buildItem("Español", getLanguageStatus("es", currentLanguage), () {
//                languageClick("es");
//              }),
//              Container(
//                height: 1.0,
//                padding: EdgeInsets.only(left: 15, right: 15),
//                color: Colors.white,
//                child: Container(width: MediaQuery.of(context).size.width - 36, color: Color(0xFFEEEEEE)),
//              ),
//              buildItem("الأمم المتحدة[العربية", getLanguageStatus("ar", currentLanguage), () {
//                languageClick("ar");
//              }),
//              Container(
//                height: 1.0,
//                color: Colors.white,
//                child: Container(width: MediaQuery.of(context).size.width, color: Color(0xFFEEEEEE)),
//              ),
            ],
          ),
        )),
      ),
    );
  }

  void languageClick(String language) {
    BoxApp.language = language;
    BoxApp.setLanguage(language);
    eventBus.fire(LanguageEvent());
    //通知将第一页背景色变成红色
    setState(() {
      currentLanguage = language;
      BoxApp.language = language;
      S.load(Locale(language, language.toUpperCase()));
    });
  }

  Widget buildItem(String key, bool isSelect, GestureTapCallback tab) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),

      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                        width: 25,
                    height: 25,
                        image: AssetImage(isSelect ? "images/check_box_select.png" : "images/check_box_normal.png"),
                      ),
                      margin: const EdgeInsets.only(left: 30.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
