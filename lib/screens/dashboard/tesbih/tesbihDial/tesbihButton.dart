import 'package:flutter/material.dart';

import 'package:masjidhub/screens/dashboard/tesbih/tesbihDial/tesbihRipple.dart';
import 'package:masjidhub/theme/colors.dart';

class TesbihButton extends StatefulWidget {
  final double maxWidth;
  final int tesbihCount;
  final Function incrementTesbih;

  const TesbihButton({
    Key? key,
    required this.maxWidth,
    required this.tesbihCount,
    required this.incrementTesbih,
  }) : super(key: key);

  @override
  State<TesbihButton> createState() => _TesbihButtonState();
}

class _TesbihButtonState extends State<TesbihButton> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.incrementTesbih(),
      onTapDown: (e) => setState(() => isAnimating = true),
      onTapUp: (e) => setState(() => isAnimating = false),
      child: Container(
        width: widget.maxWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.maxWidth / 2),
          gradient: isAnimating ? CustomColors.primary90 : null,
        ),
        child: Stack(
          children: [
            TesbihRipple(
              duration: Duration(seconds: 1),
              maxWidth: widget.maxWidth,
              minWidth: widget.maxWidth * 0.4,
              isAnimating: isAnimating,
            ),
            TesbihRipple(
              duration: Duration(milliseconds: 600),
              maxWidth: widget.maxWidth,
              minWidth: 0,
              isAnimating: isAnimating,
            ),
            Center(
              child: Text(
                "${widget.tesbihCount}",
                style: TextStyle(
                  color: isAnimating
                      ? CustomColors.solitude
                      : CustomColors.irisBlue,
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
