import 'dart:async';

import 'package:box/dao/aens_page_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aens_page_model.dart';
import 'package:box/page/aeternity/ae_aens_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class AeAensListPage extends StatefulWidget {
  final AensPageType aensPageType;

  const AeAensListPage({Key key, this.aensPageType}) : super(key: key);

  @override
  _AeAensListPageState createState() => _AeAensListPageState();
}

class _AeAensListPageState extends State<AeAensListPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  AensPageModel _aensPageModel;
  int page = 1;

  @override
  Future<void> initState() {
    super.initState();
    _controller.callRefresh();
    _controller.callLoad();
    _onLoad();
  }

  Future<void> netData() async {
    AensPageDao.fetch(widget.aensPageType, page).then((AensPageModel model) {
      if (!mounted) {
        return;
      }
      _loadingType = LoadingType.finish;
      if (model.code == 200) {
        if (page == 1) {
          _aensPageModel = model;
        } else {
          _aensPageModel.data.addAll(model.data);
        }
      }
      if(_aensPageModel.data.length ==0) {
        _loadingType = LoadingType.no_data;
      }
      page++;
      _controller.finishRefresh();
      _controller.finishLoad();
      if (model.data.length < 20) {
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    }).catchError((e) {
      if (page == 1 && (_aensPageModel == null || _aensPageModel.data == null)) {
        setState(() {
          _loadingType = LoadingType.error;
        });
      } else {
        Fluttertoast.showToast(msg: "error", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      }
    });
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
          onLoad: _onLoad,
          header: BoxHeader(),

          footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
          controller: _controller,
          child: ListView.builder(
            itemBuilder: _renderRow,
            itemCount: _aensPageModel == null ? 0 : _aensPageModel.data.length,
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

  Column buildColumn(BuildContext context, int position) {
    return Column(
      children: <Widget>[
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AeAensDetailPage(
                            name: _aensPageModel.data[position].name,
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
                                _aensPageModel.data[position].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              setNameTime(position),
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
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
                                Utils.formatPrice(_aensPageModel.data[position].currentPrice) + " AE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                                S.of(context).aens_list_page_item_address+": " + Utils.formatAddress(_aensPageModel.data[position].owner),
                              style: TextStyle(color: Colors.black54, fontSize: 14,fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
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
        Container(margin: const EdgeInsets.only(left: 18), height: 1.0, width: MediaQuery.of(context).size.width - 18, color: Color(0xFFEEEEEE),),
      ],
    );
  }

  String setNameTime(int position) {
    switch (widget.aensPageType) {
      case AensPageType.auction:
      case AensPageType.price:
      case AensPageType.my_auction:
        return S.of(context).aens_list_page_item_time_end+': ' + Utils.formatHeight(context,_aensPageModel.data[position].currentHeight, _aensPageModel.data[position].endHeight);
      case AensPageType.over:
      case AensPageType.my_over:
        return S.of(context).aens_list_page_item_time_over+' :' + Utils.formatHeight(context,_aensPageModel.data[position].currentHeight, _aensPageModel.data[position].overHeight);
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      page = 1;
      netData();
    });
  }

  Future<void> _onLoad() async {
    netData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
