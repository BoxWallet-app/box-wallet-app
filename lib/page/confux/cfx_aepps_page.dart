import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/banner_dao.dart';
import 'package:box/dao/aeternity/base_name_data_dao.dart';
import 'package:box/dao/aeternity/contract_info_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/banner_model.dart';
import 'package:box/model/aeternity/base_name_data_model.dart';
import 'package:box/model/aeternity/contract_info_model.dart';
import 'package:box/page/aeternity/ae_swap_my_page.dart';
import 'package:box/page/aeternity/ae_swap_page.dart';
import 'package:box/page/aeternity/ae_token_defi_page.dart';
import 'package:box/page/confux/cfx_rpc_page.dart';
import 'package:box/page/web_page.dart';
import 'package:box/page/aeternity/ae_wetrue_home_page.dart';
import 'package:box/page/aeternity/ae_wetrue_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';


class CfxDappsPage extends StatefulWidget {
  @override
  _CfxDappsPageState createState() => _CfxDappsPageState();
}

class _CfxDappsPageState extends State<CfxDappsPage>
    with AutomaticKeepAliveClientMixin {
  BannerModel bannerModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netBanner();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
  }



  void showChainLoading() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }

  Future<void> _onRefresh() async {
    netBanner();
  }

  void netBanner() {
    BannerDao.fetch().then((BannerModel model) {
      bannerModel = model;
      setState(() {});
    }).catchError((e) {
      //      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: EasyRefresh(
          header: BoxHeader(),
          onRefresh: _onRefresh,
          child: Column(
            children: [
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width - 30,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    if (bannerModel != null)
                      InkWell(
                        onTap: () {
                          if (bannerModel == null) {
                            return;
                          }
                          _launchURL(
                            bannerModel == null
                                ? ""

                                : BoxApp.language == "cn"
                                ? bannerModel.cn.url
                                : bannerModel.en.url,
                          );
                        },
                        child: Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width - 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: Image.network(
                              bannerModel == null
                                  ? ""
                                  : BoxApp.language == "cn"
                                  ? bannerModel.cn.image
                                  : bannerModel.en.image,
                              fit: BoxFit.cover,

                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Container(
                                  alignment: Alignment.center,
                                  child: new Center(
                                    child: new CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                          Color(0xFFF22B79)),
                                    ),
                                  ),
                                  width: 160.0,
                                  height: 90.0,
                                );
                              },
                              //设置图片的填充样式
//                        fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            color: Color(0x99000000),
                          ),
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 5, bottom: 5),
                          alignment: Alignment.center,
                          child: Text(
                            bannerModel == null
                                ? "-"
                                : BoxApp.language == "cn"
                                ? bannerModel.cn.title
                                : bannerModel.en.title,
                            style: new TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily:
                                BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//          if (!BoxApp.isOpenStore)

              Container(
                height: 8,
              ),
            ],
          ),
        ));
  }

  showPay() {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0, 0.0),
            child: Opacity(
              opacity: anim1.value,
              // ignore: missing_return
              child: PayPasswordWidget(
                title: S.of(context).password_widget_input_password,
                dismissCallBackFuture: (String password) {
                  return;
                },
                passwordCallBackFuture: (String password) async {
                  var signingKey = await BoxApp.getSigningKey();
                  var address = await BoxApp.getAddress();
                  final key = Utils.generateMd5Int(password + address);
                  var aesDecode = Utils.aesDecode(signingKey, key);

                  if (aesDecode == "") {
                   showErrorDialog(context, null);
                    return;
                  }
                  // ignore: missing_return
                },
              ),
            ),
          );
        });
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  void showErrorDialog(BuildContext context, String content) {
    if (content == null) {
      content = S.of(context).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text(S.of(context).dialog_hint_check_error),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(context).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }
}
