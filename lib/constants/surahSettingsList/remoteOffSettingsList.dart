import 'package:flutter/material.dart';

import 'package:masjidhub/models/settingsListModel.dart';
import 'package:masjidhub/utils/enums/settingsType.dart';

final List<SettingsListModel> remoteOffSettingsList = [
  SettingsListModel(
    icon: Icons.record_voice_over,
    title: '',
    type: SettingsType.recitor,
  ),
  SettingsListModel(
    icon: Icons.translate,
    title: 'translation',
    type: SettingsType.translation,
  ),
  SettingsListModel(
    icon: Icons.speed,
    title: 'Speed',
    type: SettingsType.playbackRate,
  ),
];
