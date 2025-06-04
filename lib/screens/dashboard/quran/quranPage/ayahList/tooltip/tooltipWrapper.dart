import 'package:flutter/cupertino.dart';

import 'package:masjidhub/theme/colors.dart';

// Wrapper is used to position tooltip
class TooltipWrapper extends StatelessWidget {
  const TooltipWrapper({
    Key? key,
    required this.posY,
    required this.tooltip,
  }) : super(key: key);

  final double posY;
  final Widget tooltip;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isFirstAyah = posY < 100;

    double topCenterPos = posY - 40;
    double bottomCenterPos = posY + 135;

    double containerPosY = isFirstAyah ? bottomCenterPos : topCenterPos;

    return Positioned(
      top: containerPosY,
      child: Container(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Visibility(
                    visible: isFirstAyah,
                    child: Container(
                      transform: Matrix4.translationValues(0.0, 3.0, 0.0),
                      child: Icon(
                        CupertinoIcons.arrowtriangle_up_fill,
                        size: 15,
                        color: CustomColors.nero,
                      ),
                    ),
                  ),
                  tooltip,
                  Visibility(
                    visible: !isFirstAyah,
                    child: Container(
                      transform: Matrix4.translationValues(0.0, -3.0, 0.0),
                      child: Icon(
                        CupertinoIcons.arrowtriangle_down_fill,
                        size: 15,
                        color: CustomColors.nero,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
