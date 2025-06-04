import 'package:flutter/material.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class SearchTextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final Function? onPressed;
  final EdgeInsetsGeometry? padding;
  final double buttonWidth;
  final TextEditingController? controller;
  final bool readOnly;

  const SearchTextField({
    Key? key,
    required this.buttonWidth,
    this.onPressed,
    this.padding,
    this.controller,
    this.initialValue,
    this.hintText,
    this.readOnly = false,
  }) : super(key: key);

  static TextStyle textStyle = TextStyle(
    fontSize: 20,
    color: CustomColors.mischka,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Container(
        height: 70,
        width: buttonWidth,
        decoration: ConcaveDecoration(
            depth: 9,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            colors: innerConcaveShadow,
            size: Size(buttonWidth, 70)),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            initialValue: initialValue,
            style: textStyle,
            decoration: InputDecoration(
              prefixIcon: Icon(
                AppIcons.searchIcon,
                size: 20,
                color: CustomColors.mischka,
              ),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: textStyle,
            ),
            onTap: () => onPressed!() ?? () {},
          ),
        ),
      ),
    );
  }
}
