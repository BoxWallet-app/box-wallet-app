import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/token_list_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/token_list_model.dart';
import 'package:box/page/token_add_page.dart';
import 'package:box/widget/ae_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import 'home_page_v2.dart';

class TokenListPage extends StatefulWidget {
  @override
  _TokenListPathState createState() => _TokenListPathState();
}

class _TokenListPathState extends State<TokenListPage> {
  var loadingType = LoadingType.loading;
  TokenListModel tokenListModel;

  Future<void> _onRefresh() async {
    TokenListDao.fetch(HomePageV2.address).then((TokenListModel model) {
      if (model != null || model.code == 200) {
        tokenListModel = model;
        loadingType = LoadingType.finish;
        setState(() {});
      } else {
        tokenListModel = null;
        loadingType = LoadingType.error;
        setState(() {});
      }
    }).catchError((e) {
      print(e);
      loadingType = LoadingType.error;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        elevation: 0,
        // 隐藏阴影
        title: Text(
          "代币",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
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
        actions: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              onTap: () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (context, anim1, anim2) {},
                    barrierColor: Colors.grey.withOpacity(.4),
                    barrierDismissible: true,
                    barrierLabel: "",
                    transitionDuration: Duration(milliseconds: 400),
                    transitionBuilder: (context, anim1, anim2, child) {
                      final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
                      return Transform(
                          transform: Matrix4.translationValues(0.0, 0, 0.0),
                          child: Opacity(
                              opacity: anim1.value,
                              // ignore: missing_return
                              child: Material(
                                type: MaterialType.transparency, //透明类型
                                child: Center(
                                  child: Container(
                                    height: 470,
                                    width: MediaQuery.of(context).size.width - 40,
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    decoration: ShapeDecoration(
                                      color: Color(0xffffffff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width - 40,
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: BorderRadius.all(Radius.circular(60)),
                                              onTap: () {
                                                Navigator.pop(context); //关闭对话框
                                                // ignore: unnecessary_statements
//                                  widget.dismissCallBackFuture("");
                                              },
                                              child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20, right: 20),
                                          child: Text(
                                            "上架说明",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 270,
                                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                                          child: SingleChildScrollView(
                                            child: Container(
                                              child: Text(
                                                  "通过 aeasy.io 可以免费创建AEX9协议代币。代币列表为了增加用户体验防止代币乱飞所设置的优秀代币，优秀代币需要进行审核\n上币流程：上币费用为10000AE 及 1000ABC，该费用作为代币锁仓费用，代币上任何中心化交易所或者退市即可退回质押代币\n下架流程：下架代币需要回收市场上全部代币，代币价格按照所采价值进行回收。或者代币长时间不进行流动。形成死币\n上币申请资料请准备 合约地址、代币名称，代币logo，发送邮件到293122529@qq.com,",
                                                style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", letterSpacing: 2, height: 2),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Container(
                                          margin: const EdgeInsets.only(top: 30, bottom: 20),
                                          child: ArgonButton(
                                            height: 40,
                                            roundLoadingShape: true,
                                            width: 120,
                                            onTap: (startLoading, stopLoading, btnState) async {
                                              Navigator.pop(context); //关闭对话框
                                            },
                                            child: Text(
                                              S.of(context).dialog_statement_btn,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                              ),
                                            ),
                                            loader: Container(
                                              padding: EdgeInsets.all(10),
                                              child: SpinKitRing(
                                                lineWidth: 4,
                                                color: Colors.white,
                                                // size: loaderWidth ,
                                              ),
                                            ),
                                            borderRadius: 30.0,
                                            color: Color(0xFFFC2365),
                                          ),
                                        ),

//          Text(text),
                                      ],
                                    ),
                                  ),
                                ),
                              )));
                    });
              },
              child: Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(15),
                child: Image(
                  width: 36,
                  height: 36,
                  color: Colors.black,
                  image: AssetImage('images/token_add.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: LoadingWidget(
        type: loadingType,
        onPressedError: () {
          _onRefresh();
        },
        child: EasyRefresh(
          header: AEHeader(),
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: tokenListModel == null ? 0 : tokenListModel.data.length,
            itemBuilder: (BuildContext context, int index) {
              return itemListView(context, index);
            },
          ),
        ),
      ),
    );
  }

  Material itemListView(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Container(
          child: Row(
            children: [
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 0, left: 15),
                      child: Row(
                        children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),

                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
//                                                      shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                tokenListModel.data[index].image,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8, right: 18),
                            child: Text(
                              tokenListModel.data[index].name,
                              style: new TextStyle(
                                fontSize: 20,
                                color: Color(0xff333333),
//                                            fontWeight: FontWeight.w600,
                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            tokenListModel.data[index].count,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 24, color: Color(0xff333333), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
    );
  }
}
