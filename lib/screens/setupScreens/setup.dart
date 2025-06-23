import 'package:flutter/material.dart';
import 'package:masjidhub/screens/setupScreens/chooseAdhan/chooseAdhan.dart';
import 'package:masjidhub/screens/setupScreens/chooseCountdown/chooseCountdown.dart';
import 'package:masjidhub/screens/setupScreens/chooseDevice/chooseDevice.dart';
import 'package:masjidhub/screens/setupScreens/chooseLocation/chooseLocation.dart';
import 'package:masjidhub/screens/setupScreens/choosePrayerTime/choosePrayerTime.dart';
import 'package:masjidhub/screens/setupScreens/chooseTesbih/chooseTesbih.dart';
import 'package:provider/provider.dart';
import 'package:masjidhub/provider/setupProvider.dart';

class Setup extends StatefulWidget {
  Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<SetupProvider>(
      builder: (ctx, setupProvider, _) => PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: setupProvider.setupController,
        children: [
          ChooseLocation(pageController: setupProvider.setupController),
          ChooseAdhan(pageController: setupProvider.setupController),
          ChooseCountdown(pageController: setupProvider.setupController),
          ChoosePrayerTime(pageController: setupProvider.setupController),
          ChooseTesbih(pageController: setupProvider.setupController),
          ChooseDevice(pageController: setupProvider.setupController)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
