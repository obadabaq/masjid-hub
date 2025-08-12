import 'package:flutter/material.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';
import 'package:sizer/sizer.dart';

import '../../theme/colors.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    Key? key,
    required this.title,
    required this.onSwitchOn,
    required this.onSwitchOff,
    required this.isLastItem,
    required this.tileValue,
  }) : super(key: key);

  final String title;
  final Function onSwitchOn;
  final Function onSwitchOff;
  final bool isLastItem;
  final bool tileValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => tileValue == true ? onSwitchOff() : onSwitchOn(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: ListTile(
                    title: Text(title),
                    trailing: CustomSwitch(
                        value: tileValue,
                        onChanged: (value) {
                          if (value) {
                            onSwitchOn();
                          } else {
                            onSwitchOff();
                          }
                        })),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: Stack(
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            InnerShadowContainer(
              width: 12.w,
              height: 2.5.h,
              shadowColor: widget.value
                  ? CustomColors.primary[900]?.withValues(alpha: 0.4) ??
                      Colors.black26
                  : Colors.black.withValues(alpha: 0.1),
              isShadowTopLeft: true,
              isShadowTopRight: true,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color:
                      widget.value ? CustomColors.primary[400] : Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  // Top-left shadow
                  BoxShadow(
                    color: Colors.white.withValues(alpha: .5),
                    offset: const Offset(-2, -2),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                  ),
                  // Bottom-right shadow
                  BoxShadow(
                    color: CustomColors.primary[400]?.withValues(alpha: 0.2) ??
                        Colors.white,
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    offset: const Offset(3, 3),
                  ),
                  // Bottom-right shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
