import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/screens/setupScreens/chooseDevice/chooseDeviceComponent.dart';
import 'package:masjidhub/theme/colors.dart';

class SubSettingDevices extends StatelessWidget {
  const SubSettingDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0, left: 29, right: 29, bottom: 30),
          child: Text(
            tr('connectDeviceText'),
            style: TextStyle(
              fontSize: 16.0,
              height: 1.3,
              color: CustomColors.blackPearl.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ChooseDeviceComponent(),
      ],
    );
  }
}
