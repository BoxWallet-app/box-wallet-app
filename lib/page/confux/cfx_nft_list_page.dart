import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:box/dao/aeternity/aens_page_dao.dart';
import 'package:box/dao/conflux/cfx_nft_preview_dao.dart';
import 'package:box/dao/conflux/cfx_nft_token_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/aens_page_model.dart';
import 'package:box/model/conflux/cfx_nft_balance_model.dart';
import 'package:box/model/conflux/cfx_nft_preview_model.dart';
import 'package:box/model/conflux/cfx_nft_token_model.dart';
import 'package:box/page/aeternity/ae_aens_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class CfxNftListPage extends StatefulWidget {
  final NftData data;

  const CfxNftListPage({Key key, this.data}) : super(key: key);

  @override
  _CfxNftListPageState createState() => _CfxNftListPageState();
}

class _CfxNftListPageState extends State<CfxNftListPage> with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();
  LoadingType _loadingType = LoadingType.loading;
  AensPageModel _aensPageModel;
  int page = 1;
  List<CfxNftPreviewModel> cfxNftModel = List();

  @override
  Future<void> initState() {
    super.initState();
    netData();
  }

  Future<void> netData() async {
    CfxNftTokenModel cfxNftTokenModel = await CfxNftTokenDao.fetch(widget.data.address);
    _loadingType = LoadingType.finish;
    cfxNftModel.clear();
    for (var i = 0; i < cfxNftTokenModel.data[1].length; i++) {
      var tokenId = cfxNftTokenModel.data[1][i].toString();
      print(tokenId);
      CfxNftPreviewModel cfxNftPreviewModel = await CfxNftPreviewDao.fetch(widget.data.address, tokenId);
      print(cfxNftPreviewModel.toString());
      cfxNftModel.add(cfxNftPreviewModel);
      setState(() {});
    }
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
          header: BoxHeader(),
          footer: MaterialFooter(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
          controller: _controller,
          child: GridView.builder(
              itemCount: cfxNftModel.length,
              //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //横轴元素个数
                  crossAxisCount: 3,
                  //纵轴间距
                  mainAxisSpacing: 20.0,
                  //横轴间距
                  crossAxisSpacing: 10.0,
                  //子组件宽高长度比例
                  childAspectRatio: 1.0),
              itemBuilder: (BuildContext context, int index) {
                //Widget Function(BuildContext context, int index)
                return getItemContainer(cfxNftModel[index]);
              }),
        ),
        type: _loadingType,
        onPressedError: () {
          netData();
          setState(() {
            _loadingType = LoadingType.loading;
          });
        },
      ),
    );
  }

  Widget getItemContainer(CfxNftPreviewModel item) {
    String title = "";

    if(item.data == null){
      title = "";
    }else{
      title = item.data.imageUri;
    }

    return Container(
      width: 5.0,
      height: 5.0,
      alignment: Alignment.center,
      child: getIconImage(title),
      color: Colors.blue,
    );
  }


  Widget getIconImage(String data) {

    if(data == ""){
      return Container(
        width: 5.0,
        height: 5.0,
        alignment: Alignment.center,
        color: Colors.blue,
      );
    }

    print(data);
    if(data.contains("http")){
      return  Container(
        // height: 70,
        // width: MediaQuery.of(context).size.width - 30,

        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          child: Image.network(
            data,
            fit: BoxFit.cover,

            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Container(
                alignment: Alignment.center,
                child: new Center(
                  child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
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
      );
    }else{
      String icon = data.split(',')[1]; //
      if(data.contains("data:image/png")){
        Uint8List bytes = Base64Decoder().convert(icon);
        return Image.memory(bytes, fit: BoxFit.contain);
      }

      if(data.contains("data:image/svg")){
        Uint8List bytes = Base64Decoder().convert(icon);

        return SvgPicture.memory(
          bytes,
          semanticsLabel: 'A shark?!',
          placeholderBuilder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: const CircularProgressIndicator()),
        );


      }
    }


  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
