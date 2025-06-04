import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool isSelected;
  final double width;
  final int? id;
  final bool upperCase;
  final TextAlign textAlign;
  final bool isLoading;
  final Color loadingIndicatorColor;
  final bool isDisabled;
  final double fontSize;
  final FontWeight fontWeight;

  PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.width,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    this.textAlign = TextAlign.center,
    this.isSelected = false,
    this.upperCase = false,
    this.id,
    this.isLoading = false,
    this.isDisabled = true,
    this.loadingIndicatorColor = Colors.white,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        decoration: isDisabled
            ? BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                boxShadow: shadowNeuPressed,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              )
            : BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                boxShadow: isSelected ? shadowNeuPressed : shadowNeu,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected ? CustomColors.primary180 : null,
              ),
        child: AbsorbPointer(
          absorbing: isDisabled,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => id != null ? onPressed(id) : onPressed(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width,
                        padding: padding,
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    loadingIndicatorColor,
                                  ),
                                ),
                              )
                            : Text(
                                upperCase ? text.toUpperCase() : text,
                                textAlign: textAlign,
                                style: isDisabled
                                    ? TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: fontWeight,
                                        height: 1.3,
                                        color: CustomColors.mischka,
                                      )
                                    : TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: fontWeight,
                                        height: 1.3,
                                        color: isSelected
                                            ? Colors.white
                                            : CustomColors.blackPearl,
                                      ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
