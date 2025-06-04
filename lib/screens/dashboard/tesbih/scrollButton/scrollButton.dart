import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

class ScrollButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;

  const ScrollButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 60,
      icon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: CustomColors.greyIconGradientTwo,
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        child: Icon(
          icon,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
