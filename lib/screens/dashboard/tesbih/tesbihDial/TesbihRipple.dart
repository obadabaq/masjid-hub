import 'package:flutter/material.dart';

class TesbihRipple extends StatelessWidget {
  final bool isAnimating;
  final double maxWidth;
  final double minWidth;
  final Duration duration;

  const TesbihRipple({
    Key? key,
    required this.isAnimating,
    required this.maxWidth,
    required this.minWidth,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: duration * 0.2,
        opacity: isAnimating ? 1 : 0,
        child: AnimatedContainer(
          duration: duration,
          width: isAnimating ? maxWidth : minWidth,
          height: isAnimating ? maxWidth : minWidth,
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(maxWidth / 2),
            border: Border.all(
              color: Colors.white,
              width: isAnimating ? 0 : 2,
            ),
          ),
        ),
      ),
    );
  }
}
