import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';

class BookmarkButton extends StatelessWidget {
  final Function? onPressed;
  final bool isSelected;

  const BookmarkButton({
    Key? key,
    this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed!() ?? () {},
      child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.fromLTRB(0, 0, 20, 25),
        decoration: BoxDecoration(
          color: CustomColors.solitude,
          boxShadow: tertiaryShadowAppBar,
          borderRadius: BorderRadius.circular(30),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: CustomColors.solitude,
          child: Icon(
            isSelected ? Icons.pause : Icons.play_arrow,
            color: CustomColors.mischka,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
