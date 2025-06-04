import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class RadioListItem extends StatelessWidget {
  const RadioListItem({
    required this.title,
    required this.id,
    required this.onPressed,
    required this.isItemSelected,
    this.isLastItem = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final int id;
  final Function onPressed;
  final bool isLastItem;
  final bool isItemSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(id),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      margin: EdgeInsets.only(right: 15),
                      decoration: isItemSelected
                          ? BoxDecoration(
                              color:
                                  CustomTheme.lightTheme.colorScheme.secondary,
                              shape: BoxShape.circle,
                              boxShadow: shadowDotActive,
                            )
                          : ConcaveDecoration(
                              depth: 7,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              colors: innerConcaveShadow,
                              size: Size(20, 20),
                            ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth - 35,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.blackPearl,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (!isLastItem) Divider(),
            ],
          );
        },
      ),
    );
  }
}
