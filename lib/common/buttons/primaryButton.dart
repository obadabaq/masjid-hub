import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        decoration: widget.isDisabled
            ? BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                boxShadow: shadowNeuPressed,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              )
            : BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                boxShadow: isPressed ? shadowNeuPressed : shadowNeu,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                gradient: widget.isSelected
                    ? isPressed
                        ? CustomColors.primary180Pressed
                        : CustomColors.primary180
                    : null,
              ),
        child: AbsorbPointer(
          absorbing: widget.isDisabled,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) {
              setState(() => isPressed = false);
              widget.id != null
                  ? widget.onPressed(widget.id)
                  : widget.onPressed();
            },
            onTapCancel: () => setState(() => isPressed = false),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: widget.width,
                        padding: widget.padding,
                        child: widget.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.loadingIndicatorColor,
                                  ),
                                ),
                              )
                            : Text(
                                widget.upperCase
                                    ? widget.text.toUpperCase()
                                    : widget.text,
                                textAlign: widget.textAlign,
                                style: widget.isDisabled
                                    ? TextStyle(
                                        fontSize: widget.fontSize,
                                        fontWeight: widget.fontWeight,
                                        height: 1.3,
                                        color: CustomColors.mischka,
                                      )
                                    : TextStyle(
                                        fontSize: widget.fontSize,
                                        fontWeight: widget.fontWeight,
                                        height: 1.3,
                                        color: widget.isSelected
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
