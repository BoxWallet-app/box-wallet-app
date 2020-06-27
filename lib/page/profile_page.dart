import 'package:box/page/scan_page.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
            backgroundColor: Color(0xFFEEEEEE),
            body: SingleChildScrollView(
              child: Container(
                height: 700,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: Container(color: Color(0xFFE71766)),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image(
                        width: 91,
                        height: 96,
                        image: AssetImage('images/profile_lines.png'),
                      ),
                    ),
                    Positioned(
                      top: 92,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          buildHeaderItem("连接网络", "images/profile_network.png", () {}),
                          buildHeaderItem("远程连接", "images/profile_connect.png", () async {
                            Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
                            if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()));
                            } else {
                              Fluttertoast.showToast(msg: "没有相机权限", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                            }
                          }),
                          buildHeaderItem("钱包认证", "images/profile_wallet.png", () async {
                            Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.photos]);
                            if (permissions[PermissionGroup.photos] == PermissionStatus.granted) {
                              var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                              if (image == null) return;
                              final rest = await FlutterQrReader.imgScan(image);
                            } else {
                              Fluttertoast.showToast(msg: "没有相册权限", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                            }
                          }),
                          buildHeaderItem("备份助记词", "images/profile_backups.png", () {
                            showBarModalBottomSheet(
                              context: context,
                                barrierColor:Colors.black38,
                              // ignore: missing_return
                              builder: (context, scrollController) => PayPasswordWidget(title: "请输入临时密码",passwordCallBackFuture: (value){
                                print(value);
                                showBarModalBottomSheet(
                                  context: context,
                                  // ignore: missing_return
                                  builder: (context, scrollController) => PayPasswordWidget(title: "456",passwordCallBackFuture: (value){
                                    print(value);
                                  }),
                                );
                              }),
                            );
//                            showModalBottomSheet(
//                              context: context,
//                              builder: (BuildContext context) {
//                                return _passwordWidget;
//                              },
//                            ).then((val) {
//                              print(val);
//                            });
                          }),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 192,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 182,
                        alignment: Alignment(0, 0),
                        color: Color(0x00FFFFFF),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  //设置四周圆角 角度
//                        borderRadius: BorderRadius.all(topRadius.circular(20.0)),
                                  borderRadius: BorderRadius.only(topLeft: new Radius.circular(20.0), topRight: new Radius.circular(20.0))
                                  //设置四周边框
                                  ),
                              padding: const EdgeInsets.all(18),
                              child: Image(
                                image: AssetImage('images/profile_banner.png'),
                              ),
                            ),
                            buildItem(context, "显示的货币", "images/profile_display_currency.png", () {
                              print("123");
                            }),
                            buildItem(context, "账户权限", "images/profile_account_permissions.png", () {
                              print("123");
                            }),
                            buildItem(context, "语言", "images/profile_lanuge.png", () {
                              print("123");
                            }),
                            buildItem(context, "关于", "images/profile_info.png", () {
                              print("123");
                            }),
                            buildItem(context, "重置密钥", "images/profile_reset_password.png", () {
                              print("123");
                            }, isLine: false),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Material buildItem(BuildContext context, String content, String assetImage, GestureTapCallback tab, {bool isLine = true}) {
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
                    Image(
                      width: 40,
                      height: 40,
                      image: AssetImage(assetImage),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(fontSize: 15, color: Colors.black),
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
                  left: 30,
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFEEEEEE)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderItem(String content, String image, GestureTapCallback tapCallback) {
    return Material(
        color: Color(0xFFE71766),
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
                    style: new TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
