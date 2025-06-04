import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LineraProgressIndicator extends StatelessWidget {
  const LineraProgressIndicator({
    Key? key,
    required this.audioProgress,
    required this.width,
  }) : super(key: key);

  final int audioProgress;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearPercentIndicator(
            width: width,
            lineHeight: 5.0,
            percent: audioProgress / 100,
            backgroundColor: Theme.of(context).colorScheme.background,
            progressColor: Theme.of(context).colorScheme.secondary,
            animation: true,
            animateFromLastPercent: true,
            barRadius: Radius.circular(20),
          ),
        ],
      ),
    );
  }
}
