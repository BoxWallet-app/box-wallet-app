import 'dart:async';

import 'package:box/dao/aens_page_dao.dart';
import 'package:box/model/aens_page_model.dart';
import 'package:box/page/aens_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AensListPage extends StatefulWidget {
  final AensPageType aensPageType;

  const AensListPage({Key key, this.aensPageType}) : super(key: key);

  @override
  _AensListPageState createState() => _AensListPageState();
}

class _AensListPageState extends State<AensListPage> with AutomaticKeepAliveClientMixin {
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
      _loadingType = LoadingType.finish;
      if (model.code == 200) {
        if (page == 1) {
          _aensPageModel = model;
        } else {
          _aensPageModel.data.addAll(model.data);
        }
      }
      page++;
      _controller.finishRefresh();
      _controller.finishLoad();
      if (model.data.length < 20) {
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    }).catchError((e) {
      if (page == 1 && _aensPageModel.data == null)
        setState(() {
          _loadingType = LoadingType.error;
        });
      Fluttertoast.showToast(msg: "网络错误", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
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
          header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
          footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFE71766))),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => AensDetailPage()));
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              setNameTime(position),
                              style: TextStyle(
                                color: Colors.black54,
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
                                Utils.formatPrice(_aensPageModel.data[position].currentPrice) + "AE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "地址: " + Utils.formatAddress(_aensPageModel.data[position].owner),
                              style: TextStyle(color: Colors.black54, fontSize: 14),
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
        Container(margin: const EdgeInsets.only(left: 18), height: 1.0, width: MediaQuery.of(context).size.width - 18, color: Color(0xFFEEEEEE)),
      ],
    );
  }

  String setNameTime(int position) {
    switch (widget.aensPageType) {
      case AensPageType.auction:
      case AensPageType.price:
      case AensPageType.my_auction:
        return '距离结束: ' + Utils.formatHeight(_aensPageModel.data[position].currentHeight, _aensPageModel.data[position].endHeight);
      case AensPageType.over:
      case AensPageType.my_over:
        return '距离到期 :' + Utils.formatHeight(_aensPageModel.data[position].currentHeight, _aensPageModel.data[position].overHeight);
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      page = 1;
      netData();
    });
  }

  Future<void> _onLoad() async {
    await Future.delayed(Duration(seconds: 1), () {
      netData();
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
