import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/contract_call_dao.dart';
import 'package:box/dao/contract_decode_dao.dart';
import 'package:box/dao/contract_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/contract_call_model.dart';
import 'package:box/model/contract_decode_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/scan_page.dart';
import 'package:box/page/token_send_two_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
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

import '../main.dart';
import 'aens_my_page.dart';
import 'defi_records_page.dart';

class TokenDefiPage extends StatefulWidget {
  static ContractInfoModel model;

  @override
  _TokenDefiPageState createState() => _TokenDefiPageState();
}

class _TokenDefiPageState extends State<TokenDefiPage> {
  Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isInput = true;

  int day = 1;

  int dayCheckColor = 0x333A66F5;
  int dayTextCheckColor = 0xFF3561ef;
  int dayUnCheckColor = 0xFFF1f1f1;
  int dayTextUnCheckColor = 0xFF666666;

  int errorCount = 0;

  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Subscribe
    KeyboardVisibility.onChange.listen((bool visible) {
      if (visible) {
        isInput = false;
      } else {
        isInput = true;
      }
      setState(() {});
    });
    eventBus.on<DefiEvent>().listen((event) {
      netContractBalance();
    });
    netContractBalance();
    netAccountInfo();
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        print(model.data.balance);
        token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netContractBalance() {
    ContractInfoDao.fetch().then((ContractInfoModel model) {
      EasyLoading.dismiss(animation: true);
      if (model.code == 200) {
        TokenDefiPage.model = model;
        setState(() {});
      } else {}
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
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
                                S.of(context).defi_title,
                                strutStyle: StrutStyle(forceStrutHeight: true, height: 1.5, leading: 1, fontFamily: "Ubuntu"),
                                style: new TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.white),
                              ),
                            ),
                            buildContainerCount(context),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 9, left: 18, right: 20),
                              //边框设置
