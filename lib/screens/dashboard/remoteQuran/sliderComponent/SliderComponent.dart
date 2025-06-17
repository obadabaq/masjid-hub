import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/gradientRectSliderTrackShape.dart';

class SliderComponent extends StatefulWidget {
  const SliderComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<SliderComponent> createState() => _SliderComponentState();
}

class _SliderComponentState extends State<SliderComponent> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        return Container(
          width: maxWidth * 0.9,
          child: SliderTheme(
            data: SliderTheme.of(context)
                .copyWith(trackShape: GradientRectSliderTrackShape()),
            child: Slider(
              value: _currentSliderValue,
              activeColor: CustomColors.irisBlue,
              inactiveColor: CustomColors.gunPowder.withValues(alpha: 0.1),
              max: 100,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
