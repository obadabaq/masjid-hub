import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/gradientRectSliderTrackShape.dart';

class RecitationControlSlider extends StatefulWidget {
  const RecitationControlSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<RecitationControlSlider> createState() =>
      _RecitationControlSliderState();
}

class _RecitationControlSliderState extends State<RecitationControlSlider> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: maxWidth * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                CupertinoIcons.tortoise,
                size: 30,
                color: CustomColors.mischka,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context)
                      .copyWith(trackShape: GradientRectSliderTrackShape()),
                  child: Slider(
                    value: _currentSliderValue,
                    activeColor: CustomColors.irisBlue,
                    inactiveColor:
                        CustomColors.gunPowder.withValues(alpha: 0.1),
                    max: 1.75,
                    min: 0.25,
                    divisions: 6,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.hare,
                size: 30,
                color: CustomColors.mischka,
              ),
            ],
          ),
        );
      },
    );
  }
}
