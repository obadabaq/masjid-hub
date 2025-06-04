import 'package:flutter/material.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:masjidhub/constants/bottomNav.dart';
import 'package:masjidhub/common/bottomNav/bottomNavGrab.dart';

class SnappedbottomNavBar extends StatelessWidget {
  const SnappedbottomNavBar({
    Key? key,
    required this.dashboardScreen,
    required this.bottomNavBar,
    required this.animationController,
    required this.snappingSheetController,
    required this.hideNavBar,
    this.isAudioPlayerEnabled = false,
    required this.audioState,
    this.isRemoteOn = false,
  }) : super(key: key);

  final Widget dashboardScreen;
  final Widget bottomNavBar;
  final AnimationController animationController;
  final SnappingSheetController snappingSheetController;
  final bool hideNavBar;
  final bool isAudioPlayerEnabled;
  final AudioPlayerStateModel audioState;
  final bool isRemoteOn;

  // Not sure why
  static double audioPlayerHeight = 35;

  void onSnapCompleted(double position) {
    final bool navBarHidden = position == 25.0;

    // When it shouldnt be hidden, trigger to show it
    if (navBarHidden && !hideNavBar)
      snappingSheetController
          .snapToPosition(SnappingPosition.pixels(positionPixels: 150));
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: snappingSheetController,
      lockOverflowDrag: true,
      onSnapCompleted: (position, snappingPosition) =>
          onSnapCompleted(position.pixels),
      snappingPositions: [
        SnappingPosition.pixels(
          positionPixels: isAudioPlayerEnabled ? audioPlayerHeight + 150 : 150,
          snappingCurve: Curves.elasticOut,
          snappingDuration: Duration(milliseconds: 1750),
        ),
        SnappingPosition.pixels(
          positionPixels: 0,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
      ],
      child: dashboardScreen,
      grabbingHeight: isAudioPlayerEnabled
          ? bottomNavGrabHeightWhenAudioEnabled
          : bottomNavGrabHeightWhenAudioDisabled,
      grabbing: BottomNavGrab(
        animationController: animationController,
        isAudioPlayerEnabled: isAudioPlayerEnabled,
        isRemoteOn: isRemoteOn,
      ),
      sheetBelow: SnappingSheetContent(
        sizeBehavior: SheetSizeStatic(size: 120),
        draggable: hideNavBar,
        child: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: bottomNavBar,
        ),
      ),
    );
  }
}
