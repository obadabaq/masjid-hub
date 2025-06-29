import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

import '../../constants/shadows.dart';
import '../../theme/customTheme.dart';

class DropdownListItem extends StatelessWidget {
  final String id;
  final String title;
  final Function onPressed;
  final EdgeInsets padding;
  final bool isSelected;

  const DropdownListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.onPressed,
    this.padding = const EdgeInsets.only(top: 12, bottom: 12),
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(id, title),
      child: Container(
        padding: padding,
        decoration: !isSelected
            ? null
            : BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background
                    .withValues(alpha: .8),
                boxShadow: tertiaryShadow,
                shape: BoxShape.rectangle,
              ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 19.0,
            height: 1.3,
            color: CustomColors.blackPearl.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
