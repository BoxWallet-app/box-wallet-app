import 'dart:async';
import 'dart:convert';

import 'package:box/dao/aeternity/account_info_dao.dart';
import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/cache_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../main.dart';
import '../base_page.dart';
import 'ae_home_page.dart';
import 'ae_select_token_list_page.dart';

class AeTokenSendTwoPage extends BaseWidget {
  final String address;

  final String? tokenName;
  final String? tokenCount;
  final String? tokenImage;
  final String? tokenContract;

  AeTokenSendTwoPage({Key? key, required this.address, this.tokenName, this.tokenCount, this.tokenImage, this.tokenContract});

  @override
  _AeTokenSendTwoPageState createState() => _AeTokenSendTwoPageState();
}

class _AeTokenSendTwoPageState extends BaseWidgetState<AeTokenSendTwoPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  final FocusNode focusNode = FocusNode();
  String address = '';
  var loadingType = LoadingType.loading;
  List<Widget> items = <Widget>[];

  String? tokenName;
  String? tokenCount;
  String? tokenImage;
  String? tokenContract;

  bool isSpend = false;

  @override
  void initState() {
    super.initState();
    this.tokenName = "AE";
    this.tokenCount = AeHomePage.token;
    this.tokenImage = "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-ae.png";

    if (widget.tokenName != null) {
      this.tokenName = widget.tokenName;
    }
    if (widget.tokenCount != null) {
      this.tokenCount = widget.tokenCount;
    }
    if (widget.tokenImage != null) {
      this.tokenImage = widget.tokenImage;
    }
    if (widget.tokenContract != null) {
      this.tokenContract = widget.tokenContract;
    }

    if (widget.tokenContract != null) {
      netContractBalance();
    }

    netAccountInfo();
    getAddress();
  }

  void netContractBalance() {
    ContractBalanceDao.fetch(widget.tokenContract).then((ContractBalanceModel model) {
      if (model.code == 200) {
        this.tokenCount = model.data!.balance;
        setState(() {});
      } else {}
    }).catchError((e) {});
  }

  Future<void> netAccountInfo() async {
    Account account = await getCurrentAccount();
    BoxApp.getBalanceAE((balance, decimal) async {
      if (!mounted) return;
      AeHomePage.token = Utils.formatBalanceLength(double.parse(AmountDecimal.parseUnits(balance, decimal)));
      CacheManager.instance.setBalance(account.address!, account.coin!, AeHomePage.token);
      setState(() {});
      return;
    }, account.address!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFFC2365),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              color: Color(0xFFFC2365),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topRight, colors: [
                                  Color(0xFFFC2365),
                                  Color(0xFFEEEEEE),
                                ]),
                              ),
                              height: 190,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
                              child: Text(
                                S.of(context).token_send_two_page_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    S.of(context).token_send_two_page_from,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    Utils.formatAddress(address),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    S.of(context).token_send_two_page_to,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    getReceiveAddress(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(20),
                              height: tokenName != "AE" ? 172 : 222,
                              //边框设置
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: []
                                  //设置四周边框
                                  ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).token_send_two_page_number,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 18, top: 0, right: 18),
                                    child: Stack(
                                      children: <Widget>[
                                        TextField(
//                                          autofocus: true,

                                          controller: _textEditingController,
                                          focusNode: focusNode,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
                                          ],

                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '0.00',
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFFC2365)),
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
                                        Positioned(
                                          right: 0,
                                          top: 12,
                                          child: Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(top: 0),
                                            child: FlatButton(
                                              onPressed: () {
                                                clickAllCount();
                                              },
                                              child: Text(
                                                S.of(context).token_send_two_page_all,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFFF22B79)),
                                              ),
                                              color: Color(0xFFE61665).withAlpha(16),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        focusNode.unfocus();
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            expand: true,
                                            enableDrag: false,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => AeSelectTokenListPage(
                                                  aeCount: AeHomePage.token,
                                                  aeSelectTokenListCallBackFuture: (String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract) {
                                                    this.tokenName = tokenName;
                                                    this.tokenCount = tokenCount;
                                                    this.tokenImage = tokenImage;
                                                    this.tokenContract = tokenContract;
                                                    setState(() {});
                                                    return;
                                                  },
                                                )
