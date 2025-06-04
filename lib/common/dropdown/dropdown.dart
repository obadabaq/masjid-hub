import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'dropdownListItem.dart';

class Dropdown extends StatelessWidget {
  final Color color;
  final double width;
  final list;
  final Function onItemPressed;

  const Dropdown({
    Key? key,
    required this.width,
    required this.list,
    required this.onItemPressed,
    this.color = CustomColors.solitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: CustomTheme.lightTheme.colorScheme.background,
        boxShadow: secondaryShadow,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return DropdownListItem(
            title: list[index].title,
            id: list[index].id,
            onPressed: onItemPressed,
          );
        },
      ),
    );
  }
}
