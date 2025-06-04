import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';

class AdhanTimeListItem extends StatelessWidget {
  const AdhanTimeListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.isAlarmDisabled,
    required this.onAlarmButtonClick,
    this.isCurrentPrayer = false,
  }) : super(key: key);

  final int id;
  final String title;
  final String time;
  final IconData icon;
  final bool isAlarmDisabled;
  final bool isCurrentPrayer;
  final Function(int) onAlarmButtonClick;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        margin: EdgeInsets.symmetric(horizontal: 40),
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isCurrentPrayer ? shadowNeuPressed : null,
          gradient: isCurrentPrayer ? CustomColors.primary180 : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 23,
                  color:
                      isCurrentPrayer ? Colors.white : CustomColors.blackPearl,
                ),
                SizedBox(width: 20),
                Text(
                  tr(title.toLowerCase()),
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: isCurrentPrayer
                        ? Colors.white
                        : CustomColors.blackPearl,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                    height: 1.3,
                    color: isCurrentPrayer
                        ? Colors.white
                        : CustomColors.blackPearl,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => onAlarmButtonClick(id),
                  behavior: HitTestBehavior.translucent,
                  child: isCurrentPrayer
                      ? Icon(
                          isAlarmDisabled
                              ? Icons.notifications_off
                              : Icons.notifications,
                          size: 23,
                          color: Colors.white,
                        )
                      : ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: CustomColors.greyIconGradient,
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: Icon(
                            isAlarmDisabled
                                ? Icons.notifications_off
                                : Icons.notifications,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
