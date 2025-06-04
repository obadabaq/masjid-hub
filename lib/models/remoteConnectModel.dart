import 'package:flutter/material.dart';
import 'package:masjidhub/utils/enums/quranBoxConnectionState.dart';

class RemoteConnectModel {
  final IconData icon;
  final String title;
  final String subTitle;
  final String? buttonText;
  final QuranBoxConnectionState state;

  RemoteConnectModel({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.state,
  });
}
