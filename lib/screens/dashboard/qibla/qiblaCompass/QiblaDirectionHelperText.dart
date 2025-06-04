import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/provider/setupProvider.dart';

class QiblaDirectionHelperText extends StatefulWidget {
  const QiblaDirectionHelperText({
    Key? key,
  }) : super(key: key);

  @override
  _QiblaDirectionHelperTextState createState() =>
      _QiblaDirectionHelperTextState();
}

class _QiblaDirectionHelperTextState extends State<QiblaDirectionHelperText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? timer;
  Duration textAnimationDelay = Duration(seconds: 5);
  Duration animationDuration = Duration(seconds: 1);

  void onAnimationComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed)
      Provider.of<SetupProvider>(context, listen: false)
          .setQiblaHelperTextViewed(true);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: animationDuration, vsync: this)
      ..addStatusListener(onAnimationComplete);
    _animation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    timer = Timer.periodic(
        textAnimationDelay,
        (Timer t) => setState(() {
              _controller.animateTo(1.0);
            }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupProvider>(
      builder: (ctx, setupProvider, _) {
        final bool isWidgetViewedPreviously =
            setupProvider.getQiblaHelperTextViewed;
        if (!isWidgetViewedPreviously)
          return SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            axis: Axis.vertical,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Text(
                    tr('qibla help text'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.blackPearl.withOpacity(0.7),
                      fontSize: 22,
                      height: 1.3,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          );
        return SizedBox(height: 0);
      },
    );
  }
}
