import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:box/dao/aeternity/aens_info_dao.dart';
import 'package:box/dao/aeternity/name_owner_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/name_owner_model.dart';
import 'package:box/page/aeternity/ae_aens_point_page.dart';
import 'package:box/page/aeternity/ae_aens_transfer_page.dart';
import 'package:box/page/aeternity/ae_home_page.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AeAensDetailPage extends BaseWidget {
  final int currentHeight;
  final Map aensDetail;

  AeAensDetailPage({
    Key? key,
    required this.aensDetail,
    required this.currentHeight,
  });

  @override
  _AeAensDetailPageState createState() => _AeAensDetailPageState();
}

class _AeAensDetailPageState extends BaseWidgetState<AeAensDetailPage> {
  LoadingType _loadingType = LoadingType.finish;
  late Flushbar flush;

  String address = '';
  int errorCount = 0;
  String? accountPubkey = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
    eventBus.on<NameEvent>().listen((event) {
      netAensPoint();
    });
    netAensPoint();
  }

  void netAensPoint() {
    NameOwnerDao.fetch(widget.aensDetail['name']).then((NameOwnerModel model) {
      if (model.owner!.isNotEmpty) {
        model.pointers!.forEach((element) {
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

  // void netAensInfo() {
  //   AensInfoDao.fetch( widget.aensDetail['name']).then((AensInfoModel model) {
  //     _aensInfoModel = model;
  //     _loadingType = LoadingType.finish;
  //     netAensPoint();
  //     setState(() {});
  //   }).catchError((e) {
  //     _loadingType = LoadingType.error;
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          // 隐藏阴影
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.aensDetail['name'],
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
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
                            builder: (context) => AeAensTransferPage(
                                  name: widget.aensDetail['name'],
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
                            builder: (context) => AeAensPointPage(
                                  name: widget.aensDetail['name'],
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
          // netAensInfo();
        },
        child: Column(
          children: <Widget>[
            buildItem(S.of(context).aens_detail_page_name, widget.aensDetail['name']),
            buildItem("TxHash", widget.aensDetail['hash']),
            buildItem(S.of(context).aens_detail_page_balance + "(ae)", widget.aensDetail['price']),
            buildItem(S.of(context).aens_detail_page_height, widget.aensDetail['endHeight'].toString()),
            buildItem(getTypeKey(), getTypeValue()),
            buildItem(S.of(context).aens_detail_page_owner, widget.aensDetail['owner']),
            buildItem(S.of(context).name_point, accountPubkey!),
            buildBtnAdd(context),
            buildBtnUpdate(context),
            buildBtnPoint(context),
          ],
        ),
      ),
    );
  }

  getAddress() async {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
        // netAensInfo();
      });
    });
  }

  String getTypeValue() {
    if (widget.currentHeight > widget.aensDetail['endHeight']) {
      return Utils.formatHeight(context, widget.currentHeight, widget.aensDetail['overHeight']);
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return Utils.formatHeight(context, widget.currentHeight, widget.aensDetail['overHeight']);
    }

    return "-";
  }

  String getTypeKey() {
    if (widget.currentHeight > widget.aensDetail['endHeight']) {
      return S.of(context).aens_list_page_item_time_end;
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return S.of(context).aens_list_page_item_time_over;
    }

    return S.of(context).aens_list_page_item_time_over;
  }

  Container buildBtnUpdate(BuildContext context) {
    if (widget.aensDetail['owner'] != address) {
      return Container();
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
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
    if (widget.aensDetail['owner'] != address) {
      return false;
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
      return false;
    }
    return true;
  }

  Container buildBtnPoint(BuildContext context) {
    if (widget.aensDetail['owner'] != address) {
      return Container();
    }

    if (widget.currentHeight < widget.aensDetail['endHeight']) {
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
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      BoxApp.updateName((tx) async {
        showCopyHashDialog(context, tx, (val) async {
          showFlushSucess(context);
        });
      }, (error) {
        showConfirmDialog(S.of(context).dialog_hint, error);
        return;
      }, privateKey, address, widget.aensDetail['name'], accountPubkey == "" ? AeHomePage.address! : accountPubkey!);
      showChainLoading("");
    });
  }

  Future<void> netPreclaimV2(BuildContext context) async {
    showPasswordDialog(context, (address, privateKey, mnemonicn, password) async {
      BoxApp.bidName((tx) async {
        showCopyHashDialog(context, tx, (val) async {
          showFlushSucess(context);
        });
      }, (error) {
        showConfirmDialog(S.of(context).dialog_hint, error);
        return;
      }, privateKey, address, widget.aensDetail['name'], accountPubkey == "" ? AeHomePage.address! : accountPubkey!);
      showChainLoading("");
    });
    // showGeneralDialog(
    //     useRootNavigator: false,
    //     context: context,
    //     // ignore: missing_return
    //     pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
    //     //barrierColor: Colors.grey.withOpacity(.4),
    //     barrierDismissible: true,
    //     barrierLabel: "",
    //     transitionDuration: Duration(milliseconds: 0),
    //     transitionBuilder: (_, anim1, anim2, child) {
    //       final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
    //       return Transform(
    //         transform: Matrix4.translationValues(0.0, 0, 0.0),
    //         child: Opacity(
    //           opacity: anim1.value,
    //           // ignore: missing_return
    //           child: PayPasswordWidget(
    //             title: S.of(context).password_widget_input_password,
    //             dismissCallBackFuture: (String password) {
    //               return;
    //             },
    //             passwordCallBackFuture: (String password) async {
    //               var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
    //               var address = await BoxApp.getAddress();
    //               final key = Utils.generateMd5Int(password + address);
    //               var aesDecode = Utils.aesDecode(signingKey, key);
    //
    //               if (aesDecode == "") {
    //                 showErrorDialog(context, null);
    //                 return;
    //               }
    //               // ignore: missing_return
    //               BoxApp.bidName(
    //                   (tx) {
    //                     showCopyHashDialog(context, tx);
    //                   } as Future<dynamic> Function(String), (error) {
    //                 showErrorDialog(context, error);
    //                 return;
    //               }, aesDecode, address, _aensInfoModel.data!.name!, (double.parse(_aensInfoModel.data!.currentPrice!) + double.parse(_aensInfoModel.data!.currentPrice!) * 0.1).toString());
    //               showChainLoading();
    //             },
    //           ),
    //         ),
    //       );
    //     });
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
    if (widget.currentHeight > widget.aensDetail['endHeight']) {
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
            S.of(context).aens_detail_page_add + " ≈ " + (double.parse(widget.aensDetail['price']) + double.parse(widget.aensDetail['price']) * 0.1).toStringAsFixed(2) + " AE",
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
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 12),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
      ),
    );
  }
}
