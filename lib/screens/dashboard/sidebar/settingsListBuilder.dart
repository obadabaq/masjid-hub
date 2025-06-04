import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/models/settingsListModel.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/dashboard/sidebar/SettingsListItem.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/subSettingLayout.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/localizationUtils.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:provider/provider.dart';

class SettingsListBuidler extends StatelessWidget {
  final List<SettingsListModel> list;
  Function? onClick;

  SettingsListBuidler({
    Key? key,
    required this.list,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onSettingsClick({required String title}) {
      if (onClick != null)
        onClick!();
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SubSettingLayout(title: title, contxt: context),
          ),
        );
      }
    }

    String parseSelectedValue(String? title, PrayerTimingsProvider provider) {
      switch (title) {
        case 'Location':
          return Provider.of<LocationProvider>(context, listen: false)
                      .getAutomatic! ==
                  false
              ? "Manual"
              : tr('automatic');
        case 'Calculation Method':
          String madhab =
              tr(PrayerUtils().getMadhabTitleFromId(provider.getMadhabId));
          return madhab.toString();
        case 'Countdown to Adhan':
          return 'min'.tr(args: ['${provider.countdownTimer}']);
        case 'Language':
          return LocalizationUtils().getCurrentLocale(context);
        default:
          return '';
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 8),
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: CustomTheme.lightTheme.colorScheme.background,
        borderRadius: BorderRadius.circular(15),
        boxShadow: tertiaryShadow,
      ),
      child: Consumer<PrayerTimingsProvider>(
        builder: (ctx, prayerTimeProvider, _) => ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int i) {
              return SettingsListItem(
                title: list[i].title,
                selectedValue:
                    parseSelectedValue((list[i].title), prayerTimeProvider),
                requiresDivider: i + 1 != list.length,
                icon: list[i].icon,
                onItemClick: (title) => onSettingsClick(title: list[i].title),
              );
            }),
      ),
    );
  }
}
