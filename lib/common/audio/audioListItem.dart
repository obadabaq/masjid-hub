import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class AudioListItem extends StatelessWidget {
  final int id;
  final String title;
  final String subTitle;
  final Function onPressed;
  final Function onAudioPressed;
  final bool isSelected;
  final bool isAudioSelected;
  final double height;

  const AudioListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.onAudioPressed,
    required this.isSelected,
    required this.isAudioSelected,
    this.height = 85,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(id),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final _itemWidth = constraints.maxWidth;
          return Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            margin: EdgeInsets.only(top: 12, bottom: 12),
            decoration: isSelected
                ? ConcaveDecoration(
                    depth: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    colors: innerConcaveShadow,
                    size: Size(_itemWidth, height),
                  )
                : BoxDecoration(
                    color: CustomTheme.lightTheme.colorScheme.background,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: secondaryShadow,
                  ),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? CustomTheme.lightTheme.colorScheme.secondary
                              : CustomColors.blackPearl,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: isSelected
                              ? CustomTheme.lightTheme.colorScheme.secondary
                              : CustomColors.blackPearl.withOpacity(0.7),
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => onAudioPressed(id),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: CustomTheme.lightTheme.colorScheme.background,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: isAudioSelected
                            ? shadowNeuPressed
                            : secondaryShadow,
                        gradient: isAudioSelected
                            ? CustomColors.primary90
                            : CustomColors.grey90,
                      ),
                      child: Icon(
                        isAudioSelected
                            ? Icons.pause
                            : CupertinoIcons.play_fill,
                        size: 23,
                        color: isAudioSelected
                            ? Colors.white
                            : CustomTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
