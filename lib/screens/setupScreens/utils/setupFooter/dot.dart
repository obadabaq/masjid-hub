import 'package:flutter/material.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class Dot extends StatelessWidget {
  final bool isActive;
  const Dot({
    required this.isActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: 15,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: 15,
        width: 15,
        decoration: isActive
            ? BoxDecoration(
                boxShadow: shadowDotActive,
                shape: BoxShape.circle,
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.background,
              )
            : ConcaveDecoration(
                depth: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                colors: innerConcaveShadow,
                size: Size(15, 15),
              ),
      ),
    );
  }
}
