import 'dart:async';
import 'dart:convert';

import 'package:box/dao/aeternity/aens_page_dao.dart';
import 'package:box/event/language_event.dart';
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
import 'aens_sell_put_page.dart';

class MySellAeAensListPage extends StatefulWidget {

  const MySellAeAensListPage({Key? key}) : super(key: key);

  @override
  _MySellAeAensListPageState createState() => _MySellAeAensListPageState();
}

class _MySellAeAensListPageState extends State<MySellAeAensListPage> with AutomaticKeepAliveClientMixin {
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
      setState(() {});
      Account? account = await WalletCoinsManager.instance.getCurrentAccount();
      AeHomePage.address = account!.address;

      aensResponse = await Dio().get("http://47.52.111.71:8000/aens/my/over?address=" + AeHomePage.address!);

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          S.of(context).ae_aens_select_title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
          ),

        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () {
            Navigator.of(context).pop();
//              Navigator.pop(context);
          },
        ),
      ),
      body: LoadingWidget(
        child: Column(
          children: [

            Expanded(
              child: EasyRefresh(
                onRefresh: _onRefresh,
                header: BoxHeader(),
                controller: _controller,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 30),
                  itemBuilder: _renderRow,
                  itemCount: _loadingType == LoadingType.finish ? aensModel['data']['aens'].length : 0,
                ),
              ),
            ),
          ],
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
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            onTap: () {
              Navigator.of(context).pop();
              print(aensModel['data']['currentHeight']);
              print(aensModel['data']['aens'][position]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AensSellPutPage(
                            name: aensModel['data']['aens'][position]['name'],
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
//                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              setNameTime(position),
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
//                       new Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             /*2*/
//                             Container(
//                               padding: const EdgeInsets.only(bottom: 8),
//                               child: Text(
//                                 aensModel['data']['aens'][position]['price'] + " AE",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
// //                                  fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               S.of(context).aens_list_page_item_address + ": " + Utils.formatAddress(aensModel['data']['aens'][position]['owner']),
//                               style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 14,
//                                 fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
//                               ),
//                             ),
//                           ],
//                         ),
//                         margin: const EdgeInsets.only(left: 2.0),
//                       ),
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
    return S.of(context).aens_list_page_item_time_over + ' :' + Utils.formatHeight(context, aensModel['data']['currentHeight'], aensModel['data']['aens'][position]['overHeight']);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      netData();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
