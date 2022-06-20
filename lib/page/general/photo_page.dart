import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';


class PhotoPage extends StatefulWidget {
  final String? address;

  const PhotoPage({Key? key, this.address}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: PhotoView(
//              imageProvider: NetworkImage("https://www.gravatar.com/avatar/" + Utils.generateMD5(DateTime.now().toIso8601String()) + "?s=1024&d=robohash&r=PG"),
                  imageProvider: NetworkImage(widget.address!),
              loadingBuilder: (context, _progress) => Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      )),
    );
  }
}
