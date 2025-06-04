import 'package:flutter/material.dart';

import 'package:masjidhub/models/settingsListModel.dart';
import 'package:masjidhub/utils/enums/settingsType.dart';

final List<SettingsListModel> playSettingsList = [
  SettingsListModel(
    icon: Icons.loop,
    title: 'Selection repeat',
    selectedValue: 'Loop',
    type: SettingsType.remoteOnRepeat,
  ),
];
