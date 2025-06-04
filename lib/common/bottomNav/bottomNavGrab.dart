import 'package:flutter/material.dart';
import 'package:masjidhub/constants/bottomNav.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/common/bottomNav/snappedAudioPlayer.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/dot.dart';

class BottomNavGrab extends StatefulWidget {
  const BottomNavGrab({
    Key? key,
    required this.animationController,
    this.isAudioPlayerEnabled = false,
    required this.isRemoteOn,
  }) : super(key: key);

  final AnimationController animationController;
  final bool isAudioPlayerEnabled;
  final bool isRemoteOn;

  @override
  _BottomNavGrabState createState() => _BottomNavGrabState();
}

class _BottomNavGrabState extends State<BottomNavGrab> {
  static Radius _borderRadius = Radius.circular(20);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    end: Offset.zero,
    begin: Offset(0.0, 1.5),
  ).animate(CurvedAnimation(
    parent: widget.animationController,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    super.dispose();
    widget.animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        height: widget.isAudioPlayerEnabled
            ? bottomNavGrabHeightWhenAudioEnabled
            : bottomNavGrabHeightWhenAudioDisabled,
        child: Column(
          children: [
            if (widget.isAudioPlayerEnabled && mounted && !widget.isRemoteOn)
              SnappedAudioPlayer(),
            Container(
              height: bottomNavGrabHeightWhenAudioDisabled,
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: bottomNavShadow,
                borderRadius: BorderRadius.only(
                    topLeft: _borderRadius, topRight: _borderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [for (var i = 0; i < 3; i++) Dot(isActive: false)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