//                              height: MediaQuery.of(context).size.height,
                              decoration: new BoxDecoration(
                                  color: Color(0xFFFFFFFF),
//                                  color: Color(0xE6FFFFFF),
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
                                            S.of(context).defi_card_time,
                                            style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, fontFamily: "Ubuntu", color: Color(0xFF000000)),
                                          ),
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(left: 18, top: 32),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 18, right: 18, top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                                  onTap: () {
                                                    setState(() {
                                                      day = 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                        color: Color(day == 1 ? dayCheckColor : dayUnCheckColor),
                                                        //设置四周圆角 角度
                                                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                        boxShadow: []),
                                                    width: MediaQuery.of(context).size.width / 5.5,
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "1",
                                                            style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 1 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          margin: EdgeInsets.only(top: 17),
                                                          child: Text(
                                                            S.of(context).defi_card_time_day,
                                                            style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 1 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                                  onTap: () {
                                                    setState(() {
                                                      day = 7;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                        color: Color(day == 7 ? dayCheckColor : dayUnCheckColor),
                                                        //设置四周圆角 角度
                                                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                        boxShadow: []),
                                                    width: MediaQuery.of(context).size.width / 5.5,
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "7",
                                                            style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 7 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          margin: EdgeInsets.only(top: 17),
                                                          child: Text(
                                                            S.of(context).defi_card_time_day,
                                                            style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 7 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                                  onTap: () {
                                                    setState(() {
                                                      day = 30;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                        color: Color(day == 30 ? dayCheckColor : dayUnCheckColor),
                                                        //设置四周圆角 角度
                                                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                        boxShadow: []),
                                                    width: MediaQuery.of(context).size.width / 5.5,
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "30",
                                                            style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 30 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          margin: EdgeInsets.only(top: 17),
                                                          child: Text(
                                                            S.of(context).defi_card_time_day,
                                                            style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 30 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                                  onTap: () {
                                                    setState(() {
                                                      day = 90;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                        color: Color(day == 90 ? dayCheckColor : dayUnCheckColor),
                                                        //设置四周圆角 角度
                                                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                                        boxShadow: []),
                                                    width: MediaQuery.of(context).size.width / 5.5,
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "90",
                                                            style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 90 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          margin: EdgeInsets.only(top: 17),
                                                          child: Text(
                                                            S.of(context).defi_card_time_day,
                                                            style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(day == 90 ? dayTextCheckColor : dayTextUnCheckColor)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            S.of(context).defi_card_count,
                                            style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, fontFamily: "Ubuntu", color: Color(0xFF000000)),
                                          ),
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(left: 18, top: 25),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(left: 18, right: 18, top: 10),
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                            decoration: BoxDecoration(color: Color(0xFFEEEEEE), border: Border.all(color: Color(0xFFEEEEEE)), borderRadius: BorderRadius.all(Radius.circular(15))),
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
                                                S.of(context).defi_card_balance,
                                                style: new TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Text(
                                                token,
                                                style: new TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
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
                                            width: 260,
                                            onTap: (startLoading, stopLoading, btnState) {
                                              netLock();
                                            },
                                            child: Text(
                                              S.of(context).defi_card_mine,
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
                                              S.of(context).defi_card_hint,
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
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
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
                                                            S.of(context).defi_card_hint_base,
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                          child: Text(
                                                            S.of(context).defi_card_hint_base_content,
                                                            strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                            style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: "Ubuntu", height: 1.5),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 15, right: 18),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            S.of(context).defi_card_hint_day,
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DataTable(columns: [
                                                              DataColumn(label: Text(S.of(context).defi_card_hint_day_content1)),
                                                              DataColumn(label: Text(S.of(context).defi_card_hint_day_content2)),
                                                              DataColumn(label: Text(S.of(context).defi_card_hint_day_content3)),
                                                            ], rows: [
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('1')), DataCell(Text('1'))]),
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('7')), DataCell(Text('1.2'))]),
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('30')), DataCell(Text('1.5'))]),
                                                              DataRow(cells: [DataCell(Text('1000')), DataCell(Text('90')), DataCell(Text('2'))])
                                                            ])),

                                                        Container(
                                                          child: Text(
                                                            S.of(context).defi_card_hint_mine,
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                            padding: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DataTable(columns: [
                                                              DataColumn(
                                                                  label: Text(
                                                                S.of(context).defi_card_hint_mine_content1,
                                                              )),
                                                              DataColumn(
                                                                  label: Text(
                                                                S.of(context).defi_card_hint_mine_content2,
                                                              )),
                                                            ], rows: [
                                                              DataRow(cells: [
                                                                DataCell(Text('0-1m')),
                                                                DataCell(Text('1.8')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('1m-5m')),
                                                                DataCell(Text('1.5')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('5m-10m')),
                                                                DataCell(Text('1.3')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('10m-20m')),
                                                                DataCell(Text('1')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('20m-25m')),
                                                                DataCell(Text('0.8')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('25m-30m')),
                                                                DataCell(Text('0.5')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('>30m')),
                                                                DataCell(Text('0.3')),
                                                              ])
                                                            ])),
                                                        Container(
                                                          child: Text(
                                                            S.of(context).defi_card_hint_out,
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                            padding: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: DataTable(columns: [
                                                              DataColumn(
                                                                  label: Text(
                                                                S.of(context).defi_card_hint_out_content1,
                                                              )),
                                                              DataColumn(
                                                                  label: Text(
                                                                S.of(context).defi_card_hint_out_content2,
                                                              )),
                                                            ], rows: [
                                                              DataRow(cells: [
                                                                DataCell(Text('0-10m')),
                                                                DataCell(Text('2')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('10m-100m')),
                                                                DataCell(Text('1.5')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('100m-200m')),
                                                                DataCell(Text('1')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('200m-300m')),
                                                                DataCell(Text('0.7')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('300m-400m')),
                                                                DataCell(Text('0.3')),
                                                              ]),
                                                              DataRow(cells: [
                                                                DataCell(Text('400m-500m')),
                                                                DataCell(Text('0.1')),
                                                              ]),
                                                            ])),
                                                        Container(
                                                          child: Text(
                                                            S.of(context).defi_card_hint_info,
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                          margin: EdgeInsets.only(left: 18, top: 10),
                                                        ),

                                                        Container(
                                                          child: Text(
                                                            S.of(context).defi_card_hint_info_content,
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
                              height: 50,
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
                            child: MaterialButton(
                              minWidth: 10,
                              child: new Text(
                                S.of(context).defi_title_record,
                                style: new TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.white),
                              ),
                              onPressed: () {
                                if ("ak_2g2yq6RniwW1cjKRu4HdVVQXa5GQZkBaXiaVogQXnRxUKpmhS\",270824000000000000000],	[\"ak_3i4bwAbXBRHBqTDYFVLUSa8byQUeBAFzEgjfYk6rSyjWEXL3i\",259200000000000000000],	[\"ak_9XhfcrCtEyPFWPM3GVPC2BCFqetcYV3fDv3EjPpVdR9juAofA\",129600000000000000000],	[\"ak_ELsVMRbBe4LWEuqNU1pn2UCNpnNfdpHjRJjDFjT4R4yzRTeXt\",1390979520000000015854],	[\"ak_Evidt2ZUPzYYPWhestzpGsJ8uWzB1NgMpEvHHin7GCfgWLpjv\",499977516107119999999972654],	[\"ak_GUpbJyXiKTZB1zRM8Z8r2xFq26sKcNNtz6i83fvPUpKgEAgjH\",0],	[\"ak_QyFYYpgJ1vUGk1Lnk8d79WJEVcAtcfuNHqquuP2ADfxsL6yKx\",321088000000000000000],	[\"ak_V9SApNmgDGNLQcZWTzYb3PKtmFuwRn8ENdAg7WjZUdiwgkyUP\",84384000000000000000],	[\"ak_XtJGJrJuvxduT1HFMye4PuEkfUnU9L5rUE5CQ2F9MkqYQVr3f\",648000000000000000000],	[\"ak_fGPGYbqkEyWMV8R4tvQZznpzt28jb54EinF84TRSVCi997kiJ\",2448000000000000000],	[\"ak_o27hkgCTN2WZBkHd4vPcbfJPM2tzddv8xy1yaQnoyFEvqpZQK\",3596400000000000000],	[\"ak_tM5FE5HZSxUvDNAcBKMpSM9iXdsLviJ6tXffiH3BNpFrvgRoR\",383304960000000000000],	[\"ak_22HBW4s8HoCSa6ZKkd7CtFhs7vdBQ5Sgahi7FbRhp7xQ429WG2\",301216320000000007927],	[\"ak_25rsqRgVpcaD3fSZxCQVcyi4VNK3CTqf8CbzsnGtHCeu3ivrM1\",842670000000000000000],	[\"ak_281fyU5kV5yG6ZEgV9nnprLxRznSUKzxmgn2ZnxBhfD8ryWcuk\",128952000000000000000],	[\"ak_28LuZ8CG4LF6LvL47seA2GuCtaNEdXKiVMZP46ykYW8bEcuoVg\",13219200000000000000000],	[\"ak_294D9LQa95ckuJi5z7Who4TzKZWwEGimsyv1ZKM7osPE9c8Bx7\",521424000000000000000],	[\"ak_2JJNMYcnqPaABiSY5omockmv4cCoZefv4XzStAxKe9gM2xYz2r\",582912000000000000000],	[\"ak_2MHJv6JcdcfpNvu4wRDZXWzq8QSxGbhUfhMLR7vUPzRFYsDFw6\",977560560000000001188],	[\"ak_2UCUD59aWZyyhZzZbUdxoyP94r3mz9GvkH49HzJjsfC8MYqVPn\",81000000000000000000],	[\"ak_2Xu6d6W4UJBWyvBVJQRHASbQHQ1vjBA7d1XUeY8SwwgzssZVHK\",1955121120000000002377],	[\"ak_2gEL91xaQwvdN7psiCcGpSwcEMctTX1CVMT2g8f6NEp48tkvAr\",133164000000000000000],	[\"ak_2j2iyGwDnmiDZC9Dc2T8W371MYD9CQxDGSZ2Ne7WT2thY6q888\",213984000000000000000],	[\"ak_2mhBmzVv82SvtKATNBxfD1JhbLBrRNZZmah3QMqRkcK1SP3Bka\",33264000000000000000]"
                                    .contains(HomePage.address)) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DefiRecordsPage(isShowTitle: true)));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DefiRecordsPage(isShowTitle: false)));
                                }

//                                Navigator.push(context, MaterialPageRoute(builder: (context) => DefiSwitchRecordPage()));
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
    if (!isInput) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 155,
      margin: const EdgeInsets.only(top: 38, left: 18, right: 18),
      //边框设置
//                              height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
          color: Color(0xFFFFFFFF),
//          color: Color(0xE6FFFFFF),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: []),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 155,
            margin: const EdgeInsets.all(0),
            //边框设置
            decoration: new BoxDecoration(
//                                      color: Color(0xFFEEEEEE),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(0.0)),

              //设置四周边框
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    S.of(context).defi_head_card_all_token,
                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18),
                ),
                Container(
                  child: Text(
                    TokenDefiPage.model == null ? "loading..." : TokenDefiPage.model.data.contractBalance,
                    style: new TextStyle(fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: 1.5, fontFamily: "Ubuntu", color: Colors.black),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18, top: 5),
                ),
                Container(
                  child: Text(
                    S.of(context).defi_head_card_my_token,
                    style: new TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Ubuntu", color: Color(0xFF666666)),
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 18, top: 10),
                ),
                Container(
                  child: Text(
                    TokenDefiPage.model == null ? "loading..." : TokenDefiPage.model.data.myBalance,
                    style: new TextStyle(fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: 1.5, fontFamily: "Ubuntu", color: Color(0xff3460ee)),
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

  void netContractTx(String tx, String function) {
    errorCount++;

    EasyLoading.show();
    Future.delayed(Duration(seconds: 3), () {
      ContractDecodeDao.fetch(tx, function).then((ContractDecodeModel model) {
        if (model.code == 200) {
          EasyLoading.dismiss(animation: true);
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text(
                S.of(context).dialog_hint,
              ),
              content: Text(S.of(context).dialog_defi_lock_sucess),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    S.of(context).dialog_conform,
                    style: TextStyle(color: Color(0xFFFC2365)),
                  ),
                  onPressed: () {
                    EasyLoading.show();
                    netContractBalance();
                    netAccountInfo();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          if (model.code == -1 && errorCount < 3) {
            netContractTx(tx, function);
            return;
          }
          EasyLoading.dismiss(animation: true);
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text(
                S.of(context).dialog_hint,
              ),
              content: Text(model.msg),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    S.of(context).dialog_conform,
                    style: TextStyle(color: Color(0xFFFC2365)),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        }
      }).catchError((e) {
        EasyLoading.dismiss(animation: true);
        Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      });
    });
  }

  void netLock() {
    var text = _textEditingController.text;
    var doubleInput = double.parse(text);
    if (1 > doubleInput) {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text(
            S.of(context).dialog_hint,
          ),
          content: Text("质押最低需要100 AE"),
          actions: <Widget>[
            BasicDialogAction(
              title: Text(
                S.of(context).dialog_conform,
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
    }
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: anim1.value,
                // ignore: missing_return
                child: PayPasswordWidget(
                    title: S.of(context).password_widget_input_password,
                    color: 0xff3460ee,
                    dismissCallBackFuture: (String password) {
                      return;
                    },
                    passwordCallBackFuture: (String password) async {
                      var signingKey = await BoxApp.getSigningKey();
                      var address = await BoxApp.getAddress();
                      final key = Utils.generateMd5Int(password + address);
                      var aesDecode = Utils.aesDecode(signingKey, key);

                      if (aesDecode == "") {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => BasicDialogAlert(
                            title: Text(
                              S.of(context).dialog_hint_check_error,
                            ),
                            content: Text(
                              S.of(context).dialog_hint_check_error_content,
                            ),
                            actions: <Widget>[
                              BasicDialogAction(
                                title: Text(
                                  S.of(context).dialog_conform,
                                  style: TextStyle(
                                    color: Color(0xFFFC2365),
                                    fontFamily: "Ubuntu",
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      EasyLoading.show();
                      ContractCallDao.fetch("lock", day.toString(), aesDecode, _textEditingController.text).then((ContractCallModel model) {
                        if (model.code == 200) {
                          errorCount = 0;
                          netContractTx(model.data.tx, model.data.function);
//                          showPlatformDialog(
//                            context: context,
//                            builder: (_) => BasicDialogAlert(
//                              title: Text(
//                                S.of(context).dialog_hint,
//                              ),
//                              content: Text(model.data.tx + "\n" + model.data.function),
//                              actions: <Widget>[
//                                BasicDialogAction(
//                                  title: Text(
//                                    S.of(context).dialog_conform,
//                                    style: TextStyle(color: Color(0xFFFC2365)),
//                                  ),
//                                  onPressed: () {
//                                    Navigator.of(context, rootNavigator: true).pop();
//                                  },
//                                ),
//                              ],
//                            ),
//                          );
                        } else {
                          EasyLoading.dismiss(animation: true);
                          showPlatformDialog(
                            context: context,
                            builder: (_) => BasicDialogAlert(
                              title: Text(
                                S.of(context).dialog_hint,
                              ),
                              content: Text(model.msg),
                              actions: <Widget>[
                                BasicDialogAction(
                                  title: Text(
                                    S.of(context).dialog_conform,
                                    style: TextStyle(color: Color(0xFFFC2365)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }).catchError((e) {
                        EasyLoading.dismiss(animation: true);
                        Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                      });
                    }),
              ));
        });
  }
}