//
                                            );
                                      },
                                      child: Container(
                                        height: 55,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 18),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 36.0,
                                                    height: 36.0,
                                                    decoration: BoxDecoration(
                                                      border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(36.0),
                                                    ),
                                                    child: tokenImage != null
                                                        ? ClipOval(
                                                            child: Image.network(
                                                              tokenImage!,
                                                              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                if (wasSynchronouslyLoaded) return child;

                                                                return AnimatedOpacity(
                                                                  child: child,
                                                                  opacity: frame == null ? 0 : 1,
                                                                  duration: const Duration(seconds: 2),
                                                                  curve: Curves.easeOut,
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : null,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      tokenName == null ? "" : tokenName!,
                                                      style: new TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 20,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    tokenCount == null ? "" : tokenCount!,
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15,
                                                    color: Color(0xFF333333),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (tokenName == "AE")
                                    Container(
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: new BoxDecoration(
                                              color: Color(0xffffffff),
                                              //设置四周圆角 角度
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            child: TextField(
                                              controller: _textEditingControllerNode,
                                              focusNode: focusNodeNode,
                                              inputFormatters: [
                                                //   FilteringTextInputFormatter.allow(RegExp("[0-9]")), //只允许输入字母
                                              ],
                                              maxLines: 1,
                                              style: TextStyle(
                                                textBaseline: TextBaseline.alphabetic,
                                                fontSize: 18,
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                                color: Colors.black,
                                              ),

                                              decoration: InputDecoration(
                                                hintText: S.of(context).AeTokenSendTwoPage_note,
                                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
                                                enabledBorder: new OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                  ),
                                                ),
                                                focusedBorder: new OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  borderSide: BorderSide(color: Color(0x00000000)),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF666666).withAlpha(85),
                                                ),
                                              ),
                                              cursorColor: Color(0xFFFC2365),
                                              cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
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
                      )
                    ],
                  ),
                  Container(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      width: MediaQuery.of(context).size.width * 0.8,
                      clipBehavior: Clip.hardEdge,
                      // padding: const EdgeInsets.only(bottom: 6, top: 6),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xFFFC2365),
                      ),
                      child: Material(
                        color: Color(0xFFFC2365),
                        child: InkWell(
                          onTap: () async {
                            netSend(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSpend)
                                const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xffffffff),
                                      strokeWidth: 4,
                                    ),
                                  ),
                                ),
                              if (!isSpend)
                                Text(
                                  S.of(context).token_send_two_page_conform,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
//
  }

  void clickAllCount() {
    if (double.parse(tokenCount!) > 1) {
      _textEditingController.text = (double.parse(tokenCount!) - 0.1).toString();
    } else {
      _textEditingController.text = tokenCount!;
    }
    _textEditingController.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length));
  }

  void getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
      });
    });
  }

  String getReceiveAddress() {
    return Utils.formatAddress(widget.address);
  }

  Future<void> netSend(BuildContext context) async {
    if (isSpend) return;
    var note = "";
    if (_textEditingControllerNode.text == "") {
      note = "Box Wallet";
    } else {
      note = _textEditingControllerNode.text;
    }
    if (_textEditingController.text == "") {
      showConfirmDialog(S.of(context).dialog_hint, S.of(context).dialog_amount_null);
      return;
    }
    focusNode.unfocus();
    var amount = _textEditingController.text;
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (tokenContract == null || tokenContract == "") {
        var params = {
          "name": "aeSpend",
          "params": {"secretKey": privateKey, "receiveAddress": widget.address, "amount": amount, "payload": Utils.encodeBase64(note)}
        };
        var channelJson = json.encode(params);
        isSpend = true;
        setState(() {});
        BoxApp.sdkChannelCall((result) {
          if (!mounted) return;
          isSpend = false;
          final jsonResponse = json.decode(result);
          if (jsonResponse["name"] != params['name']) {
            return;
          }
          var code = jsonResponse["code"];
          var message = jsonResponse["message"];
          var hash = jsonResponse["result"]["hash"];
          if (code == 200) {
            showCopyHashDialog(context, hash, (val) async {
              showFlushSucess(context);
            });
          } else {
            showConfirmDialog(S.of(context).dialog_hint, message);
          }

          setState(() {});
          return;
        }, channelJson);

        // BoxApp.spend((tx) {
        //   showCopyHashDialog(context, tx, (val) async {
        //     showFlushSucess(context);
        //   });
        //   return;
        // }, (error) {
        //   showConfirmDialog(S.of(context).dialog_hint, error);
        //   return;
        // }, privateKey, address, widget.address, _textEditingController.text, Utils.encodeBase64(note));
      } else {
        BoxApp.contractTransfer((tx) async {
          showCopyHashDialog(context, tx, (val) async {
            showFlushSucess(context);
          });
        }, (error) {
          showConfirmDialog(S.of(context).dialog_hint, error);
          return;
        }, privateKey, address, tokenContract!, widget.address, _textEditingController.text, "full");
      }
    });
  }
}
