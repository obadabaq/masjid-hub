import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class TesbihDots extends StatelessWidget {
  final int tesbihCount;
  final VoidCallback incrementTesbih;

  static const int _dotCount = 33;

  const TesbihDots({
    Key? key,
    required this.tesbihCount,
    required this.incrementTesbih,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double step = 2 * pi / _dotCount;

    return RepaintBoundary(
      child: Stack(
        children: List.generate(_dotCount, (index) {
          final double angle = step * index;

          return Transform.rotate(
            angle: angle,
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform.rotate(
                angle: -angle,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 22,
                  height: 22,
                  child: Stack(
                    children: [
                      DecoratedBox(
                        decoration: ConcaveDecoration(
                          depth: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          colors: innerConcaveShadow,
                          size: const Size(22, 22),
                        ),
                      ),
                      if (index < tesbihCount)
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              boxShadow: shadowTesbihDot,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              gradient: CustomColors.primary180,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
