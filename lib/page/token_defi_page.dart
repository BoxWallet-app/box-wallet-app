import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/token_send_two_page.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import 'aens_my_page.dart';

class TokenDefiPage extends StatefulWidget {
  @override
  _TokenDefiPageState createState() => _TokenDefiPageState();
}

class _TokenDefiPageState extends State<TokenDefiPage> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  double amount_value = 0.0;
  double day_value = 0.0;
  bool isShoe = true;
  double value_height = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Subscribe
    KeyboardVisibility.onChange.listen((bool visible) {
      print(visible);
      print(MediaQuery.of(context).viewInsets.bottom);
      if (visible) {
        isShoe = false;
      } else {
        isShoe = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          resizeToAvoidBottomPadding: false, //输入框抵住键盘
          backgroundColor: Color(0xFFeeeeee),
          body: Container(
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            image: AssetImage('images/defi_bg.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 18, top: 120, right: 18),
                              child: Text(
                                "Lock AE Involved \nEarn AMB",
                                strutStyle: StrutStyle(forceStrutHeight: true, height: 1.5, leading: 1, fontFamily: "Ubuntu"),
                                style: new TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.white),
                              ),
                            ),
                            buildContainerCount(context),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 10, left: 18, right: 20),
                              //边框设置
//                              height: MediaQuery.of(context).size.height,
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: []),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.all(0),
                                    //边框设置
                                    decoration: new BoxDecoration(
//                                      color: Color(0xFFEEEEEE),
                                      //设置四周圆角 角度
                                      borderRadius: BorderRadius.all(Radius.circular(0.0)),

                                      //设置四周边框
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Please select the pledge time",
                                            style: new TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF000000)),
                                          ),
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(left: 18, top: 25),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 5, right: 5, top: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                decoration: new BoxDecoration(
                                                    color: Color(0xFF3a66f5).withAlpha(80),
                                                    //设置四周圆角 角度
                                                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                    boxShadow: []),
                                                width: 70,
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "1",
                                                        style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Color(0xFF3561ef)),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(top: 17),
                                                      child: Text(
                                                        "day",
                                                        style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF3561ef)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: new BoxDecoration(
                                                    color: Color(0xFFF1f1f1),
                                                    //设置四周圆角 角度
                                                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                    boxShadow: []),
                                                width: 70,
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "7",
                                                        style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(top: 17),
                                                      child: Text(
                                                        "day",
                                                        style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: new BoxDecoration(
                                                    color: Color(0xFFF1f1f1),
                                                    //设置四周圆角 角度
                                                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                    boxShadow: []),
                                                width: 70,
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "30",
                                                        style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(top: 17),
                                                      child: Text(
                                                        "day",
                                                        style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: new BoxDecoration(
                                                    color: Color(0xFFF1f1f1),
                                                    //设置四周圆角 角度
                                                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                    boxShadow: []),
                                                width: 70,
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "90",
                                                        style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(top: 17),
                                                      child: Text(
                                                        "day",
                                                        style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "Please select the count",
                                            style: new TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF000000)),
                                          ),
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(left: 18, top: 25),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 55,
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                            decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(5))),
                                            child: TextField(
                                              controller: _textEditingController,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
                                              ],
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,

                                              decoration: InputDecoration(
                                                hintText: '',
                                                enabledBorder: new UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0x00000000)),
                                                ),
