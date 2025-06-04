import 'package:flutter/material.dart';
import 'package:masjidhub/utils/enums/settingsType.dart';

class SettingsListModel {
  final IconData? icon;
  final String title;
  final String? selectedValue;
  final SettingsType? type;

  SettingsListModel({
    this.icon,
    required this.title,
    this.selectedValue,
    this.type,
  });
}
