import 'dart:convert';
import 'dart:ui';

import 'package:box/page/base_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../../generated/l10n.dart';
import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import '../../model/aeternity/wallet_coins_model.dart';
import '../../utils/utils.dart';
import '../../widget/box_header.dart';
import '../../widget/loading_widget.dart';
import 'ae_home_page.dart';

class DialogAensRenew extends BaseWidget {
  @override
  State<DialogAensRenew> createState() => _DialogAensRenewState();
}

class _DialogAensRenewState extends BaseWidgetState<DialogAensRenew> {
  late int position;
  late Map otcNftMy;
  bool isOpenLoading = false;
  late String image;
  late String name;

  final FocusNode amountFocusNode = FocusNode();
  TextEditingController amountController = TextEditingController();
  late Map aensModel;
  late Map aensSuccess = {};
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  late Response aensResponse;
  int currentIndex = -1;
  bool isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    // otcNftMy = widget.otcNftMy;
    // position = widget.position;
    super.initState();
    netData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
              color: Color(0xFFfafbfc),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        onTap: () {
                          if (!isUpdate) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height / 2,
                    child: LoadingWidget(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 30),
                        itemBuilder: _renderRow,
                        itemCount: _loadingType == LoadingType.finish ? aensModel['data']['aens'].length : 0,
                      ),
                      type: _loadingType,
                      onPressedError: () {
                        setState(() {
                          _loadingType = LoadingType.loading;
                        });
                      },
                    ),
                  ),
                  if (_loadingType != LoadingType.loading)
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), backgroundColor: MaterialStateProperty.all(isUpdate ? Colors.grey.withAlpha(100) : Color(0xFFFC2365))),
                          onPressed: () {
                            if (isUpdate) return;
                            showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
                              if (!mounted) return;
                              currentIndex = 0;
                              for (var i = 0; i < aensModel['data']['aens'].length; i++) {
                                aensSuccess[aensModel['data']['aens'][i]['name']] = false;
                              }
                              await updateAens(privateKey, address, context);
                            });
                          },
                          child: Text(
                            isUpdate ? S.of(context).dialog_aens_renew_ing + " " + (currentIndex + 1).toString() + "/" + aensModel['data']['aens'].length.toString() : S.of(context).dialog_aens_renew_btn,
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
        ),
      ),
    );
  }

  Future<void> updateAens(String privateKey, String address, BuildContext context) async {
    if (currentIndex >= aensModel['data']['aens'].length) {
      currentIndex = -1;
      isUpdate = false;

      return;
    }

    isUpdate = true;
    setState(() {});
    var name = aensModel['data']['aens'][currentIndex]['name'];
    var params = {
      "name": "aeAensUpdate",
      "params": {
        "secretKey": "$privateKey",
        "name": "$name",
        "address": address,
        "pointers": {"account_pubkey": address},
        "isPointers": "false"
      }
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      aensSuccess[name] = true;
      print(aensSuccess);
      if (GlobalObjectKey(currentIndex).currentContext != null) {
        Scrollable.ensureVisible(GlobalObjectKey(currentIndex).currentContext!);
      }
      setState(() {});
      // var code = jsonResponse["code"];
      // if (code != 200) {
      //   var message = jsonResponse["message"];
      //   return;
      // }
      // var hash = jsonResponse["result"]["hash"];
      currentIndex++;
      updateAens(privateKey, address, context);

      return;
    }, channelJson);
  }

  Future<void> netData() async {
    try {
      setState(() {});
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      AeHomePage.address = account!.address;

      aensResponse = await Dio().get("https://boxwallet.app/aens/my/over?address=" + AeHomePage.address!);

      if (aensResponse.statusCode != 200) {
        _loadingType = LoadingType.error;
        setState(() {});
        return;
      }
      aensModel = jsonDecode(aensResponse.toString());
      if (aensModel['data']['aens'].length == 0) {
        _loadingType = LoadingType.no_data;
        setState(() {});
        return;
      }
      for (var i = 0; i < aensModel['data']['aens'].length; i++) {
        aensSuccess[aensModel['data']['aens'][i]['name']] = false;
      }
      _loadingType = LoadingType.finish;
      setState(() {});
    } catch (e) {
      _loadingType = LoadingType.error;
      setState(() {});
      return;
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      netData();
    });
  }

  Widget _renderRow(BuildContext context, int index) {
//    if (index < list.length) {
    return Container(key: GlobalObjectKey(index), margin: EdgeInsets.only(left: 15, right: 15, top: 12), child: buildColumn(context, index));
  }

  Column buildColumn(BuildContext context, int position) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
            color: getItemColor(position),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  /*1*/
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      aensModel['data']['aens'][position]['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
//                                  fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (currentIndex == position)
                  Container(
                    width: 40,
                    height: 40,
                    child: Lottie.asset(
                      'images/loading.json',
                    ),
                  ),
                if (aensSuccess[aensModel['data']['aens'][position]['name']])
                  new Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      S.of(context).dialog_aens_renew_success,
                      style: TextStyle(
                        color: Color(0xFFFC2365),
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 10.0),
                  ),
                /*3*/
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color getItemColor(int position) {
    if (currentIndex == position) {
      return Color(0xFFFC2365).withAlpha(10);
    } else {
      return Color(0xffffffff);
    }
  }
}
