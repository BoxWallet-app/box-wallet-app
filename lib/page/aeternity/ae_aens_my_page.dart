import 'package:box/dao/aeternity/aens_page_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/aeternity/dialog_aens_renew.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../../main.dart';
import 'ae_aens_list_page.dart';
import 'ae_aens_page.dart';
import 'ae_aens_register.dart';

class AeAensMyPage extends StatefulWidget {
  @override
  _AeAensMyPageState createState() => _AeAensMyPageState();
}

class _AeAensMyPageState extends State<AeAensMyPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool isShowMoreBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        if (tabController.index.toDouble() == tabController.animation?.value) {
          switch (tabController.index) {
            case 0:
              isShowMoreBtn = false;
              break;
            case 1:
              isShowMoreBtn = true;
              break;
          }
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFfafbfc),
          elevation: 0,
          // 隐藏阴影
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            if (isShowMoreBtn)
              MaterialButton(
                minWidth: 10,
                child: Text(
                  S.of(context).dialog_aens_renew_title,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      enableDrag: true,
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => WillPopScope(
                            onWillPop: () async => false, //防止点击返回按键
                            child: AnimatedPadding(
                              padding: MediaQuery.of(context).viewInsets,
                              // 我们可以根据这个获取需要的padding，解决showModalBottomSheet被软键盘遮盖问题
                              duration: const Duration(milliseconds: 100),
                              child: DialogAensRenew(),
                            ),
                          ));
                },
              ),
          ],
          title: Text(
            S.of(context).aens_my_page_title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
            ),
          ),
          centerTitle: true,

          bottom: TabBar(
            controller: tabController,
            unselectedLabelColor: Colors.black54,
            indicatorSize: TabBarIndicatorSize.label,
            dragStartBehavior: DragStartBehavior.down,
            indicator: UnderlineIndicator(
                strokeCap: StrokeCap.round,
                borderSide: BorderSide(
                  color: Color(0xFFFC2365),
                  width: 2,
                ),
                insets: EdgeInsets.only(bottom: 5)),
            tabs: <Widget>[
              Tab(
                  icon: Text(
                S.of(context).aens_my_page_title_tab_1,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              )),
              Tab(
                  icon: Text(
                S.of(context).aens_my_page_title_tab_2,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontFamily: BoxApp.language == "cn" ? "Roboto" : "Roboto",
                ),
              )),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            AeAensListPage(aensPageType: AensPageType.my_auction),
            AeAensListPage(aensPageType: AensPageType.my_over),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AeAensRegister()));
          },
          child: new Icon(Icons.add),
          elevation: 3.0,
          highlightElevation: 2.0,
          backgroundColor: Color(0xFFFC2365),
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),
      ),
    );
  }
}
