import 'package:box/widget/ae_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../main.dart';
import 'home_page_v2.dart';

class TokenListPage extends StatefulWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

Future<void> _onRefresh() async {

}
class _TokenListPathState extends State<TokenListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "Token",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
//              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: EasyRefresh(
        header: AEHeader(),
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Container(
             color: Colors.white,
              child: Column(
                children: [

                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 0, left: 15),
                                    child: Row(
                                      children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                                        Container(
                                          width: 36.0,
                                          height: 36.0,
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(30.0),
                                            image: DecorationImage(
                                              image: AssetImage("images/logo.png"),
//                                                        image: AssetImage("images/apple-touch-icon.png"),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 8, right: 18),
                                          child: Text(
                                            "ABC",
                                            style: new TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Text(
                                          HomePageV2.tokenABC == "loading..."
                                              ? "loading..."
                                              : double.parse(HomePageV2.tokenABC) > 1000
                                              ? double.parse(HomePageV2.tokenABC).toStringAsFixed(5)
                                              : double.parse(HomePageV2.tokenABC).toStringAsFixed(5),
//                                      "9999999.00000",
                                          overflow: TextOverflow.ellipsis,

                                          style: TextStyle(fontSize: 24,     color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                        ),
                                        Container(
                                          width: 20,
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

                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 0, left: 15),
                          child: Row(
                            children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                              Container(
                                width: 36.0,
                                height: 36.0,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30.0),
                                  image: DecorationImage(
                                    image: AssetImage("images/tether.png"),
//                                                        image: AssetImage("images/apple-touch-icon.png"),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8, right: 18),
                                child: Text(
                                  "USDT",
                                  style: new TextStyle(
                                    fontSize: 20,
                                    color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
//                                HomePageV2.tokenABC == "loading..."
//                                    ? "loading..."
//                                    : double.parse(HomePageV2.tokenABC) > 1000
//                                    ? double.parse(HomePageV2.tokenABC).toStringAsFixed(5)
//                                    : double.parse(HomePageV2.tokenABC).toStringAsFixed(5),
                                      "9999999999.00",
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(fontSize: 24,     color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                              ),
                              Container(
                                width: 20,
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
          ],
        ),
      ),
    );
  }
}
