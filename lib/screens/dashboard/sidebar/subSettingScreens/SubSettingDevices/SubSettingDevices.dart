import 'package:flutter/material.dart';

import 'package:masjidhub/screens/setupScreens/chooseDevice/chooseDeviceComponent.dart';

class SubSettingDevices extends StatelessWidget {
  const SubSettingDevices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChooseDeviceComponent(),
      ],
    );
  }
}
