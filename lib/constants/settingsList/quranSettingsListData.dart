import 'package:flutter/material.dart';

import 'package:masjidhub/models/settingsListModel.dart';

final List<SettingsListModel> quranSettingsList = [
  SettingsListModel(
    icon: Icons.speed,
    title: 'Quran Recitation Speed',
    selectedValue: 'Normal',
  ),
  SettingsListModel(
    icon: Icons.record_voice_over,
    title: 'Quran Reciter',
    selectedValue: 'Imam Faisal',
  ),
];
