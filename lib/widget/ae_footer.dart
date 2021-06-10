import 'package:flutter/src/painting/basic_types.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lottie/lottie.dart';

class AEFooter extends Footer {
  /// Key
  final Key key;

  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();

  AEFooter({
    this.key,
    bool enableHapticFeedback = true,
    Duration completeDuration: const Duration(seconds: 1),
  }) : super(
          extent: 50.0,
          triggerDistance: 50.0,
          float: false,
          enableHapticFeedback: enableHapticFeedback,
          completeDuration: completeDuration,
        );

  @override
  Widget contentBuilder(BuildContext context, LoadMode loadState, double pulledExtent, double loadTriggerPullDistance, double loadIndicatorExtent, AxisDirection axisDirection, bool float, Duration completeDuration, bool enableInfiniteLoad, bool success, bool noMore) {
    // TODO: implement contentBuilder
    throw AEHeaderWidget();
  }


}

class AEHeaderWidget extends StatefulWidget {
  final LinkHeaderNotifier linkNotifier;

  const AEHeaderWidget({
    Key key,
    this.linkNotifier,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AEHeaderWidgetState();
  }
}

class AEHeaderWidgetState extends State<AEHeaderWidget> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 50,
            height: 50,
            child: Lottie.asset(
//              'images/lf30_editor_nwcefvon.json',
              'images/lf30_editor_41iiftdt.json',
//              'images/animation_khzuiqgg.json',
              controller: _controller,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = Duration(milliseconds: 1000)
                  ..repeat();
              },
            ),
          ),
        )
      ],
    );
  }
}
