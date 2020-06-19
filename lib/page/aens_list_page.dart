import 'dart:async';

import 'package:box/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class AensListPage extends StatefulWidget {
  @override
  _AensListPageState createState() => _AensListPageState();
}

class _AensListPageState extends State<AensListPage> {
  // listview的控制器
  EasyRefreshController _controller = EasyRefreshController();

  var _isLoading = true;

  @override
  Future<void> initState() {
    super.initState();
//    getData();

    _controller.callRefresh();
    _controller.callLoad();
    netData();
  }

  Future<void> netData() async {
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: LoadingContainer(
            child: EasyRefresh(
              onRefresh: _onRefresh,
              onLoad: _onLoad,
              header: MaterialHeader(),
              footer: MaterialFooter(),
              controller: _controller,
              child: ListView.builder(
                itemBuilder: _renderRow,
                itemCount: 20,
              ),
            ),
            isLoading: _isLoading));
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
              print("item 点击");
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
                                'baidu.chain',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '距离结束8天',
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
                                '800AE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '地址: ak****qZdS',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
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
        Container(
            margin: const EdgeInsets.only(left: 18),
            height: 1.0,
            width: MediaQuery.of(context).size.width - 18,
            color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {});
    });
  }

  Future<void> _onLoad() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        _controller.finishRefresh(success: true);
        _controller.finishLoad(success: true, noMore: false);
      });
    });
  }
}
