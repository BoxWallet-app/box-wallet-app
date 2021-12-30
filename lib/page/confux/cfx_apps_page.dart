// import 'dart:io';
// import 'dart:ui';
//
// import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
// import 'package:box/dao/aeternity/banner_dao.dart';
// import 'package:box/dao/conflux/cfx_dapp_list_dao.dart';
// import 'package:box/event/language_event.dart';
// import 'package:box/generated/l10n.dart';
// import 'package:box/manager/plugin_manager.dart';
// import 'package:box/model/aeternity/banner_model.dart';
// import 'package:box/model/conflux/cfx_dapp_list_model.dart';
// import 'package:box/page/confux/cfx_rpc_page.dart';
// import 'package:box/utils/utils.dart';
// import 'package:box/widget/box_header.dart';
// import 'package:box/widget/chain_loading_widget.dart';
// import 'package:box/widget/custom_route.dart';
// import 'package:box/widget/loading_widget.dart';
// import 'package:box/widget/pay_password_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../main.dart';
// import 'cfx_token_list_page.dart';
//
// class CfxAppsPage extends StatefulWidget {
//   @override
//   _CfxAppsPageState createState() => _CfxAppsPageState();
// }
//
// class _CfxAppsPageState extends State<CfxAppsPage> with AutomaticKeepAliveClientMixin {
//   BannerModel bannerModel;
//   DappListModel cfxDappListModel;
//   List<Widget> childrens = List<Widget>();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     netDapp();
//   }
//
//   Future<void> _onRefresh() async {
//     netDapp();
//   }
//
//   void netDapp() {
//     CfxDappListDao.fetch(BoxApp.language).then((DappListModel model) {
//       cfxDappListModel = model;
//       updateData();
//       setState(() {});
//     }).catchError((e) {
//       //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//     });
//   }
//
//   void updateData() {
//     if (cfxDappListModel == null) {
//       return;
//     }
//     typeLoading = LoadingType.finish;
//     childrens.clear();
//     for (var i = 0; i < cfxDappListModel.data.length; i++) {
//       var groupTitle = getGroupTitle(cfxDappListModel.data[i].type);
//       childrens.add(groupTitle);
//       for (var j = 0; j < cfxDappListModel.data[i].dataList.length; j++) {
//         var childItem = getChildItem(cfxDappListModel.data[i].dataList[j]);
//         childrens.add(childItem);
//       }
//     }
//   }
//
//   void netBanner() {
//     BannerDao.fetch().then((BannerModel model) {
//       bannerModel = model;
//       setState(() {});
//     }).catchError((e) {
//       //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//     });
//   }
//
//   var typeLoading = LoadingType.loading;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFfafbfc),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFfafbfc),
//         // 隐藏阴影
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//             size: 17,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           S.of(context).CfxDappPage_app,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//             fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
//           ),
//         ),
//         centerTitle: true,
//         actions: <Widget>[
//           MaterialButton(
//             minWidth: 10,
//             child: new Text(
//               S.of(context).CfxDappPage_app_more,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//               ),
//             ),
//             onPressed: () async {
//
//               String url = "https://123cfx.com/";
//               if (Platform.isAndroid) {
//                 String resultString;
//                 try {
//                   resultString = await PluginManager.pushCfxWebViewActivity({'url': url, 'address': await BoxApp.getAddress(), 'language': await BoxApp.getLanguage(), 'signingKey': await BoxApp.getSigningKey()});
//                 } on PlatformException {
//                 }
//                 return;
//               }
//
//               Navigator.push(
//                   navigatorKey.currentState.overlay.context,
//                   MaterialPageRoute(
//                       builder: (context) => CfxRpcPage(
//                         url: url,
//                       )));
//
//             },
//           ),
//         ],
//       ),
//       body: LoadingWidget(
//         type:typeLoading,
//         child: Container(
//             child: EasyRefresh(
//           header: BoxHeader(),
//           onRefresh: _onRefresh,
//               child: Column(
//                 children: AnimationConfiguration.toStaggeredList(
//                   duration: const Duration(milliseconds: 375),
//                   childAnimationBuilder: (widget) => SlideAnimation(
//                     verticalOffset: 50.0,
//                     child: FadeInAnimation(
//                       child: widget,
//                     ),
//                   ),
//                   children: [
//
//                     Column(
//                       children: childrens,
//                     ),
//
//                     Container(
//                       height: MediaQueryData.fromWindow(window).padding.bottom+12,
//                     ),
//                    ],
//                 ),
//               ),
//
//         )),
//       ),
//     );
//   }
//
//   Container getChildItem(DataList data) {
//     return Container(
//       alignment: Alignment.centerLeft,
//       margin: EdgeInsets.only(left: 15, right: 15, bottom: 12),
//       //边框设置
//       decoration: new BoxDecoration(
//         color: Color(0xE6FFFFFF),
//         //设置四周圆角 角度
//         borderRadius: BorderRadius.all(Radius.circular(30.0)),
//       ),
//       child: Material(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         color: Colors.white,
//         child: InkWell(
//           borderRadius: BorderRadius.all(Radius.circular(15)),
//           child: Column(
//             children: [
//               InkWell(
//                 borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                 onTap: () async {
//                   showGeneralDialog(useRootNavigator:false,
//                       context: context,
//                       pageBuilder: (context, anim1, anim2) {},
//                       //barrierColor: Colors.grey.withOpacity(.4),
//                       barrierDismissible: true,
//                       barrierLabel: "",
//                       transitionDuration: Duration(milliseconds: 0),
//                       transitionBuilder: (context, anim1, anim2, child) {
//                         final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
//                         return Transform(
//                             transform: Matrix4.translationValues(0.0, 0, 0.0),
//                             child: Opacity(
//                                 opacity: anim1.value,
//                                 // ignore: missing_return
//                                 child: Material(
//                                   type: MaterialType.transparency, //透明类型
//                                   child: Center(
//                                     child: Container(
//                                       height: 470,
//                                       width: MediaQuery.of(context).size.width - 40,
//                                       margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                                       decoration: ShapeDecoration(
//                                         color: Color(0xffffffff),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(8.0),
//                                           ),
//                                         ),
//                                       ),
//                                       child: Column(
//                                         children: <Widget>[
//                                           Container(
//                                             width: MediaQuery.of(context).size.width - 40,
//                                             alignment: Alignment.topLeft,
//                                             child: Material(
//                                               color: Colors.transparent,
//                                               child: InkWell(
//                                                 borderRadius: BorderRadius.all(Radius.circular(60)),
//                                                 onTap: () async {
//                                                   Navigator.pop(context); //关闭对话框
//
//                                                   // ignore: unnecessary_statements
//                                                   //                                  widget.dismissCallBackFuture("");
//                                                 },
//                                                 child: Container(width: 50, height: 50, child: Icon(Icons.clear, color: Colors.black.withAlpha(80))),
//                                               ),
//                                             ),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(left: 20, right: 20),
//                                             child: Text(
//                                               S.of(context).dialog_privacy_hint,
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                               ),
//                                             ),
//                                           ),
//                                           Container(
//                                             height: 270,
//                                             margin: EdgeInsets.only(left: 20, right: 20, top: 20),
//                                             child: SingleChildScrollView(
//                                               child: Container(
//                                                 child: Text(
//                                                   S.of(context).cfx_dapp_mag1 + " " + data.name + " " + S.of(context).cfx_dapp_mag2,
//                                                   style: TextStyle(fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 2),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Container(
//                                             margin: const EdgeInsets.only(top: 30, bottom: 20),
//                                             child: TextButton(
//                                               //定义一下文本样式
//                                               style: ButtonStyle(
//                                                 //更优美的方式来设置
//                                                 shape: MaterialStateProperty.all(StadiumBorder()),
//                                                 //设置水波纹颜色
//                                                 overlayColor: MaterialStateProperty.all( Color(0xFFFC2365).withAlpha(150)),
//
//
//                                                 //背景颜色
//                                                 backgroundColor: MaterialStateProperty.resolveWith((states) {
//                                                   //设置按下时的背景颜色
//                                                   if (states.contains(MaterialState.pressed)) {
//                                                     return Color(0xFFFC2365).withAlpha(200);
//                                                   }
//                                                   //默认不使用背景颜色
//                                                   return Color(0xFFFC2365);
//                                                 }),
//                                                 //设置按钮内边距
//                                                 padding: MaterialStateProperty.all(EdgeInsets.only(left: 25,right: 25)),
//
//                                               ),
//
//                                               child: Text(
//                                                 S.of(context).dialog_privacy_confirm,
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 14,
//                                                   fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                                 ),
//                                               ),
//                                               onPressed: () async {
//                                                 Navigator.pop(context); //关闭对话框
//                                                 if (Platform.isAndroid) {
//                                                   String resultString;
//                                                   try {
//                                                     resultString = await PluginManager.pushCfxWebViewActivity({'url': data.url, 'address': await BoxApp.getAddress(), 'language': await BoxApp.getLanguage(), 'signingKey': await BoxApp.getSigningKey()});
//                                                   } on PlatformException {
//                                                     resultString = '失败';
//                                                   }
//                                                   // print(resultString);
//                                                   return;
//                                                 }
//
//                                                 Navigator.push(
//                                                     navigatorKey.currentState.overlay.context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) => CfxRpcPage(
//                                                           url: data.url,
//                                                         )));
//                                               },
//                                             ),
//                                           ),
//
//                                           //          Text(text),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )));
//                       });
//                 },
//                 child: Column(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(top: 18, bottom: 5),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             alignment: Alignment.topLeft,
//                             margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
//                             child: Text(
//                               data.name,
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFF333333),
//                                 fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(),
//                           ),
//                           Column(
//                             children: <Widget>[
//                               Container(
//                                 margin: EdgeInsets.only(right: 20),
//                                 height: 45,
//                                 width: 45,
//                                 //边框设置
//                                 decoration: new BoxDecoration(
//                                   //背景
//                                   color: Colors.white,
//                                   //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
//                                   borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                                   //设置四周边框
//                                   border: new Border.all(width: 0.5, color: Color(0xFFeeeeee)),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(50),
//                                   child: Image.network(
//                                     data.icon,
//                                     fit: BoxFit.cover,
//
//                                     loadingBuilder: (context, child, loadingProgress) {
//                                       if (loadingProgress == null) return child;
//
//                                       return Container(
//                                         alignment: Alignment.center,
//                                         child: new Center(
//                                           child: new CircularProgressIndicator(
//                                             valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
//                                           ),
//                                         ),
//                                         width: 160.0,
//                                         height: 90.0,
//                                       );
//                                     },
//                                     //设置图片的填充样式
// //                        fit: BoxFit.fitWidth,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.topLeft,
//                       margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 0),
//                       child: Text(
//                         data.content,
//                         style: TextStyle(
//                           fontSize: 14,
//
//
//                           //字体间距
//
//                           //词间距
//                           color: Color(0xFF666666),
//                           fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(top: 8, left: 20, bottom: 18),
//                       child: Row(
//                         children: getTabs(data.tabs),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> getTabs(List<String> tabs) {
//     List<Widget> tabsWidget = List<Widget>();
//     for (var i = 0; i < tabs.length; i++) {
//       tabsWidget.add(Container(
//         margin: const EdgeInsets.only(right: 10),
//         padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
//         decoration: new BoxDecoration(
//           color: Color(0xFF37A1DB).withAlpha(16),
//           //设置四周圆角 角度
//           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         ),
//         child: Text(
//           tabs[i],
//           style: TextStyle(
//             fontSize: 14,
//
//             //字体间距
//
//             //词间距
//             color: Color(0xFF37A1DB),
//             fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//           ),
//         ),
//       ));
//     }
//     return tabsWidget;
//   }
//
//   Container getGroupTitle(String title) {
//     return Container(
//       height: 48,
//       margin: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: TextStyle(
//           color: Color(0xFF000000),
//           fontWeight: FontWeight.w500,
//           fontSize: 16,
//           fontFamily: BoxApp.language == "cn"
//               ? "Ubuntu"
//               : BoxApp.language == "cn"
//                   ? "Ubuntu"
//                   : "Ubuntu",
//         ),
//       ),
//     );
//   }
//
//   showPay() {
//     showGeneralDialog(useRootNavigator:false,
//         context: context,
//         // ignore: missing_return
//         pageBuilder: (context, anim1, anim2) {},
//         //barrierColor: Colors.grey.withOpacity(.4),
//         barrierDismissible: true,
//         barrierLabel: "",
//         transitionDuration: Duration(milliseconds: 0),
//         transitionBuilder: (_, anim1, anim2, child) {
//           final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
//           return Transform(
//             transform: Matrix4.translationValues(0.0, 0, 0.0),
//             child: Opacity(
//               opacity: anim1.value,
//               // ignore: missing_return
//               child: PayPasswordWidget(
//                 title: S.of(context).password_widget_input_password,
//                 dismissCallBackFuture: (String password) {
//                   return;
//                 },
//                 passwordCallBackFuture: (String password) async {
//                   var signingKey = await BoxApp.getSigningKey();
//                   var address = await BoxApp.getAddress();
//                   final key = Utils.generateMd5Int(password + address);
//                   var aesDecode = Utils.aesDecode(signingKey, key);
//
//                   if (aesDecode == "") {
//                     showErrorDialog(context, null);
//                     return;
//                   }
//                   // ignore: missing_return
//                 },
//               ),
//             ),
//           );
//         });
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
//
//   void showErrorDialog(BuildContext buildContext, String content) {
//     if (content == null) {
//       content = S.of(buildContext).dialog_hint_check_error_content;
//     }
//     showDialog<bool>(
//       context: buildContext,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return new AlertDialog(shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(Radius.circular(10))
//                                         ),
//           title: Text(S.of(buildContext).dialog_hint_check_error),
//           content: Text(content),
//           actions: <Widget>[
//             TextButton(
//               child: new Text(
//                 S.of(buildContext).dialog_conform,
//               ),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(true);
//               },
//             ),
//           ],
//         );
//       },
//     ).then((val) {});
//   }
// }
