import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class AnalyticsColumn extends StatefulWidget {
  final double progress;
  final int index;
  final bool showNumbers;
  final int totalCount;
  final String footerText;
  final Function(int) onColumnTap;

  const AnalyticsColumn({
    Key? key,
    required this.progress,
    required this.index,
    required this.onColumnTap,
    required this.totalCount,
    required this.footerText,
    this.showNumbers = false,
  }) : super(key: key);

  @override
  State<AnalyticsColumn> createState() => _AnalyticsColumnState();
}

class _AnalyticsColumnState extends State<AnalyticsColumn> {
  final double maxHeight = 250;
  final double width = 20;

  static List<int> showFooterIndex = [1, 4, 7];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 35,
          child: Visibility(
            visible: widget.showNumbers,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.only(bottom: 8),
              width: 50,
              child: Text(
                widget.totalCount.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.solitude, fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                boxShadow: tertiaryShadow,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
                gradient: CustomColors.primary180,
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => widget.onColumnTap(widget.index),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: width,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  width: width,
                  height: maxHeight,
                  decoration: ConcaveDecoration(
                    depth: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30 / 2)),
                    colors: [
                      Colors.white,
                      CustomColors.spindle,
                    ],
                    size: Size(width, maxHeight),
                  ),
                ),
                Container(
                  width: width,
                  height: maxHeight * widget.progress,
                  decoration: BoxDecoration(
                    color: CustomColors.irisBlue,
                    boxShadow: tertiaryShadow,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    gradient: CustomColors.primary180,

                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 35,
          child: Visibility(
            visible: showFooterIndex.any((el) => el == widget.index),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.footerText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.mischka,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
