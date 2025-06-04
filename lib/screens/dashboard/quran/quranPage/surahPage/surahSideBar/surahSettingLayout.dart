import 'package:flutter/material.dart';

import 'package:masjidhub/common/sidebar/sideAppBar.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/surahTranslation/SubSettingsSurahTranslation.dart';
import 'package:masjidhub/utils/enums/settingsType.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/remoteOnLoop/SubSettingsRemoteOnLoop.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/remoteOnSelection/SubSettingsRemoteOnSelection.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/quranRecitationSpeed/SubSettingsQuranRecitationSpeed.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/remoteOnQuranReciter/SubSettingsRemoteOnQuranReciter.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/quranReciter/SubSettingsQuranReciter.dart';

class SurahSettingLayout extends StatelessWidget {
  final BuildContext contxt;
  final String title;
  final SettingsType? type;

  const SurahSettingLayout({
    Key? key,
    required this.contxt,
    required this.type,
    required this.title,
  }) : super(key: key);

  Widget switchLocationWidget() {
    switch (type) {
      case SettingsType.recitor:
        return SubSettingsQuranReciter();
      case SettingsType.remoteOnRecitor:
        return SubSettingsRemoteOnQuranReciter();
      case SettingsType.playbackRate: // same for remote on and remote off
        return SubSettingsQuranRecitationSpeed();
      case SettingsType.remoteOnRepeat:
        return SubSettingsRemoteOnLoop();
      case SettingsType.remoteOnSelection:
        return SubSettingsRemoteOnSelection();
      case SettingsType.translation: // For surah translation
        return SubSettingsSurahTranslation();
      default:
        return Text('This is settings');
    }
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