// and:
                                                focusedBorder: new UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0x00000000)),
                                                ),
                                                hintStyle: TextStyle(
                                                  fontSize: 19,
                                                  color: Colors.black.withAlpha(80),
                                                ),
                                              ),
                                              cursorColor: Color(0xFFFC2365),
                                              cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Balance (ae) :",
                                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Text(
                                                " 772.99231",
                                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(left: 18, top: 5, right: 18),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 30, bottom: 10),
                                          child: ArgonButton(
                                            height: 50,
                                            roundLoadingShape: true,
                                            width: 310,
                                            onTap: (startLoading, stopLoading, btnState) {},
                                            child: Text(
                                              "Mine",
                                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Colors.white),
                                            ),
                                            loader: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SpinKitRing(
                                                lineWidth: 4,
                                                color: Color(0xFF0072FF),
                                                // size: loaderWidth ,
                                              ),
                                            ),
                                            borderRadius: 30.0,
                                            color: Color(0xFF0072FF),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 0, bottom: 20),
                                          child: MaterialButton(
                                            child: Text(
                                              "Mine The rules",
                                              style: new TextStyle(fontSize: 14, color: Color(0xFF666666), fontFamily: "Ubuntu"),
                                            ),
                                            height: 50,
                                            minWidth: 120,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                                            onPressed: () {
                                              showMaterialModalBottomSheet(
                                                context: context,
                                                backgroundColor: Color(0xFFFFFFFF).withAlpha(0),
                                                builder: (context, scrollController) => Container(
                                                  height: 600,
                                                  decoration: new BoxDecoration(
                                                      color: Color(0xFFFFFFFF),
                                                      //设置四周圆角 角度
                                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                      boxShadow: []),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 30,
                                                        ),
//
//                        Container(
//                          child: Text(
//                            "全称 : AE MONEY BOX\n总量 : 5亿\n团队 :  2%  锁仓 \n运营 :  5%  锁仓\n寓意 : AE 的资金盒子\n中文名 : 按摩棒\n初衷 : 用于刺激AE 价格实现锁仓收益, 产生的代币 , 不割韭菜不",
//                            strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
//                            style: TextStyle(fontSize: 14, letterSpacing: 1.0, color: Colors.black.withAlpha(200), fontFamily: "Ubuntu", height: 1.5),
//                          ),
//                          alignment: Alignment.topLeft,
//                          margin: EdgeInsets.only(left: 18, top: 5,right: 18),
//                        ),
                                                        Container(
                                                          child: Text(
                                                            "Basic introduction:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                          child: Text(
                                                            "AMB is a pledge mining based on the EXTENSION of AEX9 protocol of AE block chain. The whole process is open and transparent, and users can exchange AMB through pledge AE, the unique pass of AMB user Box AEPP ecology. The value of AMB is strongly correlated with the amount of pledged AE. Proceeds from pledge rules, all AMB tokens will be issued in a lump sum after pledge",
                                                            strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                            style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: "Ubuntu", height: 1.5),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 15, right: 18),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            "周期-倍数:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DataTable(columns: [
                                                              DataColumn(label: Text('数量(AE)')),
                                                              DataColumn(label: Text('周期(天)')),
                                                              DataColumn(label: Text('日收益(AMB)')),
                                                            ], rows: [
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('1')), DataCell(Text('1'))]),
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('7')), DataCell(Text('1.2'))]),
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('30')), DataCell(Text('1.5'))]),
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('90')), DataCell(Text('2'))])
                                                            ])),

                                                        Container(
                                                          child: Text(
                                                            "质押总数-倍数:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                            padding: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DataTable(columns: [
                                                              DataColumn(label: Text('挖矿产出数量(AE)')),
                                                              DataColumn(label: Text('倍数')),
                                                            ], rows: [
                                                              DataRow(cells: [
                                                                DataCell(Text('0-100w')),
                                                                DataCell(Text('1.8')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('100w-500w')),
                                                                DataCell(Text('1.5')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('500w-1000w')),
                                                                DataCell(Text('1.3')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('1000w-2000w')),
                                                                DataCell(Text('1')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('2000w-2500w')),
                                                                DataCell(Text('0.8')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('2500w-3000w')),
                                                                DataCell(Text('0.5')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('>3000w')),
                                                                DataCell(Text('0.3')),
                                                              ])
                                                            ])),
                                                        Container(
                                                          child: Text(
                                                            "挖矿产出-倍数:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                            padding: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DataTable(columns: [
                                                              DataColumn(label: Text('质押总数量(AE)')),
                                                              DataColumn(label: Text('倍数')),
                                                            ], rows: [
                                                              DataRow(cells: [
                                                                DataCell(Text('0-1000w')),
                                                                DataCell(Text('2')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('1000w-1亿')),
                                                                DataCell(Text('1.5')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('1-2亿')),
                                                                DataCell(Text('1')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('2-3亿')),
                                                                DataCell(Text('0.7')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('3-4亿')),
                                                                DataCell(Text('0.3')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('4-5亿')),
                                                                DataCell(Text('0.1')),
                                                              ]),
                                                            ])),
                                                        Container(
                                                          child: Text(
                                                            "发放算法:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                          child: Text(
                                                            "(质押数量 *周期  * 周期日收益 * 质押倍数 * 挖矿倍数) / 1000 = 收益\n举例前期创世挖矿收益\n(1000ae * 30(天) * 1.5(周期倍数) * 1.8(质押倍数) * 2(日收益倍数)) / 1000 ≈ 162个AMB",
                                                            strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                            style: TextStyle(fontSize: 14, letterSpacing: 1.0, color: Colors.black.withAlpha(200), fontFamily: "Ubuntu", height: 1.5),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 15, right: 18),
                                                        ),
                                                        Container(
                                                          height: MediaQueryData.fromWindow(window).padding.bottom,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );

//                      Navigator.pushReplacementNamed(context, "home");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: value_height,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQueryData.fromWindow(window).padding.top,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                onTap: () {},
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            width: 55,
                            height: 55,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Container(
                            width: 100,
                            child: MaterialButton(
                              minWidth: 10,
                              child: new Text(
                                "Record",
                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AensMyPage()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Container buildContainerCount(BuildContext context) {
    if (!isShoe) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 155,
      margin: const EdgeInsets.only(top: 10, left: 18, right: 18),
      //边框设置
//                              height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
          color: Color(0xE6FFFFFF),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: []),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(0),
            //边框设置
            decoration: new BoxDecoration(
//                                      color: Color(0xFFEEEEEE),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(0.0)),

              //设置四周边框
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    "Always lock (ae)",
                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18, top: 20),
                ),
                Container(
                  child: Text(
                    "13,013,011.008130",
                    style: new TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18, top: 5),
                ),
                Container(
                  child: Text(
                    "Been locked (ae)",
                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18, top: 10),
                ),
                Container(
                  child: Text(
                    "13,011.12313",
                    style: new TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Color(0xff3460ee)),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18, top: 5),
                ),
//                                        Container(
//                                          child: Text(
//                                            "Been locked (ae)",
//                                            style: new TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black.withAlpha(150)),
//                                          ),
//                                          alignment: Alignment.topLeft,
//                                          margin: EdgeInsets.only(left: 18, top: 20),
//                                        ),
//                                        Container(
//                                          child: Text(
//                                            "10,000.000",
//                                            style: new TextStyle(fontSize: 35, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Colors.black),
//                                          ),
//                                          alignment: Alignment.topLeft,
//                                          margin: EdgeInsets.only(left: 18, top: 5),
//                                        )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getDayString() {
    if (day_value == 0) {
      return "One day";
    }
    if (day_value == 30) {
      return "A week";
    }
    if (day_value == 60) {
      return "A month";
    }
    if (day_value == 90) {
      return "Three months";
    }
    return "One da";
  }
}
