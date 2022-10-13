import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/page/base_page.dart';
import 'package:box/utils/amount_decimal.dart';
import 'package:box/widget/amount_text_field_formatter.dart';
import 'package:box/widget/box_header.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../manager/cache_manager.dart';
import '../../manager/wallet_coins_manager.dart';
import '../../model/aeternity/wallet_coins_model.dart';
import '../../utils/utils.dart';
import 'ae_home_page.dart';
import 'ae_select_token_list_page.dart';

class AeSwapPage extends BaseWidget {
  @override
  _AeSwapPageState createState() => _AeSwapPageState();
}

class _AeSwapPageState extends BaseWidgetState<AeSwapPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController controller = EasyRefreshController();
  TextEditingController sellTextControllerNode = TextEditingController();
  final FocusNode sellFocusNode = FocusNode();

  TextEditingController buyTextControllerNode = TextEditingController();
  final FocusNode buyFocusNode = FocusNode();

  String sellTokenAddress = "";
  String sellTokenAmount = "";
  String sellTokenName = "AE";
  String sellTokenImage = "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-ae.png";

  String buyTokenAddress = "ct_7UfopTwsRuLGFEcsScbYgQ6YnySXuyMxQWhw6fjycnzS5Nyzq";
  String buyTokenAmount = "";
  String buyTokenName = "ABC";
  String buyTokenImage = "https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/token/ae-abc.png";

  String tokenRate = "";

  String buttonText = "加载中...";

  bool isPairsLoading = true;
  bool isBalanceLoading = false;
  bool isAllowanceLoading = true;

  var tokenAParseUnits = "";
  var tokenBParseUnits = "";

  var maxSellAmount = 0.0;

  //0没有授权,1已授权
  var typeAllowance = 0;

  late Timer timer;
  @override
  void initState() {
    super.initState();
    updateSellAmount();
    netBuyContractBalance();
    netSwapRoutes();
    aeAex9TokenAllowance();
    timer = Timer.periodic(Duration(milliseconds: 10000), (timer) {
      netSwapRoutes();
    });
    sellTextControllerNode.addListener(() {
      if (!sellFocusNode.hasFocus) {
        return;
      }

      sellTextUpdateBuyAmount();
    });
    buyTextControllerNode.addListener(() {
      if (!buyFocusNode.hasFocus) {
        return;
      }

      buyTextUpdateSellAmount();
    });
  }

  sellTextUpdateBuyAmount() {
    var sellAmount = sellTextControllerNode.text;
    if (sellAmount.isEmpty) {
      isBalanceLoading = false;
      buyTextControllerNode.text = "";
      setState(() {});
      return;
    }
    if (tokenRate.isEmpty) {
      return;
    }
    var buyAmount = double.parse(sellAmount) * double.parse(tokenRate);

    if (tokenAParseUnits.isNotEmpty) {
      logger.info(maxSellAmount);
      if (double.parse(sellAmount) > maxSellAmount) {
        isBalanceLoading = true;
        buttonText = "流动性不足";
      } else {
        isBalanceLoading = false;
      }
    } else {
      isBalanceLoading = false;
    }
    setState(() {});

    buyTextControllerNode.text = AmountDecimal.parseDecimal(buyAmount.toString());
  }

  buyTextUpdateSellAmount() {
    var buyAmount = buyTextControllerNode.text;
    if (buyAmount.isEmpty) {
      sellTextControllerNode.text = "";
      return;
    }
    if (tokenRate.isEmpty) {
      return;
    }
    var sellAmount = double.parse(buyAmount) / double.parse(tokenRate);
    sellTextControllerNode.text = AmountDecimal.parseDecimal(sellAmount.toString());
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<void> netSwapRoutes() async {
    // tokenRate = "";
    // setState(() {});
    var tokenA = sellTokenAddress;
    var tokenB = buyTokenAddress;
    if (tokenA.isEmpty) {
      tokenA = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
    }
    if (tokenB.isEmpty) {
      tokenB = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
    }

    print(tokenA);
    print(tokenB);
    print("https://dex-backend-mainnet.prd.aepps.com/pairs/swap-routes/$tokenA/$tokenB");
    Response swapRoutesResponse = await Dio().get("https://dex-backend-mainnet.prd.aepps.com/pairs/swap-routes/$tokenA/$tokenB", options: Options(responseType: ResponseType.json));

    var swapRoutes = swapRoutesResponse.data as List<dynamic>;
    if (swapRoutes.isEmpty) {
      buttonText = "没有该交易对";
      isPairsLoading = true;
      setState(() {});
      return;
    }
    for (var swapRoutesItem in swapRoutes) {
      for (var swapRoutesItemItem in swapRoutesItem) {
        if ((swapRoutesItemItem["token0"] == tokenA && swapRoutesItemItem["token1"] == tokenB) || (swapRoutesItemItem["token0"] == tokenB && swapRoutesItemItem["token1"] == tokenA)) {
          //售卖的token
          var tokenATotal = "";
          var tokenBTotal = "";
          if (swapRoutesItemItem["token0"] == tokenA) {
            tokenATotal = swapRoutesItemItem["liquidityInfo"]["reserve0"];
            tokenBTotal = swapRoutesItemItem["liquidityInfo"]["reserve1"];
          } else {
            tokenATotal = swapRoutesItemItem["liquidityInfo"]["reserve1"];
            tokenBTotal = swapRoutesItemItem["liquidityInfo"]["reserve0"];
          }
          tokenAParseUnits = AmountDecimal.parseUnits(tokenATotal, 18);
          tokenBParseUnits = AmountDecimal.parseUnits(tokenBTotal, 18);
          print(tokenAParseUnits);
          print(tokenBParseUnits);
          if (double.parse(tokenAParseUnits) == 0 || double.parse(tokenBParseUnits) == 0) {
            isPairsLoading = true;
            buttonText = "没有该交易对";
            tokenRate = "0";
          } else {
            maxSellAmount = double.parse(tokenAParseUnits) * 0.05;

            tokenRate = Utils.formatBalanceLength((double.parse(tokenBParseUnits) / double.parse(tokenAParseUnits)));
            isPairsLoading = false;
          }

          setState(() {});
          return;
        }
      }
    }
    isPairsLoading = true;
    buttonText = "没有该交易对";

    setState(() {});
  }

  updateSellAmount() async {
    if (sellTokenAddress.isEmpty) {
      await netSellAeBalance();
    } else {
      await netSellContractBalance();
    }
  }

  updateBuyAmount() async {
    if (buyTokenAddress.isEmpty) {
      await netBuyAeBalance();
    } else {
      await netBuyContractBalance();
    }
  }

  Future<void> netSellAeBalance() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.token = cacheBalance;
      setState(() {});
    }

    var params = {
      "name": "aeBalance",
      "params": {"address": account.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      sellTokenAmount = AmountDecimal.parseDecimal(balance);
      if (sellTokenAmount == "0.0") {
        isBalanceLoading = true;
        buttonText = "余额太少";
      }

      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> aeDexSwapExactAeForTokens() async {
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
      if (cacheBalance != "") {
        AeHomePage.token = cacheBalance;
        setState(() {});
      }
      var amountAe = sellTextControllerNode.text;
      var amountOutTokenMin = AmountDecimal.parseDecimal((double.parse(buyTextControllerNode.text) * 0.95).toString());

      var tokenA = sellTokenAddress;
      var tokenB = buyTokenAddress;
      if (tokenA.isEmpty) {
        tokenA = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
      }
      if (tokenB.isEmpty) {
        tokenB = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
      }
      var params = {
        "name": "aeDexSwapExactAeForTokens",
        "params": {
          "secretKey": "$privateKey",
          "ctAddress": "ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3",
          "amountAe": amountAe,
          "amountOutTokenMin": amountOutTokenMin,
          "path": ["$tokenA", "$tokenB"],
          "to": "$address",
          "deadline": (Utils.currentTimeMillis() + (30 * 1000)).toString()
        }
      };
      var channelJson = json.encode(params);
      showChainLoading("兑换进行中...");
      setState(() {});
      BoxApp.sdkChannelCall((result) {
        dismissChainLoading();

        if (!mounted) return;
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];

        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S.of(context).dialog_hint, message);
          return;
        }
        var swapReturn = jsonResponse["result"]["result"]["decodedResult"];
        print(swapReturn);
        var tokenReturnAmountA = AmountDecimal.parseUnits(swapReturn[0], 18);
        var tokenReturnAmountB = AmountDecimal.parseUnits(swapReturn[1], 18);
        print(tokenReturnAmountA);
        print(tokenReturnAmountB);

        swapSucess(tokenReturnAmountA, tokenReturnAmountB);
        return;
      }, channelJson);
    });
  }

  void swapSucess(String tokenReturnAmountA, String tokenReturnAmountB) {
    showFlushSucess(context, title: "兑换成功", message: "成功使用$tokenReturnAmountA$sellTokenName兑换$tokenReturnAmountB$buyTokenName", isDismiss: false);
    sellTextControllerNode.text = "";
    buyTextControllerNode.text = "";
    buyTokenAmount = "";
    sellTokenAmount = "";
    setState(() {});
    updateBuyAmount();
    updateSellAmount();
  }

  Future<void> aeDexSwapExactTokensForAe() async {
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
      if (cacheBalance != "") {
        AeHomePage.token = cacheBalance;
        setState(() {});
      }
      var sellAmount = sellTextControllerNode.text;
      var amountOutAeMin = AmountDecimal.parseDecimal((double.parse(buyTextControllerNode.text) * 0.95).toString());

      var tokenA = sellTokenAddress;
      var tokenB = buyTokenAddress;
      if (tokenA.isEmpty) {
        tokenA = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
      }
      if (tokenB.isEmpty) {
        tokenB = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
      }
      var params = {
        "name": "aeDexSwapExactTokensForAe",
        "params": {
          "secretKey": "$privateKey",
          "ctAddress": "ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3",
          "amountToken": "$sellAmount",
          "amountOutAeMin": "$amountOutAeMin",
          "path": ["$tokenA", "$tokenB"],
          "to": "$address",
          "deadline": (Utils.currentTimeMillis() + (30 * 1000)).toString()
        }
      };
      var channelJson = json.encode(params);
      showChainLoading("兑换进行中...");
      setState(() {});
      BoxApp.sdkChannelCall((result) {
        dismissChainLoading();

        if (!mounted) return;
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];

        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S.of(context).dialog_hint, message);
          return;
        }
        var swapReturn = jsonResponse["result"]["result"]["decodedResult"];
        print(swapReturn);
        var tokenReturnAmountA = AmountDecimal.parseUnits(swapReturn[0], 18);
        var tokenReturnAmountB = AmountDecimal.parseUnits(swapReturn[1], 18);
        print(tokenReturnAmountA);
        print(tokenReturnAmountB);
        swapSucess(tokenReturnAmountA, tokenReturnAmountB);
        return;
      }, channelJson);
    });
  }

  Future<void> aeDexSwapExactTokensForTokens() async {
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      var cacheBalance = await CacheManager.instance.getBalance(account!.address!, account.coin!);
      if (cacheBalance != "") {
        AeHomePage.token = cacheBalance;
        setState(() {});
      }
      var sellAmount = sellTextControllerNode.text;
      var buyAmount = AmountDecimal.parseDecimal((double.parse(buyTextControllerNode.text) * 0.95).toString());

      var tokenA = sellTokenAddress;
      var tokenB = buyTokenAddress;
      if (tokenA.isEmpty) {
        tokenA = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
      }
      if (tokenB.isEmpty) {
        tokenB = "ct_J3zBY8xxjsRr3QojETNw48Eb38fjvEuJKkQ6KzECvubvEcvCa";
      }
      var params = {
        "name": "aeDexSwapExactTokensForTokens",
        "params": {
          "secretKey": "$privateKey",
          "ctAddress": "ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3",
          "amountTokenIn": "$sellAmount",
          "amountOutTokenMin": "$buyAmount",
          "path": ["$tokenA", "$tokenB"],
          "to": "$address",
          "deadline": (Utils.currentTimeMillis() + (30 * 1000)).toString()
        }
      };
      var channelJson = json.encode(params);
      showChainLoading("兑换进行中...");
      setState(() {});
      BoxApp.sdkChannelCall((result) {
        dismissChainLoading();

        if (!mounted) return;
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];

        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S.of(context).dialog_hint, message);
          return;
        }
        var swapReturn = jsonResponse["result"]["result"]["decodedResult"];
        print(swapReturn);
        var tokenReturnAmountA = AmountDecimal.parseUnits(swapReturn[0], 18);
        var tokenReturnAmountB = AmountDecimal.parseUnits(swapReturn[1], 18);
        print(tokenReturnAmountA);
        print(tokenReturnAmountB);
        swapSucess(tokenReturnAmountA, tokenReturnAmountB);
        return;
      }, channelJson);
    });
  }

  Future<void> aeAex9TokenCreateAllowance() async {
    showPasswordDialog(context, (address, privateKey, mnemonic, password) async {
      if (!mounted) return;

      var params = {
        "name": "aeAex9TokenCreateAllowance",
        "params": {"secretKey": "$privateKey", "ctAddress": "$sellTokenAddress", "forAddress": "ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3", "amount": "1000000000000000"}
      };
      var channelJson = json.encode(params);
      showChainLoading("正在授权...");
      setState(() {});
      BoxApp.sdkChannelCall((result) {
        dismissChainLoading();

        if (!mounted) return;
        final jsonResponse = json.decode(result);
        if (jsonResponse["name"] != params['name']) {
          return;
        }
        var code = jsonResponse["code"];

        if (code != 200) {
          var message = jsonResponse["message"];
          showConfirmDialog(S.of(context).dialog_hint, message);
          return;
        }
        aeAex9TokenAllowance();
        return;
      }, channelJson);
    });
  }

  Future<void> netSellContractBalance() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();
    var cacheBalance = await CacheManager.instance.getTokenBalance(account!.address!, BoxApp.ABC_CONTRACT_AEX9, account.coin!);
    if (cacheBalance != "") {
      AeHomePage.tokenABC = cacheBalance;
      setState(() {});
    }

    var params = {
      "name": "aeAex9TokenBalance",
      "params": {"ctAddress": sellTokenAddress, "address": account.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      var address = jsonResponse["result"]["address"];
      var ctAddress = jsonResponse["result"]["ctAddress"];
      if (!mounted) return;
      if (address != account.address) return;
      if (ctAddress == buyTokenAddress) {
        buyTokenAmount = AmountDecimal.parseDecimal(balance);
      }
      if (ctAddress == sellTokenAddress) {
        sellTokenAmount = AmountDecimal.parseDecimal(balance);
      }

      setState(() {});

      return;
    }, channelJson);
  }

  Future<void> netBuyAeBalance() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();

    var params = {
      "name": "aeBalance",
      "params": {"address": account!.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      buyTokenAmount = Utils.formatBalanceLength(double.parse(balance));
      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> netBuyContractBalance() async {
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();

    var params = {
      "name": "aeAex9TokenBalance",
      "params": {"ctAddress": buyTokenAddress, "address": account!.address}
    };
    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var balance = jsonResponse["result"]["balance"];
      var address = jsonResponse["result"]["address"];
      var ctAddress = jsonResponse["result"]["ctAddress"];
      if (!mounted) return;
      if (address != account.address) return;
      if (ctAddress == buyTokenAddress) {
        buyTokenAmount = AmountDecimal.parseDecimal(balance);
      }
      if (ctAddress == sellTokenAddress) {
        sellTokenAmount = AmountDecimal.parseDecimal(balance);
      }

      setState(() {});
      return;
    }, channelJson);
  }

  Future<void> aeAex9TokenAllowance() async {
    if (sellTokenAddress.isEmpty) {
      isAllowanceLoading = false;
      typeAllowance = 1;
      setState(() {});
      return;
    }
    isAllowanceLoading = true;
    typeAllowance = 0;
    setState(() {});
    if (!mounted) return;
    Account? account = await WalletCoinsManager.instance.getCurrentAccount();

    var params = {
      "name": "aeAex9TokenAllowance",
      "params": {"ctAddress": sellTokenAddress, "address": account!.address, "forAddress": "ct_azbNZ1XrPjXfqBqbAh1ffLNTQ1sbnuUDFvJrXjYz7JQA1saQ3"}
    };

    var channelJson = json.encode(params);
    BoxApp.sdkChannelCall((result) {
      if (!mounted) return;
      isAllowanceLoading = false;
      final jsonResponse = json.decode(result);
      if (jsonResponse["name"] != params['name']) {
        return;
      }
      var currentAllowance = jsonResponse["result"]["currentAllowance"];
      if (double.parse(currentAllowance) >= 1000000000) {
        typeAllowance = 1;
      } else {
        typeAllowance = 0;
      }
      print(currentAllowance);

      setState(() {});
      return;
    }, channelJson);
  }

  @override
  Widget build(BuildContext context) {
    logger.info(isPairsLoading);
    logger.info(isBalanceLoading);
    logger.info(isAllowanceLoading);
    return Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        // 隐藏阴影
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "积分兑换",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),
        ),
        centerTitle: true,
      ),
      body: EasyRefresh(
        header: BoxHeader(),
        onRefresh: () async {
          tokenRate = "";
          sellTokenAmount = "";
          buyTokenAmount = "";
          isPairsLoading = true;
          isBalanceLoading = false;
          isAllowanceLoading = true;
          setState(() {});
          await netSwapRoutes();
          await aeAex9TokenAllowance();
          await updateBuyAmount();
          await updateSellAmount();
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0, left: 18, right: 18),
              child: Container(
                decoration: new BoxDecoration(
                  color: Color.fromARGB(230, 255, 255, 255),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 18, right: 18),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "卖出",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          if (this.sellTokenAmount.isEmpty)
                            Container(
                              height: 20,
                              child: Lottie.asset(
                                'images/loading.json',
                              ),
                            ),
                          if (this.sellTokenAmount.isNotEmpty)
                            Container(
                              height: 20,
                              child: Text(
                                "价格: " + sellTokenAmount,
                                style: new TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff333333),
                                  //                                            fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: () {
                              sellTextControllerNode.text = sellTokenAmount;
                              sellTextUpdateBuyAmount();
                            },
                            child: Container(
                              height: 20,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                "[最大]",
                                style: new TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFC2365),
                                  //                                            fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sellFocusNode.unfocus();
                        buyFocusNode.unfocus();
                        showMaterialModalBottomSheet(
                            context: context,
                            expand: true,
                            enableDrag: false,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AeSelectTokenListPage(
                                  aeCount: AeHomePage.token,
                                  aeSelectTokenListCallBackFuture: (String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract) {
                                    if (tokenContract == this.buyTokenAddress) {
                                      showToast("你不能兑换相同的积分");
                                      return;
                                    }
                                    this.sellTokenName = tokenName!;
                                    this.sellTokenImage = tokenImage!;
                                    this.sellTokenAddress = tokenContract!;
                                    this.sellTokenAmount = "";
                                    this.sellTextControllerNode.text = "";
                                    this.buyTextControllerNode.text = "";
                                    buttonText = "加载中...";
                                    isPairsLoading = true;
                                    setState(() {});
                                    aeAex9TokenAllowance();
                                    updateSellAmount();
                                    tokenRate = "";
                                    setState(() {});
                                    netSwapRoutes();
                                    return;
                                  },
                                )
//
                            );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  sellTokenImage,
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
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10, right: 8),
                                  child: Text(
                                    sellTokenName,
                                    style: new TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff333333),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              width: 20,
                              height: 20,
                              color: Color(0xff666666),
                              image: AssetImage("images/ic_swap_down.png"),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Container(
                                // height: 70,
                                //                      padding: EdgeInsets.only(left: 10, right: 10),
                                //边框设置
                                decoration: new BoxDecoration(
                                  color: Color.fromARGB(0, 237, 243, 247),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  controller: sellTextControllerNode,
                                  focusNode: sellFocusNode,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
                                    CustomTextFieldFormatter(digit: 6),
                                  ],

                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  style: TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
                                    fontSize: 26,
                                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0.00",
                                    // contentPadding: EdgeInsets.only(left: 10.0),
                                    contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(0, 255, 255, 255),
                                      ),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Color.fromARGB(0, 255, 255, 255)),
                                    ),
                                    border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.circular(10.0),
                                        ),
                                    hintStyle: TextStyle(
                                      fontSize: 26,
                                      color: Color(0xFF666666).withAlpha(85),
                                    ),
                                  ),
                                  cursorColor: Color(0xFFFC2365),
                                  cursorWidth: 2,
                                  //                                cursorRadius: Radius.elliptical(20, 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      height: 35,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              var tempTokenAddress = this.sellTokenAddress;
                              var tempTokenAmount = this.sellTokenAmount;
                              var tempTokenImage = this.sellTokenImage;
                              var tempTokenName = this.sellTokenName;
                              var tempInputAmount = this.sellTextControllerNode.text;

                              this.sellTokenAddress = this.buyTokenAddress;
                              this.sellTokenAmount = this.buyTokenAmount;
                              this.sellTokenImage = this.buyTokenImage;
                              this.sellTokenName = this.buyTokenName;
                              this.sellTextControllerNode.text = this.buyTextControllerNode.text;

                              this.buyTokenAddress = tempTokenAddress;
                              this.buyTokenAmount = tempTokenAmount;
                              this.buyTokenImage = tempTokenImage;
                              this.buyTokenName = tempTokenName;
                              this.buyTextControllerNode.text = tempInputAmount;

                              // this.buyTokenAmount = "";
                              // this.sellTokenAmount = "";
                              buttonText = "加载中...";
                              isPairsLoading = true;
                              setState(() {});
                              aeAex9TokenAllowance();
                              updateBuyAmount();
                              updateSellAmount();
                              tokenRate = "";
                              setState(() {});
                              netSwapRoutes();

                              setState(() {});
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.all(2),
                              decoration: new BoxDecoration(
                                border: new Border.all(color: Color(0xFF000000).withAlpha(0), width: 1),
                                color: Color(0xFFF22B79).withAlpha(16),
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Image(
                                width: 30,
                                height: 30,
                                color: Color(0xFFF22B79),
                                image: AssetImage("images/ic_swap_vert.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, left: 18, right: 18),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "购买",
                              style: new TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                //                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          if (this.buyTokenAmount.isEmpty)
                            Container(
                              height: 20,
                              child: Lottie.asset(
                                'images/loading.json',
                              ),
                            ),
                          if (this.buyTokenAmount.isNotEmpty)
                            Container(
                              height: 20,
                              child: Text(
                                "余额: " + buyTokenAmount,
                                style: new TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff333333),
                                  //                                            fontWeight: FontWeight.w600,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sellFocusNode.unfocus();
                        buyFocusNode.unfocus();
                        showMaterialModalBottomSheet(
                            context: context,
                            expand: true,
                            enableDrag: false,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AeSelectTokenListPage(
                                  aeCount: AeHomePage.token,
                                  aeSelectTokenListCallBackFuture: (String? tokenName, String? tokenCount, String? tokenImage, String? tokenContract) {
                                    if (tokenContract == this.sellTokenAddress) {
                                      showToast("你不能兑换相同的积分");
                                      return;
                                    }
                                    this.buyTokenName = tokenName!;
                                    this.buyTokenImage = tokenImage!;
                                    this.buyTokenAddress = tokenContract!;

                                    this.buyTokenAmount = "";
                                    this.sellTextControllerNode.text = "";
                                    this.buyTextControllerNode.text = "";

                                    buttonText = "加载中...";
                                    isPairsLoading = true;
                                    setState(() {});

                                    updateBuyAmount();
                                    tokenRate = "";
                                    setState(() {});
                                    netSwapRoutes();

                                    return;
                                  },
                                )
//
                            );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, left: 18, right: 18),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  buyTokenImage,
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
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: Text(
                                    buyTokenName,
                                    style: new TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff333333),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              width: 20,
                              height: 20,
                              color: Color(0xff666666),
                              image: AssetImage("images/ic_swap_down.png"),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Container(
                                // height: 70,
                                //                      padding: EdgeInsets.only(left: 10, right: 10),
                                //边框设置
                                decoration: new BoxDecoration(
                                  color: Color.fromARGB(0, 237, 243, 247),
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  controller: buyTextControllerNode,
                                  focusNode: buyFocusNode,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入字母
                                    CustomTextFieldFormatter(digit: 6),
                                  ],

                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  style: TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
                                    fontSize: 26,
                                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0.00",
                                    // contentPadding: EdgeInsets.only(left: 10.0),
                                    contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(0, 255, 255, 255),
                                      ),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Color.fromARGB(0, 255, 255, 255)),
                                    ),
                                    border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.circular(10.0),
                                        ),
                                    hintStyle: TextStyle(
                                      fontSize: 26,
                                      color: Color(0xFF666666).withAlpha(85),
                                    ),
                                  ),
                                  cursorColor: Color(0xFFFC2365),
                                  cursorWidth: 2,
                                  //                                cursorRadius: Radius.elliptical(20, 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Color(0xFFF3F3F3),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (sellTextControllerNode.text.isNotEmpty && (!isPairsLoading && !isBalanceLoading && !isAllowanceLoading))
                      Container(
                        height: 20,
                        margin: const EdgeInsets.only(left: 18, right: 18),
                        alignment: Alignment.centerRight,
                        child: Text(
                          getLowAmount(),
                          style: new TextStyle(
                            fontSize: 14,
                            color: Color(0xff333333),
                            //                                            fontWeight: FontWeight.w600,
                            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                          ),
                        ),
                      ),
                    if (isPairsLoading | isBalanceLoading | isAllowanceLoading)
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 18, right: 18),
                                height: 50,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                                      backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFE61665).withAlpha(16),
                                      )),
                                  onPressed: () {},
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      buttonText,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color.fromARGB(112, 242, 43, 123)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if ((!isPairsLoading && !isBalanceLoading && !isAllowanceLoading))
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 18, right: 18),
                                height: 50,
                                child: TextButton(
                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white24), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))), backgroundColor: MaterialStateProperty.all(Color(0xFFFC2365))),
                                  onPressed: () {
                                    if (typeAllowance == 1) {
                                      if (sellTokenAddress.isEmpty) {
                                        aeDexSwapExactAeForTokens();
                                      }
                                      if (buyTokenAddress.isEmpty) {
                                        aeDexSwapExactTokensForAe();
                                      }
                                      if (sellTokenAddress.isNotEmpty && buyTokenAddress.isNotEmpty) {
                                        aeDexSwapExactTokensForTokens();
                                      }
                                    } else {
                                      aeAex9TokenCreateAllowance();
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          typeAllowance == 1 ? "开始兑换" : "授权",
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFFFFFFF)),
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
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12, left: 0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "价格",
                                    style: new TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                if (this.tokenRate.isEmpty)
                                  Container(
                                    height: 20,
                                    child: Lottie.asset(
                                      'images/loading.json',
                                    ),
                                  ),
                                if (this.tokenRate.isNotEmpty)
                                  Text(
                                    "1$sellTokenName ≈ $tokenRate$buyTokenName",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "滑点保护",
                                    style: new TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "5%",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                      ),
                                      // Container(
                                      //   child: TextButton(
                                      //     style: ButtonStyle(
                                      //         shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                                      //         minimumSize: MaterialStateProperty.all(Size(50, 32)),
                                      //         visualDensity: VisualDensity.compact,
                                      //         padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      //         backgroundColor: MaterialStateProperty.all(
                                      //           Color(0xFFE61665).withAlpha(16),
                                      //         )),
                                      //     onPressed: () {},
                                      //     child: Container(
                                      //       child: Text(
                                      //         "5%",
                                      //         maxLines: 1,
                                      //         style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFF22B79)),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "交易截止期限",
                                    style: new TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "30分钟",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                      ),
                                      // Container(
                                      //   child: TextButton(
                                      //     style: ButtonStyle(
                                      //         shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                                      //         minimumSize: MaterialStateProperty.all(Size(50, 32)),
                                      //         visualDensity: VisualDensity.compact,
                                      //         padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      //         backgroundColor: MaterialStateProperty.all(
                                      //           Color(0xFFE61665).withAlpha(16),
                                      //         )),
                                      //     onPressed: () {},
                                      //     child: Container(
                                      //       child: Text(
                                      //         "5%",
                                      //         maxLines: 1,
                                      //         style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFF22B79)),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "单次最大可兑换",
                                    style: new TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff666666),
                                      fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        AmountDecimal.parseDecimal(maxSellAmount.toString()) + sellTokenName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                                      ),
                                      // Container(
                                      //   child: TextButton(
                                      //     style: ButtonStyle(
                                      //         shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                                      //         minimumSize: MaterialStateProperty.all(Size(50, 32)),
                                      //         visualDensity: VisualDensity.compact,
                                      //         padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      //         backgroundColor: MaterialStateProperty.all(
                                      //           Color(0xFFE61665).withAlpha(16),
                                      //         )),
                                      //     onPressed: () {},
                                      //     child: Container(
                                      //       child: Text(
                                      //         "5%",
                                      //         maxLines: 1,
                                      //         style: TextStyle(fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto", color: Color(0xFFF22B79)),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 38,
                      decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 246, 247, 249),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Supported by",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xff666666), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(left: 7),
                            child: Image(
                              width: 20,
                              height: 20,
                              color: Color(0xff00ff9d),
                              image: AssetImage("images/ic_swap_superhero.png"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 7),
                            child: Text(
                              "SuperHero",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: Color(0xff333333), fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getLowAmount() {
    print(buyTextControllerNode.text);
    if (buyTextControllerNode.text.isEmpty) {
      return "";
    }
    return "滑点保护后最低将获得: " + AmountDecimal.parseDecimal((double.parse(buyTextControllerNode.text) * 0.95).toString()) + buyTokenName;
  }

  @override
  bool get wantKeepAlive => true;
}
