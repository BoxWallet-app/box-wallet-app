import 'dart:async';
import 'dart:convert';

import 'package:box/dao/aeternity/aens_page_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/aens_page_model.dart';
import 'package:box/page/aeternity/ae_aens_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';
import '../../manager/wallet_coins_manager.dart';
import '../../model/aeternity/wallet_coins_model.dart';
import 'ae_home_page.dart';

class AeAensListPage extends StatefulWidget {
  final AensPageType? aensPageType;

  const AeAensListPage({Key? key, this.aensPageType}) : super(key: key);

  @override
  _AeAensListPageState createState() => _AeAensListPageState();
}

class _AeAensListPageState extends State<AeAensListPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  late Response aensResponse;
  late Map aensModel;

  @override
  void initState() {
    super.initState();
    netData();
  }

  Future<void> netData() async {
    try {
      _loadingType = LoadingType.loading;
      setState(() {});
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      AeHomePage.address = account!.address;
      if (widget.aensPageType == AensPageType.auction) {
        aensResponse = await Dio().get("https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/api/ae-aens-activity.json");
      }
      if (widget.aensPageType == AensPageType.price) {
        aensResponse = await Dio().get("https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/api/ae-aens-price.json");
      }
      if (widget.aensPageType == AensPageType.over) {
        aensResponse = await Dio().get("https://oss-box-files.oss-cn-hangzhou.aliyuncs.com/api/ae-aens-over.json");
      }
      if (widget.aensPageType == AensPageType.my_auction) {
        aensResponse = await Dio().get("http://127.0.0.1:53160/aens/my/activity?address=" + AeHomePage.address!);
      }
      if (widget.aensPageType == AensPageType.my_over) {
        aensResponse = await Dio().get("http://127.0.0.1:53160/aens/my/over?address=" + AeHomePage.address!);
      }

      print(aensResponse.toString());

      if (aensResponse.statusCode != 200) {
        _loadingType = LoadingType.error;
        setState(() {});
        return;
      }
      aensModel = jsonDecode(aensResponse.toString());
      print(aensModel);
      if (aensModel['data']['aens'].length == 0) {
        _loadingType = LoadingType.no_data;
        setState(() {});
        return;
      }
      _loadingType = LoadingType.finish;
      setState(() {});
    } catch (e) {
      _loadingType = LoadingType.error;
      setState(() {});
      return;
    }

    // AensPageDao.fetch(widget.aensPageType, page).then((AensPageModel model) {
    //   if (!mounted) {
    //     return;
    //   }
    //   _loadingType = LoadingType.finish;
    //   if (model.code == 200) {
    //     if (page == 1) {
    //       _aensPageModel = model;
    //     } else {
    //       _aensPageModel!.data!.addAll(model.data!);
    //     }
    //   }
    //   if (_aensPageModel!.data!.length == 0) {
    //     _loadingType = LoadingType.no_data;
    //   }
    //   page++;
    //   _controller.finishRefresh();
    //   _controller.finishLoad();
    //   if (model.data!.length < 20) {
    //     _controller.finishLoad(noMore: true);
    //   }
    //   setState(() {});
    // }).catchError((e) {
    //   if (page == 1 && (_aensPageModel == null || _aensPageModel!.data == null)) {
    //     setState(() {
    //       _loadingType = LoadingType.error;
    //     });
    //   } else {
    //     Fluttertoast.showToast(msg: "error", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: LoadingWidget(
        child: EasyRefresh(
          onRefresh: _onRefresh,
          header: BoxHeader(),
          controller: _controller,
          child: ListView.builder(
            itemBuilder: _renderRow,
            itemCount: _loadingType == LoadingType.finish ? aensModel['data']['aens'].length : 0,
          ),
        ),
        type: _loadingType,
        onPressedError: () {
          setState(() {
            _loadingType = LoadingType.loading;
          });
          netData();
        },
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if (index < list.length) {
    return Container(margin: EdgeInsets.only(left: 15, right: 15, top: 12), child: buildColumn(context, index));
  }

  Column buildColumn(BuildContext context, int position) {
    print(aensModel['data']['aens'][position]['name']);
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              print(aensModel['data']['currentHeight']);
              print(aensModel['data']['aens'][position]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AeAensDetailPage(
                            currentHeight: aensModel['data']['currentHeight'],
                            aensDetail: aensModel['data']['aens'][position],
                          )));
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                aensModel['data']['aens'][position]['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              setNameTime(position),
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
                      new Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                aensModel['data']['aens'][position]['price'] + " AE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              S.of(context).aens_list_page_item_address + ": " + Utils.formatAddress(aensModel['data']['aens'][position]['owner']),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(left: 2.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String setNameTime(int position) {
    switch (widget.aensPageType!) {
      case AensPageType.auction:
      case AensPageType.price:
      case AensPageType.my_auction:
        return S.of(context).aens_list_page_item_time_end + ': ' + Utils.formatHeight(context, aensModel['data']['currentHeight'], aensModel['data']['aens'][position]['endHeight']);
      case AensPageType.over:
      case AensPageType.my_over:
        return S.of(context).aens_list_page_item_time_over + ' :' + Utils.formatHeight(context, aensModel['data']['currentHeight'], aensModel['data']['aens'][position]['overHeight']);
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      netData();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
