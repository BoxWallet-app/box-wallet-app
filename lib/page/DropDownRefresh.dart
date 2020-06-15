import 'package:flutter/material.dart';

class DropDownRefresh extends StatefulWidget {
  @override
  _DropDownRefreshState createState() => _DropDownRefreshState();
}

class _DropDownRefreshState extends State {
  // 列表要展示的数据
  List list = new List();
  // listview的控制器
  ScrollController _scrollController = ScrollController();
  // 页数
  int page = 0;
  // 是否正在加载
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }
  // 初始化list数据 加延时模仿网络请求
  Future getData() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        list = List.generate(15, (i) => '哈喽,我是原始数据 $i');
      });
    });
  }

  // 下拉刷新方法,为list重新赋值
  Future _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        list = List.generate(20, (i) => '哈喽,我是新刷新的 $i');
      });
    });
  }
  Widget _renderRow(BuildContext context, int index) {
    if (index < list.length) {
      return ListTile(
        title: Text(list[index]),
      );
    }
    return _getMoreWidget();
  }

  // 加载更多时显示的组件,给用户提示
  Widget _getMoreWidget() {
    print('给用户提示');
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  // 上拉加载更多
  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () {
        print('加载更多');
        setState(() {
          list.addAll(List.generate(5, (i) => '第$page次上拉来的数据'));
          page++;
          isLoading = false;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemBuilder: _renderRow,
          itemCount: list.length + 1,
          controller: _scrollController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}