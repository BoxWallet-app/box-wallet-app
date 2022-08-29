import 'package:flutter/widgets.dart';

class MarqueeView extends StatefulWidget {
  final Duration pauseDuration, forwardDuration;
  final double scrollSpeed; //滚动速度(时间单位是秒)。
  final Widget child; //子视图。

  /// 注: 构造函数入参的默认值必须是常量。
  const MarqueeView(
      {Key? key,
        this.pauseDuration = const Duration(milliseconds: 100),
        this.forwardDuration = const Duration(milliseconds: 3000),
        this.scrollSpeed = 40.0,
        required this.child})
      : super(key: key);

  @override
  _MarqueeViewState createState() => _MarqueeViewState();
}

class _MarqueeViewState extends State<MarqueeView>
    with SingleTickerProviderStateMixin {
  bool _validFlag = true;
  double _boxWidth = 0;
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    debugPrint('Track_MarqueeView_dispose');
    _validFlag = false;
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scroll();
  }

  @override
  Widget build(BuildContext context) {
    /// 使用LayoutBuilder获取组件的大小。
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _boxWidth = constraints.maxWidth;
        return SingleChildScrollView(
          // 禁止手动滑动。
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _boxWidth),
            child: widget.child,
          ),
        );
      },
    );
  }

  void scroll() async {
    while (_validFlag) {
      debugPrint('Track_MarqueeView_scroll');
      await Future.delayed(widget.pauseDuration);
      if (_boxWidth <= 0) {
        continue;
      }
      _controller.jumpTo(0);
      // 两个方向: Curves.easeIn 和 Curves.easeOut 。
      await _controller.animateTo(_controller.position.maxScrollExtent,
          duration: Duration(
              seconds:
              (_controller.position.maxScrollExtent / widget.scrollSpeed)
                  .floor()),
          curve: Curves.easeIn);
    }
  }
}