import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/gradientRectSliderTrackShape.dart';
import 'package:masjidhub/provider/bleProvider.dart';

class VolumeControlSliderComponent extends StatefulWidget {
  const VolumeControlSliderComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<VolumeControlSliderComponent> createState() =>
      _VolumeControlSliderComponentState();
}

class _VolumeControlSliderComponentState
    extends State<VolumeControlSliderComponent> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          width: maxWidth * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.volume_mute,
                size: 25,
                color: CustomColors.mischka,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context)
                      .copyWith(trackShape: GradientRectSliderTrackShape()),
                  child: Consumer<BleProvider>(
                    builder: (ctx, ble, _) => Slider(
                      value: ble.getRemoteVoume,
                      activeColor: CustomColors.irisBlue,
                      inactiveColor:
                          CustomColors.gunPowder.withValues(alpha: 0.1),
                      max: 10,
                      min: 0,
                      onChangeEnd: (double value) => ble.changeVolume(value),
                      onChanged: (double value) => ble.setRemoteVolume(value),
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.volume_up,
                size: 25,
                color: CustomColors.mischka,
              ),
            ],
          ),
        );
      },
    );
  }
}
