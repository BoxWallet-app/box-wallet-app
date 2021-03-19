import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aens_info_dao.dart';
import 'package:box/dao/aens_preclaim_dao.dart';
import 'package:box/dao/aens_register_dao.dart';
import 'package:box/dao/aens_update_dao.dart';
import 'package:box/dao/contract_decode_dao.dart';
import 'package:box/dao/name_owner_dao.dart';
import 'package:box/dao/th_hash_dao.dart';
import 'package:box/dao/tx_broadcast_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aens_info_model.dart';
import 'package:box/model/aens_register_model.dart';
import 'package:box/model/aens_update_model.dart';
import 'package:box/model/contract_decode_model.dart';
import 'package:box/model/msg_sign_model.dart';
import 'package:box/model/name_owner_model.dart';
import 'package:box/page/home_page_v2.dart';
import 'package:box/page/name_point_page.dart';
import 'package:box/page/name_transfer_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/tx_conform_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AensDetailPage extends StatefulWidget {
  final String name;

  const AensDetailPage({Key key, this.name}) : super(key: key);

  @override
  _AensDetailPageState createState() => _AensDetailPageState();
}

class _AensDetailPageState extends State<AensDetailPage> {
  AensInfoModel _aensInfoModel = AensInfoModel();
  LoadingType _loadingType = LoadingType.loading;
  Flushbar flush;

