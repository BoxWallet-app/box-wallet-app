import 'dart:ui';

import 'package:box/dao/aeternity/wetrue_list_dao.dart';
import 'package:box/dao/aeternity/wetrue_praise_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/WetrueListModel.dart';
import 'package:box/page/general/photo_page.dart';
import 'package:box/utils/RelativeDateFormat.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/wetrue_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class AeWeTrueListPage extends StatefulWidget {
  final int? type;

  const AeWeTrueListPage({Key? key, this.type}) : super(key: key);

  @override
  _AeWeTrueListPageState createState() => _AeWeTrueListPageState();
}

class _AeWeTrueListPageState extends State<AeWeTrueListPage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  WetrueListModel? wetrueListModels;
  EasyRefreshController controller = EasyRefreshController();
  var loadingType = LoadingType.loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });

    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfffafafa),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height -
                40 -
                10 -
                MediaQueryData.fromWindow(window).padding.top -
                kToolbarHeight,
            child: LoadingWidget(
              type: loadingType,
              onPressedError: () {
                _onRefresh();
                return;
              },
              child: Container(
                child: AnimationLimiter(
                  child: EasyRefresh(
                    enableControlFinishRefresh: true,
                    controller: controller,
                    header: BoxHeader(),
                    onRefresh: _onRefresh,
                    onLoad: _onLoad,
                    child: ListView.builder(
                      shrinkWrap: true, // 关键
                      itemCount: wetrueListModels == null
                          ? 0
                          : wetrueListModels!.data!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getItem(context, index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    page = 1;
    var model;
    model = await WeTrueListDao.fetch(widget.type, page);
    if (wetrueListModels != null) {
      wetrueListModels = null;
    }
    if (model != null || model.code == 200) {
      wetrueListModels = model;
      loadingType = LoadingType.finish;
      if (wetrueListModels!.data == null || wetrueListModels!.data!.size == 0) {
        loadingType = LoadingType.no_data;
      }
    } else {
      loadingType = LoadingType.error;
    }

    controller.finishRefresh();
    page++;
    setState(() {});
  }

  Future<void> _onLoad() async {
    WetrueListModel model;
    model = await WeTrueListDao.fetch(widget.type, page);
    if (wetrueListModels == null) {
      return;
    }
    if (model != null || model.code == 200) {
      wetrueListModels!.data!.data!.addAll(model.data!.data!);
      loadingType = LoadingType.finish;
      if (wetrueListModels!.data == null || wetrueListModels!.data!.size == 0) {
        loadingType = LoadingType.no_data;
      }
    } else {
      loadingType = LoadingType.error;
    }

    controller.finishRefresh();
    page++;
    setState(() {});
  }

  Widget getItem(BuildContext context, int index) {
    return Material(
      child: InkWell(
        onTap: () {
//          Navigator.push(context, SlideRoute( TxDetailPage(recordData: contractRecordModel.data[index])));
//           showMaterialModalBottomSheet(
//               expand: false,
//               context: context,
//               enableDrag: true,
//               backgroundColor:
//               Colors.transparent.withAlpha(10),
//               builder: (context) => WeTrueCommentWidget(
//                 hash: wetrueListModels
//                     .data.data[index].hash,
//               ));
//
        },
        child: Container(
          color: Color(0xFFfafbfc),
          child: Container(
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              //设置四周圆角 角度
//              borderRadius: BorderRadius.all(Radius.circular(15.0)),

              //设置四周边框
            ),
            margin: index == wetrueListModels!.data!.size! - 1
                ? EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 5)
                : EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 5),
            padding: EdgeInsets.only( top: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(

                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15,),
                        width: MediaQuery.of(context).size.width - 18 * 2,
                        child: Row(
                          children: [
                            Stack(
                              children: <Widget>[
                                ClipOval(
                                  child: Image.network(
                                      wetrueListModels!
                                          .data!.data![index].users!.portrait!,
                                      width: 45,
                                      height: 45),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: ClipOval(
                                    child: Container(
                                      width: 18,
                                      color: Colors.amberAccent,
                                      height: 18,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: ClipOval(
                                    child: Container(
                                      width: 16,
                                      color: Colors.red,
                                      height: 16,
                                      child: Center(
                                        child: Text(
                                          "v" +
                                              wetrueListModels!.data!.data![index]
                                                  .users!.userActive
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 9),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      wetrueListModels!.data!.data![index].users!
                                                  .nickname ==
                                              ""
                                          ? "匿名用户 " +
                                              "(" +
                                              Utils.formatAddress(
                                                  wetrueListModels!
                                                      .data!
                                                      .data![index]
                                                      .users!
                                                      .userAddress) +
                                              ")"
                                          : wetrueListModels!.data!.data![index]
                                                  .users!.nickname! +
                                              " (" +
                                              Utils.formatAddress(
                                                  wetrueListModels!
                                                      .data!
                                                      .data![index]
                                                      .users!
                                                      .userAddress) +
                                              ")",
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(156),
                                          fontSize: 15,
                                          fontFamily: BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu"),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: Text(
                                      RelativeDateFormat.format(wetrueListModels!
                                              .data!.data![index].utcTime!) +
                                          " 来自:" +
                                          wetrueListModels!
                                              .data!.data![index].source!,
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(100),
                                          fontSize: 13,
                                          fontFamily: BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      (wetrueListModels!.data!.data![index].read! /
                                                  1000)
                                              .toStringAsFixed(1) +
                                          "k",
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(100),
                                          fontSize: 13,
                                          fontFamily: BoxApp.language == "cn"
                                              ? "Ubuntu"
                                              : "Ubuntu"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
//                      Container(
//                        child: Text(
//                          "大家早上好，ae果然没让人失望，真的很稳！😂",
//                          style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                        ),
//                      ),
                      Wrap(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 15,top: 10),
                            width: MediaQuery.of(context).size.width - (18 * 2),
                            child: Text(
                              wetrueListModels!.data!.data![index].payload!
                                  .replaceAll("<br>", "\r\n"),
                              strutStyle: StrutStyle(
                                  forceStrutHeight: true,
                                  height: 0.8,
                                  leading: 1.2,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                  fontFamily: BoxApp.language == "cn"
                                      ? "Ubuntu"
                                      : "Ubuntu"),
                            ),
                          ),
                        ],
                      ),

                      if (wetrueListModels!.data!.data![index].imgTx != null &&
                          wetrueListModels!.data!.data![index].imgTx != "")
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhotoPage(
                                        address: wetrueListModels!
                                            .data!.data![index].imgTx)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15,top: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.1),
                              child: Image.network(
                                wetrueListModels!.data!.data![index].imgTx!,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Container(
                                    width: (MediaQuery.of(context).size.width -
                                            (18 * 2 + 16 * 2)) /
                                        2,
                                    height: (MediaQuery.of(context).size.width -
                                            (18 * 2 + 16 * 2)) /
                                        2,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Color(0xFFF22B79)),
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                width: (MediaQuery.of(context).size.width -
                                        (18 * 2 + 16 * 2)) /
                                    2,
                                height: (MediaQuery.of(context).size.width -
                                        (18 * 2 + 16 * 2)) /
                                    2,
                              ),
                            ),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 18),
                        width: (MediaQuery.of(context).size.width),
                        color: Colors.grey.withAlpha(40),
                        height: 1,
                      ),
                      Container(
                        // padding: EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width ,
                        child: Row(
                          children: [
//                            Expanded(child: Container()),
                            Expanded(
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {

                                    Clipboard.setData(ClipboardData(
                                        text: "以下内容来自AE区块链：\n\n" +wetrueListModels!.data!.data![index].payload!
                                            .replaceAll("<br>", "\r\n") +
                                            "\n\n" +
                                            "我在WeTrue发现一个有趣的内容一起来看看吧~" +
                                            "\n" +
                                            "https://wetrue.io/#/pages/index/detail?hash=" +
                                            wetrueListModels!.data!.data![index].hash!));
                                    EasyLoading.showToast('复制成功,请打开其他应用粘贴',
                                        duration: Duration(seconds: 1));

                                  },
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share_outlined,
                                            color: Colors.grey,
                                            size: 21,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              wetrueListModels!.data!.data![index]
                                                          .commentNumber ==
                                                      0
                                                  ? ""
                                                  : wetrueListModels!.data!
                                                      .data![index].commentNumber
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {

                                    showMaterialModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        enableDrag: true,
                                        backgroundColor:
                                            Colors.transparent.withAlpha(10),
                                        builder: (context) => WeTrueCommentWidget(
                                              hash: wetrueListModels!
                                                  .data!.data![index].hash,
                                            ));
                                  },
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.chat_bubble_outline,
                                            color: Colors.grey,
                                            size: 21,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              wetrueListModels!.data!.data![index]
                                                          .commentNumber ==
                                                      0
                                                  ? ""
                                                  : wetrueListModels!.data!
                                                      .data![index].commentNumber
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Material(
                                child: Container(
                                  color: Colors.white,
                                  height: 40,
                                  margin: EdgeInsets.only(left: 0, right: 0),
                                  alignment: Alignment.center,
                                  child: LikeButton(
                                    size: 25,
                                    isLiked: wetrueListModels!
                                        .data!.data![index].isPraise,
                                    circleColor: CircleColor(
                                        start: Color(0xFFF22B79),
                                        end: Color(0xFFF22B79)),
                                    bubblesColor: BubblesColor(
                                      dotPrimaryColor: Color(0xFFF22B79),
                                      dotSecondaryColor: Color(0xFFF22B79),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: isLiked
                                            ? Color(0xFFF22B79)
                                            : Colors.grey,
                                        size: 25,
                                      );
                                    },
                                    onTap: (isLiked) async {
//    WeTruePraiseDao.fetch(hash)   We
                                      var weTruePraiseModel =
                                          await WeTruePraiseDao.fetch(
                                              wetrueListModels!
                                                  .data!.data![index].hash);
                                      wetrueListModels!.data!.data![index].isPraise =
                                          weTruePraiseModel.data!.isPraise;
                                      return weTruePraiseModel.data!.isPraise;
                                    },
                                    likeCount:
                                        wetrueListModels!.data!.data![index].praise,
                                    countBuilder:
                                        (int? count, bool isLiked, String text) {
                                      var color = isLiked
                                          ? Color(0xFFF22B79)
                                          : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          "",
                                          style: TextStyle(color: color),
                                        );
                                      } else
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      return result;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        width: (MediaQuery.of(context).size.width),
                        color: Colors.grey.withAlpha(40),
                        height: 1,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
//    WeTruePraiseDao.fetch(hash)
    return !isLiked;
  }


  void showChainLoading() {
    showGeneralDialog(useRootNavigator:false,
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

  Material buildItem(BuildContext context, String content, String assetImage,
      GestureTapCallback tab,
      {bool isLine = true}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 13),
                child: Row(
                  children: <Widget>[
//                    Image(
//                      width: 40,
//                      height: 40,
//                      image: AssetImage(assetImage),
//                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily:
                              BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 28,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              if (isLine)
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width - 30,
                      color: Color(0xFFfafbfc)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderItem(
      String content, String image, GestureTapCallback tapCallback) {
    return Material(
        color: Color(0xFFFC2365),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onTap: tapCallback,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Image(
                      width: 40,
                      height: 40,
                      image: AssetImage(image),
                    ),
                  ),
                  Text(
                    content,
                    style: new TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void showErrorDialog(BuildContext buildContext, String content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content),
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
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
          title: Text(S.current.dialog_hint_hash),
          content: Text(tx),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_copy,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: tx));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_dismiss,
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
}
