import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/common/radioList/RadioListItem.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/customTheme.dart';

class RadioList extends StatelessWidget {
  const RadioList({
    required this.list,
    required this.onItemPressed,
    required this.itemSelected,
    this.width = 300,
    Key? key,
  }) : super(key: key);

  final List<dynamic> list;
  final Function(int) onItemPressed;
  final int itemSelected;
  final double? width;

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
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioListItem(
            title: tr(list[index].title),
            id: list[index].id,
            onPressed: onItemPressed,
            isItemSelected: itemSelected == list[index].id,
            isLastItem: index + 1 == list.length,
          );
        },
      ),
    );
  }
}
