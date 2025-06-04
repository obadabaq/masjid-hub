import 'package:flutter/material.dart';
import 'package:masjidhub/utils/enums/settingsType.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/constants/surahSettingsList/playSettingsList.dart';
import 'package:masjidhub/constants/surahSettingsList/repeatSettings.dart';
import 'package:masjidhub/models/settingsListModel.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/surahSettingsList.dart';
import 'package:masjidhub/constants/surahSettingsList/remoteOffSettingsList.dart';

class SideBarContent extends StatelessWidget {
  const SideBarContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BleProvider>(builder: (ctx, ble, _) {
      final bool isRemoteOn = ble.isRemoteOn;
      final String currentRecitorName = ble.remoteRecitorName;

      final List<SettingsListModel> recitorList = [
        SettingsListModel(
          icon: Icons.record_voice_over,
          title: currentRecitorName,
          type: SettingsType.remoteOnRecitor,
        )
      ];

      return Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: isRemoteOn
                ? [
                    SurahSettingsList(
                      list: recitorList,
                      title: 'reciter',
                      ignoreTranslation: true,
                    ),
                    SurahSettingsList(
                        list: repeatSettings, title: 'play settings'),
                    SurahSettingsList(list: playSettingsList, title: ''),
                    SizedBox(height: 50),
                  ]
                : [
                    SurahSettingsList(list: remoteOffSettingsList, title: ''),
                    SizedBox(height: 50),
                  ],
          ),
        ),
      );
    });
  }
}
