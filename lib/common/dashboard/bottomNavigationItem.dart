import 'package:flutter/material.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';
import 'package:provider/provider.dart';
import 'package:masjidhub/provider/bottom_bar_provider.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final Function(int) onItemPressed;
  final int currentIndex;
  final bool isNewFeature;

  const BottomNavigationItem({
    required this.index,
    required this.onItemPressed,
    required this.label,
    required this.icon,
    required this.currentIndex,
    this.isNewFeature = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isSelected = index == currentIndex;
    bool _isQiblaIcon = index == 1;
    double _iconContainerLength = 8.5.h;
    final state = Provider.of<BottomBarProvider>(context, listen: true);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onItemPressed(index),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: state.isNavBarVisible ? _iconContainerLength + 20 : 0,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: _iconContainerLength,
                    height: _iconContainerLength,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: _isSelected
                        ? ConcaveDecoration(
                            depth: 9,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            colors: innerConcaveShadow,
                            size: Size(
                                _iconContainerLength, _iconContainerLength),
                          )
                        : BoxDecoration(
                            boxShadow: tertiaryShadow,
                            color: CustomColors.solitude,
                            borderRadius: BorderRadius.circular(20),
                          ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: _isQiblaIcon ? 40 : 30,
                        color: _isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : CustomColors.mischka,
                      ),
                    ),
                  ),
                ),
                Text(
                  label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 1.3,
                    fontSize: 14.0,
                    color: _isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : CustomColors.mischka,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isNewFeature,
            child: Container(
              width: 15,
              height: 15,
              margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
              decoration: BoxDecoration(
                boxShadow: shadowTesbihDot,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                gradient: CustomColors.primary180,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
