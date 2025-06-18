import 'package:flutter/material.dart';

import 'package:masjidhub/common/sidebar/sideAppBar.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/countdown/countdownSubSettings.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/remote/SubSettingsRemote.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/subSettingDevices/SubSettingDevices.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/calculationMethod/SubSettingCalculationMethod.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/language/SubSettingLanguage.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/location/subSettingLocation.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/quranRecitationSpeed/SubSettingsQuranRecitationSpeed.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/quranReciter/SubSettingsQuranReciter.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/subSettingsAdhan/subSettingsAdhan.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/tesbih/tesbihSubSettings.dart';
import 'package:provider/provider.dart';

class SubSettingLayout extends StatelessWidget {
  final BuildContext contxt;
  final String title;

  const SubSettingLayout({
    Key? key,
    required this.contxt,
    required this.title,
  }) : super(key: key);

  Widget switchLocationWidget() {
    switch (title) {
      case 'Location':
        return SubSettingLocation();
      case 'Calculation Method':
        return SubSettingCalculationMethod();
      case 'Language':
        return SubSettingLanguage();
      case 'Quran Recitation Speed':
        return SubSettingsQuranRecitationSpeed();
      case 'Quran Reciter':
        return SubSettingsQuranReciter();
      case 'Devices':
        return SubSettingDevices();
      case 'Adhan':
        return SubSettingsAdhan();
      case 'Countdown to Adhan':
        return SubSettingCountDown();
      case 'Remote':
        return SubSettingsRemote();
      case 'dhikr goal':
        return TesbihSubSettings();
      default:
        return Text('This is settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, location, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: SideAppBar(title: title, contxt: contxt),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [switchLocationWidget()],
              ),
            ),
          ),
        );
      },
    );
  }
}
