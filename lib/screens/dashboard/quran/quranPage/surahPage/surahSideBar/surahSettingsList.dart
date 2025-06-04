import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/models/settingsListModel.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/surahSettingLayout.dart';
import 'package:masjidhub/screens/dashboard/sidebar/SettingsListItem.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/enums/settingsType.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/utils/bleUtils.dart';

class SurahSettingsList extends StatelessWidget {
  final List<SettingsListModel> list;
  final String title;
  final bool ignoreTranslation;

  const SurahSettingsList({
    Key? key,
    required this.list,
    required this.title,
    this.ignoreTranslation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getPageTitle(SettingsType? setingsType, String title) {
      switch (setingsType) {
        case SettingsType.remoteOnRecitor:
        case SettingsType.recitor:
          return "Recitor";
        case SettingsType.remoteOnSelection:
          return "Recite";
        default:
          return title;
      }
    }

    void onSettingsClick({required String title, SettingsType? type}) {
      String pageTitle = getPageTitle(type, title);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SurahSettingLayout(title: pageTitle, contxt: context, type: type),
        ),
      );
    }

    String parseSelectedValue(
      SettingsType? type,
      AudioProvider audioProvider,
      BleProvider bleProvider,
      QuranProvider quranProvider,
    ) {
      final int loopCount = bleProvider.remoteOnSurahLoopCount;
      final String loopLabel = BleUtils().getLoopLabel(loopCount);

      switch (type) {
        case SettingsType.playbackRate:
          return audioProvider.quranPlaybackRate.toString();
        case SettingsType.remoteOnRepeat:
          return loopLabel;
        case SettingsType.translation:
          return QuranUtils()
              .getSurahTranslationName(quranProvider.surahTranslationLanguage);
        default:
          return '';
      }
    }

    String parseSettingsTitle(
      SettingsType? type,
      String defaultTitle,
      QuranProvider quranProvider,
    ) {
      final int recitorId = quranProvider.quranReciter;

      switch (type) {
        case SettingsType.recitor:
          return QuranUtils().getRemoteOffRecitor(recitorId);
        default:
          return defaultTitle;
      }
    }

    bool isTitleEmpty = title.isEmpty;

    return Column(
      children: [
        if (!isTitleEmpty)
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: Text(
                  tr(title),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: CustomColors.mischka,
                  ),
                ),
              )
            ],
          ),
        Container(
          margin: EdgeInsets.only(top: isTitleEmpty ? 10 : 20, bottom: 30),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: CustomTheme.lightTheme.colorScheme.background,
            borderRadius: BorderRadius.circular(15),
            boxShadow: tertiaryShadow,
          ),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int i) {
              return Consumer<AudioProvider>(
                builder: (ctx, audioProvider, _) => Consumer<BleProvider>(
                  builder: (ctx, ble, _) => Consumer<QuranProvider>(
                    builder: (ctx, quranProvider, _) => SettingsListItem(
                      title: parseSettingsTitle(
                        list[i].type,
                        list[i].title,
                        quranProvider,
                      ),
                      selectedValue: parseSelectedValue(
                        list[i].type,
                        audioProvider,
                        ble,
                        quranProvider,
                      ),
                      ignoreTranslation: ignoreTranslation,
                      requiresDivider: i + 1 != list.length,
                      icon: list[i].icon,
                      onItemClick: (title) => onSettingsClick(
                        title: list[i].title,
                        type: list[i].type,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
