import 'package:flutter/material.dart';

import 'package:masjidhub/constants/errors.dart';

class ErrorModalContentModel {
  final AppError error;
  final IconData icon;
  final String title;
  final String subTitle;
  final String buttonText;
  final String subButtonText;
  final Future<bool> Function() onRetry;

  ErrorModalContentModel({
    required this.error,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onRetry,
    this.buttonText = 'Try Again',
    this.subButtonText = '',
  });
}
