import 'dart:math';
import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

class CompassPainter extends CustomPainter {
  CompassPainter({
    required this.angle,
    required this.squareLength,
    required this.almostAccurate,
  }) : super();

  final bool almostAccurate;
  final double angle;
  final double squareLength;

  double get rotation => 2 * pi * (angle / 360);

  Paint get _brush => new Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = almostAccurate ? 13 : 15.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint needle = _brush
      ..color =
          almostAccurate ? CustomColors.turquoise : CustomColors.blackPearl
      ..style = PaintingStyle.fill;

    double radius = squareLength / 2;
    Offset center = Offset(squareLength / 2, radius);
    Offset start = Offset.lerp(Offset(center.dx, 0), center, 0.13)!;
    Offset end = Offset.lerp(Offset(center.dx, 0), center, 0.13)!;

    Path ballShadow = Path();
    ballShadow..moveTo(start.dx, start.dy + 8);
    ballShadow.lineTo(start.dx, end.dy + - 5);
    ballShadow.lineTo(start.dx + 10, end.dy - 5);
    ballShadow.lineTo(start.dx + 10, start.dy + 8);
    ballShadow.close();

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawShadow(ballShadow, Colors.black.withOpacity(0.3), 5.0, true);
    canvas.drawLine(start, end, needle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
