import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class ElevatedSwitch extends StatelessWidget {
  const ElevatedSwitch({
    required this.onClick,
    required this.text,
    required this.icon,
    required this.defaultValue,
    required this.onValueChanged,
    Key? key,
  }) : super(key: key);

  final Function onClick;
  final String text;
  final IconData icon;
  final bool defaultValue;
  final Function onValueChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onClick(),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          boxShadow: tertiaryShadow,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      icon,
                      size: 25,
                      color: CustomColors.mischka,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      tr('automatically detect'),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: CustomColors.blackPearl,
                      ),
                    ),
                  )
                ],
              ),
              Switch(
                thumbColor: WidgetStateProperty.all<Color>(
                    CustomTheme.lightTheme.colorScheme.background),
                value: defaultValue,
                activeTrackColor: CustomTheme.lightTheme.colorScheme.secondary,
                onChanged: (bool) => onValueChanged(bool),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
