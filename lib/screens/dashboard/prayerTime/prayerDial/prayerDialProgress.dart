import 'dart:math';
import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

class PrayerdialProgress extends CustomPainter {
  PrayerdialProgress({
    required this.angle,
    required this.squareLength,
    required this.alertTimeInMins,
    required this.timeLeft,
  }) : super();

  final double squareLength;
  final int angle;
  final int? alertTimeInMins;
  final Duration timeLeft;
  static int defaultAlertTimeInMins = 20;

  double get rotation => 2 * pi * (-110 / 360);

  @override
  void paint(Canvas canvas, Size size) {
    bool fewMinsLeft =
        timeLeft.inMinutes < (alertTimeInMins ?? defaultAlertTimeInMins);
    double radius = squareLength / 2;
    Offset center = Offset(squareLength / 2, radius);
    Rect rect = Rect.fromCircle(center: center, radius: radius - 20);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(
        rect,
        0.35,
        angle * pi / 180,
        false,
        Paint()
          ..color = fewMinsLeft ? CustomColors.scarlet : CustomColors.irisBlue
          ..strokeWidth = 25
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
