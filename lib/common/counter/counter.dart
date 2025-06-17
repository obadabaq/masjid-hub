import 'package:flutter/cupertino.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class Counter extends StatelessWidget {
  final int count;
  final Function onIncrementPressed;
  final Function onDecrementPressed;
  final double height;
  final EdgeInsets padding;
  final int upperLimit;
  final int lowerLimit;
  final String label;

  const Counter({
    Key? key,
    required this.count,
    required this.onIncrementPressed,
    required this.onDecrementPressed,
    required this.label,
    this.padding = const EdgeInsets.all(0),
    this.upperLimit = 999,
    this.lowerLimit = 0,
    this.height = 85,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool disableDecrement = count <= lowerLimit;
    bool disableIncrement = count >= upperLimit;

    return Container(
        padding: padding,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final _itemWidth = constraints.maxWidth;
            return Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              margin: EdgeInsets.only(top: 12, bottom: 12),
              decoration: ConcaveDecoration(
                depth: 9,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                colors: innerConcaveShadow,
                size: Size(_itemWidth, height),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap:
                          !disableDecrement ? () => onDecrementPressed() : null,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CustomTheme.lightTheme.colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: secondaryShadow,
                        ),
                        child: Icon(
                          CupertinoIcons.minus_circle,
                          size: 38,
                          color: disableDecrement
                              ? CustomColors.mischka.withValues(alpha: 0.30)
                              : CustomColors.mischka,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 30.0,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.blackPearl,
                          ),
                        ),
                        Text(
                          label.toLowerCase(),
                          style: TextStyle(
                            fontSize: 15.0,
                            height: 1.0,
                            color: CustomColors.mischka,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap:
                          !disableIncrement ? () => onIncrementPressed() : null,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CustomTheme.lightTheme.colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: secondaryShadow,
                        ),
                        child: Icon(
                          CupertinoIcons.plus_circle,
                          size: 38,
                          color: disableIncrement
                              ? CustomColors.mischka.withValues(alpha: 0.30)
                              : CustomColors.mischka,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
