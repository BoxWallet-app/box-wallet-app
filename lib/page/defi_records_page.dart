import 'dart:async';
import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_page_dao.dart';
import 'package:box/dao/contract_call_dao.dart';
import 'package:box/dao/contract_decode_dao.dart';
import 'package:box/dao/contract_record_dao.dart';
import 'package:box/dao/tx_broadcast_dao.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aens_page_model.dart';
import 'package:box/model/contract_call_model.dart';
import 'package:box/model/contract_decode_model.dart';
import 'package:box/model/contract_record_model.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/aens_detail_page.dart';
import 'package:box/page/tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../main.dart';
import 'defi_records_old_page.dart';
import 'home_page.dart';

class DefiRecordsPage extends StatefulWidget {
  final bool isShowTitle;

  const DefiRecordsPage({Key key, this.isShowTitle = true}) : super(key: key);

  @override
  _DefiRecordsPageState createState() => _DefiRecordsPageState();
}

class _DefiRecordsPageState extends State<DefiRecordsPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  ContractRecordModel contractRecordModel;
  int page = 1;
  var address = '';
  int dayCheckColor = 0x333A66F5;
  int dayTextCheckColor = 0xFF3561ef;
  int dayUnCheckColor = 0xFFF1f1f1;
  int dayTextUnCheckColor = 0xFF666666;
  int day = 1;
  int errorCount = 0;

  @override
  Future<void> initState() {
    super.initState();
    getAddress();
  }

  void netContractTx(String tx, String function) {
    errorCount++;
    if (errorCount > 5) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "th error", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      errorCount = 0;
      return;
    }
    EasyLoading.show();
    Future.delayed(Duration(seconds: 2), () {
      ContractDecodeDao.fetch(tx, function).then((ContractDecodeModel model) {
        if (model.code == 200) {
          errorCount = 0;
          EasyLoading.dismiss(animation: true);
          showPlatformDialog(
            context: context,
            builder: (_) => BasicDialogAlert(
              title: Text(
                S.of(context).dialog_hint,
              ),
              content: Text(function == "unlock" ? S.of(context).dialog_defi_unlock_sucess : S.of(context).dialog_defi_continue_sucess),
              actions: <Widget>[
                BasicDialogAction(
                  title: Text(
                    S.of(context).dialog_conform,
                    style: TextStyle(color: Color(0xFFFC2365), fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
                  ),
                  onPressed: () {
                    EasyLoading.show();
                    eventBus.fire(DefiEvent());
                    netData();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          if (model.code == -1 && errorCount < 5) {
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
                    style: TextStyle(color: Color(0xFFFC2365), fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
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


  void netUnLockV2(int index) {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              // ignore: missing_return
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
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
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(S.of(context).dialog_hint_check_error_content),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
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
                  // ignore: missing_return
                  BoxApp.contractDefiUnLockV1((tx) {
                    // ignore: missing_return
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(
                          S.of(context).dialog_hint,
                        ),
                        content: Text( S.of(context).dialog_defi_unlock_sucess),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
                            ),
                            onPressed: () {
                              EasyLoading.show();
                              eventBus.fire(DefiEvent());
                              netData();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );

                  }, (error) {
                    print(error);
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(color: Color(0xFFFC2365), fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );
                    // ignore: missing_return
                  }, aesDecode, address,BoxApp.DEFI_CONTRACT_V1_FIX ,contractRecordModel.data[index].unlockHeight.toString());
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }

  Future<void> netData() async {
    page = 1;
    ContractRecordModel model = await ContractRecordDao.fetch();
    if (!mounted) {
      return;
    }
    if (model.data == null) {
      return;
    }
    _loadingType = LoadingType.finish;
    if (page == 1) {
      contractRecordModel = model;
    } else {
      contractRecordModel.data.addAll(model.data);
    }
    setState(() {});
    if (contractRecordModel.data.length == 0) {
      _loadingType = LoadingType.no_data;
    }
    page++;

    if (model.data.length < 20) {
      _controller.finishLoad(noMore: true);
    }
    EasyLoading.dismiss(animation: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      netData();
      setState(() {
        this.address = address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFeeeeee),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFEEEEEE),
        // 隐藏阴影
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).defi_record_title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          widget.isShowTitle
              ? MaterialButton(
                  minWidth: 10,
                  child: new Text(
                    S.of(context).defi_record_title_right,
                    style: TextStyle(
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DefiRecordsOldPage(isShowTitle: false)));
                  },
                )
              : Container(),
        ],
      ),
      body: LoadingWidget(
        child: EasyRefresh(
          onRefresh: _onRefresh,
          // header: MaterialHeader(
          // valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
//          controller: _controller,
          child: ListView.builder(
            itemBuilder: buildColumn,
//            itemCount: 10,
            itemCount: contractRecordModel == null ? 0 : contractRecordModel.data.length,
          ),
        ),
        type: _loadingType,
        onPressedError: () {
          setState(() {
            _loadingType = LoadingType.loading;
          });
          _onRefresh();
        },
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if (index < list.length) {
    return buildColumn(context, index);
  }

  Widget buildColumn(BuildContext context, int position) {
    return getItem(context, position);
  }

  Widget getItem(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: contractRecordModel.data[index])));
        },
        child: Container(
          color: Color(0xFFEEEEEE),
          child: Container(
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
            margin: EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 0),
            padding: EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).defi_record_item_lock_number,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                contractRecordModel.data[index].number.toString(),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).defi_record_item_mine_number,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                contractRecordModel.data[index].tokenNumber.toString(),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).defi_record_item_lock_time,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                contractRecordModel.data[index].day.toString() + S.of(context).defi_record_item_lock_time_day,
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).defi_record_item_day_time,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                getContinueTime(context, index),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).defi_record_item_time,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                getUnlockTime(context, index),
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  S.of(context).defi_record_item_status,
                                  style: TextStyle(color: Colors.black.withAlpha(156), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                getType(index),
                                style: TextStyle(color: Colors.green, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildLine(context, index),
                      Container(
                        width: MediaQuery.of(context).size.width - 18 * 4,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
//                            buildUpdate(context, index),
                            buildContainerExpanded(index),
                            buildUnlock(context, index),
                          ],
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainerExpanded(int index) {
    if (contractRecordModel.data[index].height > contractRecordModel.data[index].continueHeight && contractRecordModel.data[index].height <= contractRecordModel.data[index].unlockHeight) {
      return Container(
        width: 0,
      );
    }
    return Container(
      width: 20,
    );
  }

  String getContinueTime(BuildContext context, int index) {
    return Utils.formatHeight(context, contractRecordModel.data[index].height, contractRecordModel.data[index].continueHeight);
  }

  String getUnlockTime(BuildContext context, int index) {
    return Utils.formatHeight(context, contractRecordModel.data[index].height, contractRecordModel.data[index].unlockHeight);
  }

  Container buildUnlock(BuildContext context, int index) {
    if (true) {
//    if (contractRecordModel.data[index].height > contractRecordModel.data[index].unlockHeight) {
      return Container(
        height: 30,
        width: (MediaQuery.of(context).size.width - 18 * 4) / 2 - 10,
        margin: const EdgeInsets.only(top: 15),
        child: FlatButton(
          onPressed: () {
            netUnLockV2(index);
          },
          child: Text(
            S.of(context).defi_record_item_btn_unlock,
            maxLines: 1,
            style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFF3561ef)),
          ),
          color: Color(0x333A66F5),
          textColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      );
    }

    return Container();
  }

  Container buildUpdate(BuildContext context, int index) {
//    if (true) {
    if (contractRecordModel.data[index].height > contractRecordModel.data[index].continueHeight) {
      return Container(
        height: 30,
        width: (MediaQuery.of(context).size.width - 18 * 4) / 2 - 10,
        margin: const EdgeInsets.only(top: 15),
        child: FlatButton(
          onPressed: () {
            showMaterialModalBottomSheet(
              context: context,
              backgroundColor: Color(0xFFFFFFFF).withAlpha(0),
              builder: (context) => Container(
                  height: 250,
                  decoration: new BoxDecoration(
//                      color: Color(0xFFFFFFFF),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: []),
                  child: Container(
                    //边框设置
//                              height: MediaQuery.of(context).size.height,
                    decoration: new BoxDecoration(
//                        color: Color(0xFFFFFFFF),
//                                  color: Color(0xE6FFFFFF),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        boxShadow: []),
                    child: StatefulBuilder(builder: (context, setBottomSheetState) {
                      return Material(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                S.of(context).defi_card_time,
                                style: new TextStyle(fontSize: 17, fontWeight: FontWeight.w500, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFF000000)),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 18, top: 32),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5, right: 5, top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                      onTap: () {
                                        setBottomSheetState(() {
                                          day = 1;
                                        });
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Color(day == 1 ? dayCheckColor : dayUnCheckColor),
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
                                                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 1 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              margin: EdgeInsets.only(top: 17),
                                              child: Text(
                                                S.of(context).defi_card_time_day,
                                                style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 1 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                      onTap: () {
                                        setBottomSheetState(() {
                                          day = 7;
                                        });
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Color(day == 7 ? dayCheckColor : dayUnCheckColor),
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
                                                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 7 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              margin: EdgeInsets.only(top: 17),
                                              child: Text(
                                                S.of(context).defi_card_time_day,
                                                style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 7 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                      onTap: () {
                                        setBottomSheetState(() {
                                          day = 30;
                                        });
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Color(day == 30 ? dayCheckColor : dayUnCheckColor),
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
                                                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 30 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              margin: EdgeInsets.only(top: 17),
                                              child: Text(
                                                S.of(context).defi_card_time_day,
                                                style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 30 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                      onTap: () {
                                        setBottomSheetState(() {
                                          day = 90;
                                        });
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Color(day == 90 ? dayCheckColor : dayUnCheckColor),
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
                                                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 90 ? dayTextCheckColor : dayTextUnCheckColor)),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              margin: EdgeInsets.only(top: 17),
                                              child: Text(
                                                S.of(context).defi_card_time_day,
                                                style: new TextStyle(fontSize: 10.8, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(day == 90 ? dayTextCheckColor : dayTextUnCheckColor)),
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
                              margin: EdgeInsets.only(top: 50, bottom: 10),
                              child: ArgonButton(
                                height: 50,
                                roundLoadingShape: true,
                                width: 320,
                                onTap: (startLoading, stopLoading, btnState) {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  S.of(context).defi_card_mine,
                                  style: new TextStyle(fontSize: 18, fontWeight: FontWeight.normal, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Colors.white),
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
                          ],
                        ),
                      );
                    }),
                  )),
            );
//            netUpdate(index);
          },
          child: Text(
            S.of(context).defi_record_item_btn_continue,
            maxLines: 1,
            style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFF000000)),
          ),
          color: Color(0xFFEEEEEE),
          textColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      );
    }
    return Container();
  }

  Container buildLine(BuildContext context, index) {
    if (contractRecordModel.data[index].height > contractRecordModel.data[index].continueHeight) {
      return Container(
        color: Color(0xFFEEEEEE),
        margin: EdgeInsets.only(top: 12),
        width: MediaQuery.of(context).size.width - 18 * 4,
        height: 1,
      );
    }
    return Container();
  }

  String getType(int index) {
    if (contractRecordModel.data[index].height < contractRecordModel.data[index].continueHeight) {
      return S.of(context).defi_record_item_status_lock;
    }
    if (contractRecordModel.data[index].height > contractRecordModel.data[index].unlockHeight) {
      return S.of(context).defi_record_item_status_unlock;
    }
    if (contractRecordModel.data[index].height > contractRecordModel.data[index].continueHeight) {
      return S.of(context).defi_record_item_status_lock;
    }
    return "-";
  }

  Future<void> _onRefresh() async {
    page = 1;
    await netData();
  }

  Future<void> _onLoad() async {
    await netData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
