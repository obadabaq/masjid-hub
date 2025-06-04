import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:masjidhub/models/errorModalContentModel.dart';
import 'package:masjidhub/utils/errorUtils.dart';

var AppErrorcontext;
enum AppError { noInternet, noGPS, noNotifications, noSurah,bluetooth }

final List<ErrorModalContentModel> errorList = [
  ErrorModalContentModel(
    error: AppError.noInternet,
    title: tr('No Internet Connection'),
    subTitle:
        tr('Please enable Wifi or Cellular Data to view updated prayer times.'),
    icon: CupertinoIcons.wifi_slash,
    onRetry: () => ErrorUtils().onNetworkConnectRetry(),
  ),
  ErrorModalContentModel(
    error: AppError.bluetooth,
    title: "Unable to connect to Watch",
    subTitle: "Check if Bluetooth is enabled, watch is within range and is not connected to another device.",
    icon: CupertinoIcons.bluetooth,
    buttonText: 'Close',
    onRetry: () => ErrorUtils().onBluetoothRetry(),
  ),
  ErrorModalContentModel(
    error: AppError.noGPS,
    title: tr('No GPS Connection'),
    subTitle: tr('Please enable GPS to access location settings.'),
    icon: CupertinoIcons.wifi_slash,
    onRetry: () => ErrorUtils().onGPSConnectRetry(),
    buttonText: tr('Close'),
  ),
  ErrorModalContentModel(
    error: AppError.noNotifications,
    title: tr('Notifications Disabled'),
    subTitle: tr('Please allow us to show notifications for Adhan timings.'),
    icon: CupertinoIcons.bell_slash,
    onRetry: () => ErrorUtils().onNotificationsRetry(),
    buttonText: tr('Allow'),
  ),
  ErrorModalContentModel(
    error: AppError.noSurah,
    title: tr('Surah Audio not downloaded'),
    subTitle: tr(
        'Please go back to the main screen to download surah audio files in order to play them here.'),
    icon: CupertinoIcons.cloud_download,
    onRetry: () => ErrorUtils().onNoSurahFound(),
    buttonText: tr('Back to Surah'),
    subButtonText: tr('Go to Main Screen'),
  )
];
