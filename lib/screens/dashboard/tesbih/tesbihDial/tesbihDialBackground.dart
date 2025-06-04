import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihDial/tesbihButton.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class TesbihDialBackground extends StatelessWidget {
  final double maxWidth;
  final int tesbihCount;
  final Function incrementTesbih;

  const TesbihDialBackground({
    Key? key,
    required this.maxWidth,
    required this.incrementTesbih,
    required this.tesbihCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        decoration: ConcaveDecoration(
          depth: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(maxWidth / 2)),
          colors: [
            Colors.white,
            CustomColors.spindle,
          ],
          size: Size(maxWidth, maxWidth),
        ),
        child: Center(
          child: Container(
            width: maxWidth - 80, // width and height and margin of small dot
            height: maxWidth - 80,
            decoration: BoxDecoration(
              color: CustomColors.solitude,
              boxShadow: tertiaryShadow,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(maxWidth - 80),
            ),
            child: TesbihButton(
              maxWidth: maxWidth - 80,
              incrementTesbih: incrementTesbih,
              tesbihCount: tesbihCount,
            ),
          ),
        ),
      ),
    );
  }
}
