import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/dao/conflux/cfx_balance_dao.dart';
import 'package:box/dao/ethereum/eth_activity_coin_dao.dart';
import 'package:box/dao/ethereum/eth_fee_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/eth_manager.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/aeternity/wallet_coins_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/ethereum/eth_fee_model.dart';
import 'package:box/page/ethereum/eth_home_page.dart';
import 'package:box/page/ethereum/eth_select_fee_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../main.dart';
import 'eth_select_token_list_page.dart';

// import 'cfx_home_page.dart';
// import 'cfx_select_token_list_page.dart';

class EthTokenSendTwoPage extends StatefulWidget {
  final String address;

  final String? tokenName;
  final String? tokenCount;
  final String? tokenImage;
  final String? tokenContract;

  EthTokenSendTwoPage({Key? key, required this.address, this.tokenName, this.tokenCount, this.tokenImage, this.tokenContract}) : super(key: key);

  @override
  _EthTokenSendTwoPageState createState() => _EthTokenSendTwoPageState();
}

class _EthTokenSendTwoPageState extends State<EthTokenSendTwoPage> {
  late Flushbar flush;
  TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  var loadingType = LoadingType.loading;
  List<Widget> items = <Widget>[];

  String? tokenName = "";
  String? tokenCount = "";
  String? tokenImage = "";
  String? tokenContract = "";
  String fee = "";
  String feePrice = "";
  String? spendFee = "0";
  String amountFee = "0";
  String minute = "";
  int index = 1;
  int gasLimit = 25000;

