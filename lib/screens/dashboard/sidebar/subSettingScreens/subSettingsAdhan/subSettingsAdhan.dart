import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/screens/setupScreens/chooseAdhan/chooseAdhanComponent.dart';
import 'package:masjidhub/theme/colors.dart';

class SubSettingsAdhan extends StatelessWidget {
  const SubSettingsAdhan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
            child: Text(
              tr('selectPrayersForAlarms'),
              style: TextStyle(
                fontSize: 16.0,
                height: 1.3,
                color: CustomColors.blackPearl.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ChooseAdhanComponent(),
        ],
      ),
    );
  }
}
