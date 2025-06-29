import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/theme/colors.dart';

class SettingsListItem extends StatelessWidget {
  const SettingsListItem({
    Key? key,
    required this.onItemClick,
    this.icon,
    required this.title,
    required this.requiresDivider,
    required this.selectedValue,
    this.ignoreTranslation = false,
  }) : super(key: key);

  final Function(String) onItemClick;
  final IconData? icon;
  final String title;
  final bool requiresDivider;
  final String selectedValue;
  final bool ignoreTranslation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onItemClick(title),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: 19,
                    color: CustomColors.darkMischka,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      ignoreTranslation ? title : tr(title.toLowerCase()),
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.blackPearl,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (selectedValue.isNotEmpty)
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Text(
                              selectedValue,
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.mischka,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: CustomColors.mischka,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (requiresDivider) Divider(),
      ],
    );
  }
}
