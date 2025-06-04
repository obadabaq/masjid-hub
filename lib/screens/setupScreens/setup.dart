import 'package:flutter/material.dart';

import 'package:masjidhub/screens/setupScreens/chooseAdhan/chooseAdhan.dart';
import 'package:masjidhub/screens/setupScreens/chooseCountdown/chooseCountdown.dart';
import 'package:masjidhub/screens/setupScreens/chooseDevice/chooseDevice.dart';
import 'package:masjidhub/screens/setupScreens/chooseLocation/chooseLocation.dart';
import 'package:masjidhub/screens/setupScreens/choosePrayerTime/choosePrayerTime.dart';
import 'package:masjidhub/screens/setupScreens/chooseTesbih/chooseTesbih.dart';

class Setup extends StatefulWidget {
  Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final PageController setupController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void dispose() {
    setupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: setupController,
      children: [
        ChooseLocation(pageController: setupController),
        ChooseAdhan(pageController: setupController),
        ChooseCountdown(pageController: setupController),
        ChoosePrayerTime(pageController: setupController),
        ChooseTesbih(pageController: setupController),
        ChooseDevice(pageController: setupController)
      ],
    );
  }
}
