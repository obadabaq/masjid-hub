import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/models/remoteConnectModel.dart';
import 'package:masjidhub/utils/enums/quranBoxConnectionState.dart';

const String CALCULATING_OFFLINE_PRAYER_TIMES_MSG =
    "Adhan times calculated offline successfully!";

List<RemoteConnectModel> remoteConnectStates = [
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('remote control'),
    subTitle: tr('disconnectedStateButtonText'),
    buttonText: tr('start remote control'),
    state: QuranBoxConnectionState.disconnected,
  ),
  RemoteConnectModel(
    icon: AppIcons.remoteConnecting,
    title: tr('connecting…'),
    subTitle: tr('turnOnDeviceMessage'),
    buttonText: null,
    state: QuranBoxConnectionState.connecting,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('connected!'),
    subTitle: tr('connectionSuccessDescription'),
    buttonText: 'Update MasjidHub',
    state: QuranBoxConnectionState.connected,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('remote control'),
    subTitle: tr('connectBluetooth'),
    buttonText: tr('Try Again'),
    state: QuranBoxConnectionState.noBluetooth,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('updating'),
    subTitle: tr('give us few minutes'),
    buttonText: null,
    state: QuranBoxConnectionState.prayerTimesSync,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('initial setup'),
    subTitle: tr('setting up home masjid'),
    buttonText: null,
    state: QuranBoxConnectionState.OfflinePrayerTimesSync,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('setup complete'),
    subTitle: tr('thank you for waiting'),
    buttonText: tr('let’s go'),
    state: QuranBoxConnectionState.OfflinePrayerTimesSyncComplete,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('update complete'),
    subTitle: tr('thank you for waiting'),
    buttonText: tr('let’s go'),
    state: QuranBoxConnectionState.prayerTimesSyncComplete,
  ),
  RemoteConnectModel(
    icon: AppIcons.remote,
    title: tr('home masjid not detected'),
    subTitle: tr('make sure bluetooth on'),
    buttonText: tr('Try Again'),
    state: QuranBoxConnectionState.deviceNotFound,
  ),
];