  @override
  void initState() {
    super.initState();

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

    getAddress();
    getEthFee();
  }

  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account? account) {
      if (!mounted) {
        return;
      }
      EthHomePage.account = account;
      EthHomePage.address = account!.address;
      if (widget.tokenContract == null) {
        getDefTokenData();
      }
      setState(() {});
    });
  }

  Color getAccountCardBottomBg() {
    if (EthHomePage.account == null) {
      return Color(0xFFFFFFFF);
    }
    if (EthHomePage.account!.coin == "BNB") {
      return Color(0xFFE6A700);
    }
    if (EthHomePage.account!.coin == "OKT") {
      return Color(0xFF1F94FF);
    }
    if (EthHomePage.account!.coin == "HT") {
      return Color(0xFF112FD0);
    }

    if (EthHomePage.account!.coin == "ETH") {
      return Color(0xFF5F66A3);
    }
    return Color(0xFFFFFFFF);
  }

  getDefTokenData() async {
    Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
    this.tokenName = account.coin;
    this.tokenCount = EthHomePage.token;
    this.tokenImage = "https://ae-source.oss-cn-hongkong.aliyuncs.com/" + EthHomePage.account!.coin! + ".png";
    netCfxBalance();
  }

  Future<void> netCfxBalance() async {
    var address = await BoxApp.getAddress();

    Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
    var nodeUrl = await EthManager.instance.getNodeUrl(account);
    BoxApp.getBalanceETH((balance, coin) async {
      if (!mounted) return;
      if (account.coin != coin) return;
      if (balance == "account error") {
        this.tokenCount = "0.0000";
      } else {
        this.tokenCount = Utils.formatBalanceLength(double.parse(balance));
      }

      setState(() {});
      return;
    }, address, account.coin!, nodeUrl);
  }

  Future<void> getEthFee() async {
    fee = "";
    index = 1;
    setState(() {});
    Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
    EthFeeModel ethFeeModel = await EthFeeDao.fetch(EthManager.instance.getChainID(account));
    spendFee = ethFeeModel.data!.feeList![1].fee;
    if (this.tokenContract == "") {
      gasLimit = 25000;
    } else {
      gasLimit = 60000;
    }
    amountFee = (double.parse(ethFeeModel.data!.feeList![1].fee!) * gasLimit / 1000000000000000000).toStringAsFixed(8);
    minute = getFeeMinute(ethFeeModel, 1);
    fee = "" + amountFee + " " + account.coin!;
    setState(() {});
    var ethActivityCoinModel = await EthActivityCoinDao.fetch(EthManager.instance.getChainID(account));
    if (ethActivityCoinModel.data != null && ethActivityCoinModel.data!.length > 0) {
      String price = await EthManager.instance.getRateFormat(ethActivityCoinModel.data![0].priceUsd.toString(), amountFee);
      feePrice = price;
      setState(() {});
    }
  }

  String getFeeMinute(EthFeeModel ethFeeModel, int index) {
    if (double.parse(ethFeeModel.data!.feeList![index].minute!) < 1) {
      return "≈" + (double.parse(ethFeeModel.data!.feeList![index].minute!) * 60).toStringAsFixed(0) + S.current.fee_speed_time1;
    }
    return "≈" + ethFeeModel.data!.feeList![index].minute! + S.current.fee_speed_time2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: getAccountCardBottomBg(),
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.replay,
                size: 17,
                color: Colors.white,
              ),
              onPressed: () async {
                this.tokenCount = "";
                netCfxBalance();
                if (spendFee != "") return await getEthFee();
              },
            ),
          ], systemOverlayStyle: SystemUiOverlayStyle.light,
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
                              color: getAccountCardBottomBg(),
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topRight, colors: [
                                  getAccountCardBottomBg(),
                                  Color(0xFFEEEEEE),
                                ]),
                              ),
                              height: 172,
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
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    Utils.formatAddressCFX(EthHomePage.address),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              height: 172,
                              //边框设置
                              decoration: new BoxDecoration(
                                  color: Color(0xE6FFFFFF),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: [
//                                    BoxShadow(
//                                        color: Colors.black12,
//                                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                        blurRadius: 15.0, //阴影模糊程度
//                                        spreadRadius: 1.0 //阴影扩散程度
//                                        )
                                  ]
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
                                              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '0.0',
                                            enabledBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFF6F6F6)),
                                            ),
                                            focusedBorder: new UnderlineInputBorder(
                                              borderSide: BorderSide(color: getAccountCardBottomBg()),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 19,
                                              color: Colors.black.withAlpha(80),
                                            ),
                                          ),
                                          cursorColor: getAccountCardBottomBg(),
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
                                                style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: getAccountCardBottomBg()),
                                              ),
                                              color: getAccountCardBottomBg().withAlpha(16),
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
                                        showMaterialModalBottomSheet(
                                            context: context,
                                            expand: true,
                                            enableDrag: false,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => EthSelectTokenListPage(
                                                  aeCount: EthHomePage.token,
                                                  aeSelectTokenListCallBackFuture: (String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract) {
                                                    this.tokenName = tokenName;
                                                    this.tokenCount = tokenCount;
                                                    this.tokenImage = tokenImage;
                                                    this.tokenContract = tokenContract;
                                                    getEthFee();
                                                    setState(() {});
                                                    return;
                                                  },
                                                ));
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
                                                        border: Border(
                                                            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                            top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                            left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                                            right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                                                        borderRadius: BorderRadius.circular(36.0),
                                                      ),
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          tokenImage!,
                                                          errorBuilder: (
                                                            BuildContext context,
                                                            Object error,
                                                            StackTrace? stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: Colors.grey.shade200,
                                                            );
                                                          },
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
                                                      )),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      tokenName == null ? "" : tokenName!,
                                                      style: new TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                                  if (tokenCount == "")
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: Lottie.asset(
                                                        'images/loading.json',
                                                      ),
                                                    ),
                                                  if (tokenCount != "")
                                                    AutoSizeText(
                                                      tokenCount!,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Color(0xFF333333),
                                                        fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        onTap: () {
                          showMaterialModalBottomSheet(
                              context: context,
                              expand: true,
                              enableDrag: false,
                              backgroundColor: Colors.transparent,
                              builder: (context) => EthSelectFeePage(
                                    gasLimit: this.gasLimit,

                                    ethSelectFeeCallBackFuture: (String? spendFee, String? amountFee, String? feePrice, String? minute, int? index) {
                                      this.spendFee = spendFee;
                                      this.fee = amountFee!;
                                      this.feePrice = feePrice!;
                                      this.minute = minute!;
                                      this.index = index!;
                                      // getEthFee();
                                      setState(() {});
                                      return;
                                    },
                                  ));
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width - 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(top: 0, left: 20),
                                      child: Row(
                                        children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  S.of(context).fee_title,
                                                  style: new TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff000000),
//                                            fontWeight: FontWeight.w600,
                                                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 0),
                                                child: Text(
                                                  getType(this.index) + minute,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(child: Container()),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              if (fee != "")
                                                Text(
                                                  "≈" + fee,
                                                  style: TextStyle(fontSize: 16, color: Color(0xFF333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                                ),
                                              if (fee == "")
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Lottie.asset(
                                                    'images/loading.json',
                                                  ),
                                                ),
                                              if (feePrice != "" && fee != "")
                                                Container(
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    "≈" + feePrice,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 12, color: Color(0xff999999), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                            color: Color(0xFF333333),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        onPressed: () {
                          netSendV2(context);
                        },
                        child: Text(
                          S.of(context).token_send_two_page_conform,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xffffffff)),
                        ),
                        color: getAccountCardBottomBg(),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

  String getType(int index) {
    if (index == 0) {
      return S.current.fee_speed_1;
    }
    if (index == 1) {
      return S.current.fee_speed_2;
    }
    if (index == 2) {
      return S.current.fee_speed_3;
    }
    return "";
  }

  void clickAllCount() {
    if (this.tokenContract == "") {
      if (double.parse(tokenCount!) == 0) {
        _textEditingController.text = "0";
      } else {
        if (double.parse(this.tokenCount!) > (double.parse(amountFee) * 5)) {
          _textEditingController.text = (double.parse(this.tokenCount!) - (double.parse(amountFee) * 5)).toStringAsFixed(8);
        } else {
          _textEditingController.text = "0";
        }
      }
    } else {
      if (double.parse(tokenCount!) > 1) {
        _textEditingController.text = (double.parse(tokenCount!)).toStringAsFixed(5);
      } else {
        if (double.parse(tokenCount!) == 0) {
          _textEditingController.text = "0";
        } else {
          _textEditingController.text = (double.parse(tokenCount!)).toStringAsFixed(5);
        }
      }
    }
    _textEditingController.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _textEditingController.text.length));
  }

  String getReceiveAddress() {
    return Utils.formatAddressCFX(widget.address);
  }

  Future<void> netSendV2(BuildContext context) async {
    if (_textEditingController.text == "") {
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Text(S.of(context).dialog_hint),
            content: Text(S.of(context).dialog_amount_null),
            actions: <Widget>[
              TextButton(
                child: new Text(
                  S.of(context).dialog_conform,
                ),
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop(false);
                },
              ),
            ],
          );
        },
      ).then((val) {});
      return;
    }
    focusNode.unfocus();
    if (tokenContract == null || tokenContract == "") {
//      startLoading();
      showGeneralDialog(
          useRootNavigator: false,
          context: context,
          // ignore: missing_return
          pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
          //barrierColor: Colors.grey.withOpacity(.4),
          barrierDismissible: true,
          barrierLabel: "",
          transitionDuration: Duration(milliseconds: 0),
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
                    var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
                    var address = await BoxApp.getAddress();
                    final key = Utils.generateMd5Int(password + address);
                    var aesDecode = Utils.aesDecode(signingKey, key);

                    if (aesDecode == "") {
                      showErrorDialog(context, null);
                      return;
                    }
                    Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
                    String nodeUrl = await EthManager.instance.getNodeUrl(account);

                    BoxApp.spendETH((tx) {
                      print(tx);
                      showCopyHashDialog(context, tx);
                      return;
                      // ignore: missing_return
                    }, (error) {
                      showErrorDialog(context, error);
                    }, aesDecode, widget.address, _textEditingController.text, spendFee!, nodeUrl);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    } else {
//      startLoading();
      showGeneralDialog(
          useRootNavigator: false,
          context: context,
          // ignore: missing_return
          pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
          //barrierColor: Colors.grey.withOpacity(.4),
          barrierDismissible: true,
          barrierLabel: "",
          transitionDuration: Duration(milliseconds: 0),
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
                    var signingKey = await (BoxApp.getSigningKey() as FutureOr<String>);
                    var address = await BoxApp.getAddress();
                    final key = Utils.generateMd5Int(password + address);
                    var aesDecode = Utils.aesDecode(signingKey, key);

                    if (aesDecode == "") {
                      showErrorDialog(context, null);
                      return;
                    }
                    Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
                    String nodeUrl = await EthManager.instance.getNodeUrl(account);
                    BoxApp.spendErc20ETH((tx) {
                      showCopyHashDialog(context, tx);
                      return;
                      // ignore: missing_return
                    }, (error) {
                      showErrorDialog(context, error);
                      // ignore: missing_return
                    }, aesDecode, widget.address, tokenContract!, _textEditingController.text, spendFee!, nodeUrl);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    }
  }

  void showChainLoading() {
    showGeneralDialog(
        useRootNavigator: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {} as Widget Function(BuildContext, Animation<double>, Animation<double>),
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget("");
        });
  }

  void showFlushSucess(BuildContext context) {
    flush = Flushbar<bool>(
      title: S.of(context).hint_broadcast_sucess,
      message: S.of(context).hint_broadcast_sucess_hint,
      backgroundGradient: LinearGradient(colors: [getAccountCardBottomBg(), getAccountCardBottomBg()]),
      backgroundColor: getAccountCardBottomBg(),
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
          color: Colors.black.withAlpha(80),
          offset: Offset(0.0, 2.0),
          blurRadius: 13.0,
        )
      ],
    )..show(context).then((result) {
        Navigator.pop(context);
      });
  }

  void showErrorDialog(BuildContext buildContext, String? content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }

  void showCopyHashDialog(BuildContext buildContext, String tx) {
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(S.of(buildContext).dialog_hint_hash),
          content: Text(tx),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_copy,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
              },
            ),
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_dismiss,
              ),
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop(false);
              },
            ),
          ],
        );
      },
    ).then((val) async {
      if (val!) {
        Account account = await (WalletCoinsManager.instance.getCurrentAccount() as FutureOr<Account>);
        var scanUrl = await EthManager.instance.getScanUrl(account);
        Clipboard.setData(ClipboardData(text: scanUrl + tx));
        showFlushSucess(context);
      } else {
        showFlushSucess(context);
      }
    });
  }
}
