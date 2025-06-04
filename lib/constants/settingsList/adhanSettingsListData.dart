import 'package:flutter/material.dart';

import 'package:masjidhub/models/settingsListModel.dart';

final List<SettingsListModel> adhanSettingsList = [
  SettingsListModel(
    icon: Icons.notifications,
    title: 'Adhan',
  ),
  SettingsListModel(
    icon: Icons.watch_later,
    title: 'Countdown to Adhan',
    selectedValue: '20 min',
  ),
];
