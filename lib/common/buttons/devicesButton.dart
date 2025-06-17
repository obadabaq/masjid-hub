import 'dart:async';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:sizer/sizer.dart';

class DevicesButton extends StatefulWidget {
  DevicesButton({
    Key? key,
    required this.onClick,
    required this.text,
    required this.icon,
    this.height = 150,
    this.width = 150,
    required this.buttonSelected,
  }) : super(key: key);

  final Function onClick;
  final String text;
  final double height;
  final double width;
  final IconData icon;
  final bool buttonSelected;

  @override
  _DevicesButtonState createState() => _DevicesButtonState();
}

class _DevicesButtonState extends State<DevicesButton> {
  // bool _buttonSelected = false;
  List<BoxShadow> _buttonShadow = shadowNeu;

  Future<void> _onButtonTap() async {
    widget.onClick();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          boxShadow: _buttonShadow,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          gradient: widget.buttonSelected ? CustomColors.primary180 : null,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _onButtonTap(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 33.sp,
                    color: widget.buttonSelected
                        ? Colors.white
                        : CustomColors.blackPearl,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: widget.buttonSelected
                          ? Colors.white
                          : CustomColors.blackPearl,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