  String address = '';
  int errorCount = 0;
  var accountPubkey = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
    eventBus.on<NameEvent>().listen((event) {
      netAensPoint();
    });
  }

  void netAensPoint() {
    NameOwnerDao.fetch(widget.name).then((NameOwnerModel model) {
      if (model != null && model.owner.isNotEmpty) {
        model.pointers.forEach((element) {
          if (element.key == "account_pubkey") {
            accountPubkey = element.id;
          }
        });
        if (accountPubkey == "") {
          accountPubkey = model.owner;
        }
        setState(() {});
      } else {}
    }).catchError((e) {});
    return;
  }

  void netAensInfo() {
    AensInfoDao.fetch(widget.name).then((AensInfoModel model) {
      _aensInfoModel = model;
      _loadingType = LoadingType.finish;
      netAensPoint();
      setState(() {});
    }).catchError((e) {
      _loadingType = LoadingType.error;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfffafafa),
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
            _aensInfoModel.data == null ? "" : _aensInfoModel.data.name,
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          actions: <Widget>[
            if (isPoint())
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NameTransferPage(
                                  name: widget.name,
                                )));
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(15),
                    child: Image(
                      width: 36,
                      height: 36,
                      color: Colors.black,
                      image: AssetImage('images/name_transfer.png'),
                    ),
                  ),
                ),
              ),
            if (isPoint())
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NamePointPage(
                                  name: widget.name,
                                )));
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(15),
                    child: Image(
                      width: 36,
                      height: 36,
                      color: Colors.black,
                      image: AssetImage('images/name_point.png'),
                    ),
                  ),
                ),
              ),
          ]),
      body: LoadingWidget(
        type: _loadingType,
        onPressedError: () {
          netAensInfo();
        },
        child: Column(
          children: <Widget>[
            buildItem(S.of(context).aens_detail_page_name, _aensInfoModel.data == null ? "" : _aensInfoModel.data.name),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildItem("TxHash", _aensInfoModel.data == null ? "" : _aensInfoModel.data.thHash),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildItem(S.of(context).aens_detail_page_balance + "(ae)", _aensInfoModel.data == null ? "" : Utils.formatPrice(_aensInfoModel.data.currentPrice)),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildItem(S.of(context).aens_detail_page_height, _aensInfoModel.data == null ? "" : _aensInfoModel.data.currentHeight.toString()),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildItem(getTypeKey(), getTypeValue()),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildItem(S.of(context).aens_detail_page_owner, _aensInfoModel.data == null ? "" : _aensInfoModel.data.owner),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildItem(S.of(context).name_point, accountPubkey),
            Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
            buildBtnAdd(context),
            buildBtnUpdate(context),
//            buildBtnPoint(context),
          ],
        ),
      ),
    );
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
        netAensInfo();
      });
    });
  }

  String getTypeValue() {
    if (_aensInfoModel.data == null) {
      return "-";
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return Utils.formatHeight(context, _aensInfoModel.data.currentHeight, _aensInfoModel.data.overHeight);
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return Utils.formatHeight(context, _aensInfoModel.data.currentHeight, _aensInfoModel.data.endHeight);
    }

    return "-";
  }

  String getTypeKey() {
    if (_aensInfoModel.data == null) {
      return S.of(context).aens_list_page_item_time_end;
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return S.of(context).aens_list_page_item_time_end;
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return S.of(context).aens_list_page_item_time_over;
    }

    return S.of(context).aens_list_page_item_time_over;
  }

  Container buildBtnUpdate(BuildContext context) {
    if (_aensInfoModel.data == null) {
      return Container();
    }

    if (_aensInfoModel.data.owner != address) {
      return Container();
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 20),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        child: FlatButton(
          onPressed: () {
            netUpdateV2(context);
          },
          child: Text(
            S.of(context).aens_detail_page_update,
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
          ),
          color: Color(0xff6F53A1),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  bool isPoint() {
    if (_aensInfoModel.data == null) {
      return false;
    }

    if (_aensInfoModel.data.owner != address) {
      return false;
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return false;
    }
    return true;
  }

  Container buildBtnPoint(BuildContext context) {
    if (_aensInfoModel.data == null) {
      return Container();
    }

    if (_aensInfoModel.data.owner != address) {
      return Container();
    }

    if (_aensInfoModel.data.currentHeight < _aensInfoModel.data.endHeight) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 1, bottom: 30),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        child: FlatButton(
          onPressed: () {
            netUpdateV2(context);
          },
          child: Text(
            "指向",
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
          ),
          color: Color(0xFFFC2365),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Future<void> netUpdateV2(BuildContext context) async {
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
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                  // ignore: missing_return
                  BoxApp.updateName((tx) {
                    showPlatformDialog(
                      androidBarrierDismissible: false,
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () async => false,
                        child: BasicDialogAlert(
                          content: Text(
                            tx,
                          ),
                          actions: <Widget>[
                            BasicDialogAction(
                              title: Text(
                                S.of(context).dialog_copy,
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: tx));
                                Navigator.of(context, rootNavigator: true).pop();
                                print(tx);
                                showFlush(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );

                    // ignore: missing_return
                  }, (error) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );

                    // ignore: missing_return
                  }, aesDecode, address, _aensInfoModel.data.name, HomePageV2.address);
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

  Future<void> netPreclaimV2(BuildContext context) async {
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
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
                  // ignore: missing_return
                  BoxApp.bidName((tx) {
                    showPlatformDialog(
                      androidBarrierDismissible: false,
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () async => false,
                        child: BasicDialogAlert(
                          content: Text(
                            tx,
                          ),
                          actions: <Widget>[
                            BasicDialogAction(
                              title: Text(
                                S.of(context).dialog_copy,
                                style: TextStyle(
                                  color: Color(0xFFFC2365),
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: tx));
                                Navigator.of(context, rootNavigator: true).pop();
                                print(tx);
                                showFlush(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );

                    // ignore: missing_return
                  }, (error) {
                    showPlatformDialog(
                      context: context,
                      builder: (_) => BasicDialogAlert(
                        title: Text(S.of(context).dialog_hint_check_error),
                        content: Text(error),
                        actions: <Widget>[
                          BasicDialogAction(
                            title: Text(
                              S.of(context).dialog_conform,
                              style: TextStyle(
                                color: Color(0xFFFC2365),
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ],
                      ),
                    );

                    // ignore: missing_return
                  }, aesDecode, address, _aensInfoModel.data.name, (double.parse(_aensInfoModel.data.currentPrice) + double.parse(_aensInfoModel.data.currentPrice) * 0.1).toString());
                  showChainLoading();
                },
              ),
            ),
          );
        });
  }

  void showFlush(BuildContext context) {
    flush = Flushbar<bool>(
      title: S.of(context).hint_broadcast_sucess,
      message: S.of(context).hint_broadcast_sucess_hint,
      backgroundGradient: LinearGradient(colors: [Color(0xFFFC2365), Color(0xFFFC2365)]),
      backgroundColor: Color(0xFFFC2365),
      blockBackgroundInteraction: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      //                        flushbarStyle: FlushbarStyle.GROUNDED,

      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true); // result = true
        },
        child: Text(
          S.of(context).dialog_conform,
          style: TextStyle(color: Colors.white),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Color(0x88000000),
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
      });
  }

  Container buildBtnAdd(BuildContext context) {
    if (_aensInfoModel.data == null) {
      return Container();
    }

    if (_aensInfoModel.data.currentHeight > _aensInfoModel.data.endHeight) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        child: FlatButton(
          onPressed: () {
            netPreclaimV2(context);
          },
          child: Text(
            S.of(context).aens_detail_page_add + " ≈ " + (double.parse(_aensInfoModel.data.currentPrice) + double.parse(_aensInfoModel.data.currentPrice) * 0.1).toStringAsFixed(2) + " AE",
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
          ),
          color: Color(0xFFFC2365),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget buildItem(String key, String value) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
        },
        child: Container(
          padding: const EdgeInsets.all(18),
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
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                  ),
                ],
              ),
              /*3*/
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: new Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
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
