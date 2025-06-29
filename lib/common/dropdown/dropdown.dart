import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'dropdownListItem.dart';

class Dropdown extends StatefulWidget {
  final Color color;
  final double width;
  final list;
  final Function(String id, String title) onItemPressed;
  final selectedValue;

  const Dropdown({
    Key? key,
    required this.width,
    required this.list,
    required this.onItemPressed,
    this.color = CustomColors.solitude,
  })  : selectedValue = null,
        super(key: key);

  const Dropdown.button({
    Key? key,
    required this.width,
    required this.list,
    required this.onItemPressed,
    required this.selectedValue,
    this.color = CustomColors.solitude,
  }) : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.selectedValue != null
          ? () {
              setState(() {
                isOpened = true;
              });
            }
          : null,
      child: Container(
        width: widget.width,
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
          itemCount:
              widget.selectedValue == null || isOpened ? widget.list.length : 1,
          itemBuilder: (BuildContext context, int index) {
            if (!isOpened && widget.selectedValue != null) {
              return DropdownListItem(
                title: widget.selectedValue.title,
                id: widget.selectedValue.id.toString(),
                onPressed: (id, title) {
                  setState(() {
                    isOpened = true;
                  });
                },
              );
            }
            return DropdownListItem(
              title: widget.list[index].title,
              id: widget.list[index].id.toString(),
              isSelected: widget.selectedValue != null
                  ? widget.selectedValue.id.toString() ==
                      widget.list[index].id.toString()
                  : false,
              onPressed: (id, title) {
                widget.onItemPressed(id, title);
                setState(() {
                  isOpened = false;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
