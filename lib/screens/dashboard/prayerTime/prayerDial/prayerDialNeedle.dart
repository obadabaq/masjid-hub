import 'dart:math';
import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

class PrayerdialNeedle extends CustomPainter {
  PrayerdialNeedle({
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

  double get rotation => 2 * pi * (angle / 360);

  Paint get _brush => new Paint()
    ..strokeCap = StrokeCap.butt
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    bool fewMinsLeft =
        timeLeft.inMinutes < (alertTimeInMins ?? defaultAlertTimeInMins);
    Paint needle = _brush
      ..color = fewMinsLeft ? CustomColors.scarlet : CustomColors.irisBlue
      ..style = PaintingStyle.fill;

    double radius = squareLength / 2;
    Offset center = Offset(squareLength / 2, radius);
    Offset start = Offset.lerp(Offset(center.dx, 0), center, 0.06)!;
    Offset end = Offset.lerp(Offset(center.dx, 0), center, 0.5)!;

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    Path needleShadowPath = Path();
    needleShadowPath..moveTo(start.dx, start.dy + 10);
    needleShadowPath.lineTo(start.dx, end.dy);
    needleShadowPath.lineTo(start.dx + 5, end.dy);
    needleShadowPath.lineTo(start.dx + 5, start.dy + 10);
    needleShadowPath.close();

    canvas.drawShadow(needleShadowPath, Colors.black, 8.0, true);
    canvas.drawLine(start, end, needle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
