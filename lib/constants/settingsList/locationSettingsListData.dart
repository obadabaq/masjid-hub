import 'package:flutter/cupertino.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/models/settingsListModel.dart';

final List<SettingsListModel> locationSettingsList = [
  SettingsListModel(
    icon: AppIcons.locationIcon,
    title: 'Location',
    selectedValue: 'Automatic',
  ),
  SettingsListModel(
    icon: AppIcons.gridIcon,
    title: 'Calculation Method',
    selectedValue: 'Hanafi',
  ),
  SettingsListModel(
    icon: CupertinoIcons.link,
    title: 'Devices',
    selectedValue: 'Automatic',
  )
];
