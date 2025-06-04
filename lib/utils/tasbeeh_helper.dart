import 'package:flutter/material.dart';
import 'dart:math';

class TasbeehProgressIndicator extends StatelessWidget {
  final int tasbeehCount;

  TasbeehProgressIndicator({required this.tasbeehCount});

  @override
  Widget build(BuildContext context) {
    double progressValue = tasbeehCount % 33 / 33.0; // Progress resets after reaching 33

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress indicator, with a max value of 33
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: progressValue,
              strokeWidth: 6.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
          ),
          // Tasbeeh count displayed in the center of the progress circle
          Text(
            '$tasbeehCount',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class TasbeehDottedIndicator extends StatelessWidget {
  final int tasbeehCount;

  TasbeehDottedIndicator({required this.tasbeehCount});

  @override
  Widget build(BuildContext context) {
    double progressValue = tasbeehCount % 33 / 33.0; // Dotted progress resets after reaching 33
    int dotsCount = 33; // Number of dots

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom dotted progress indicator
          SizedBox(
            width: 150,
            height: 150,
            child: CustomPaint(
              painter: DottedCirclePainter(
                progress: progressValue,
                totalDots: dotsCount,
              ),
            ),
          ),
          // Tasbeeh count in the center
          Text(
            '$tasbeehCount',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final double progress;
  final int totalDots;

  DottedCirclePainter({required this.progress, required this.totalDots});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double dotRadius = 3.0;
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw all background dots
    for (int i = 0; i < totalDots; i++) {
      double angle = (2 * pi * i) / totalDots;
      double x = radius + radius * cos(angle);
      double y = radius + radius * sin(angle);

      canvas.drawCircle(Offset(x, y), dotRadius, backgroundPaint);
    }

    // Draw progress dots based on the current progress value
    int filledDots = (totalDots * progress).round();
    for (int i = 0; i < filledDots; i++) {
      double angle = (2 * pi * i) / totalDots;
      double x = radius + radius * cos(angle);
      double y = radius + radius * sin(angle);

      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
