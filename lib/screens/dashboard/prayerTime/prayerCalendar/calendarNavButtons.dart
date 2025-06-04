import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/enums/deviceScale.dart';
import 'package:masjidhub/utils/layoutUtils.dart';

enum NavButtonOrientation { left, right }

class CalendarNavButtons extends StatelessWidget {
  final NavButtonOrientation orientation;
  final Function? onLeftButtonClick;
  final Function? onRightButtonClick;
  final DeviceScale scale;

  const CalendarNavButtons({
    Key? key,
    required this.orientation,
    this.onLeftButtonClick,
    this.onRightButtonClick,
    this.scale = DeviceScale.normal,
  }) : super(key: key);

  final double normalSizeOfCalendarIcon = 35;

  @override
  Widget build(BuildContext context) {
    final double sizeOfCalendarIcons =
        LayoutUtils().getCalendarIconHeigt(scale, normalSizeOfCalendarIcon);

    IconData icon = orientation == NavButtonOrientation.left
        ? Icons.arrow_back_ios
        : Icons.arrow_forward_ios;

    Function onClick = orientation == NavButtonOrientation.left
        ? onLeftButtonClick!
        : onRightButtonClick!;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onClick(),
      child: Icon(
        icon,
        size: sizeOfCalendarIcons,
        color: CustomColors.mischka,
      ),
    );
  }
}
