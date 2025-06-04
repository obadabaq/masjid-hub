import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/common/buttons/flatButton.dart';
import 'package:masjidhub/common/snackBar/AppSnackBar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/buttons/neuButton.dart';
import 'package:masjidhub/constants/remoteConnectStates.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/models/remoteConnectModel.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/enums/quranBoxConnectionState.dart';

class RemoteConnectPopup extends StatefulWidget {
  const RemoteConnectPopup({
    Key? key,
    this.isSetup = false,
  }) : super(key: key);

  final bool isSetup;

  @override
  State<RemoteConnectPopup> createState() => _RemoteConnectPopupState();
}

class _RemoteConnectPopupState extends State<RemoteConnectPopup> {
  Timer? timer;

  static const Duration totalTimeForPrayerTimesSync = Duration(minutes: 10);
  static const Duration totalTimeForOfflinePrayerTimesSync =
      Duration(minutes: 4);

  Future<void> setConnectionState(QuranBoxConnectionState state) async =>
      await Provider.of<BleProvider>(context, listen: false).setState(state);

  onSuccessfulConnection() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Provider.of<BleProvider>(context, listen: false).toggleRemote(true);
      if (!widget.isSetup) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        Navigator.pop(context);
      }
    });
  }

  void onButtonClick(
    QuranBoxConnectionState state, {
    bool offlinePrayerTimes = false,
  }) async {
    final BleProvider bleProvider =
        Provider.of<BleProvider>(context, listen: false);

    // There is a bug on this package and it cant detect if ble is switched on
    bool isBluttothSwitchedOn = await bleProvider.isBluetoothSwitchedOn();
    if (!isBluttothSwitchedOn)
      return setConnectionState(QuranBoxConnectionState.noBluetooth);

    bool isNotConnected = state == QuranBoxConnectionState.disconnected ||
        state == QuranBoxConnectionState.noBluetooth ||
        state == QuranBoxConnectionState.deviceNotFound;

    bool isConnected = state == QuranBoxConnectionState.connected;

    try {
      if (isNotConnected) {
        await bleProvider.startScan(onSuccessfulConnection);
      } else if (isConnected) {
        if (offlinePrayerTimes) {
          print("logg:: sending offline prayer times");

          await setConnectionState(
              QuranBoxConnectionState.OfflinePrayerTimesSync);
          bleProvider.sendParametersForOfflineConnection();
        } else {
          print("logg:: sending Updates");

          await setConnectionState(QuranBoxConnectionState.prayerTimesSync);
          bleProvider.synchronizeAdhanTimesWithMasjidHubDevice();
        }

        timer =
            Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));

        Future.delayed(totalTimeForPrayerTimesSync, () => timer?.cancel());
      } else {
        onSuccessfulConnection();
      }
    } catch (e) {
      AppSnackBar().showSnackBar(
        context,
        e,
        onTap: () => setConnectionState(QuranBoxConnectionState.deviceNotFound),
      );
    }
  }

  onModalClose(QuranBoxConnectionState state) {
    bool isConnected = state == QuranBoxConnectionState.connected;
    if (isConnected) return onSuccessfulConnection();
    return Navigator.pop(context);
  }

  int getTimerLabel(Timer? t, Duration totalDuration) {
    final int timerLabel = timer!.tick * 100 ~/ totalDuration.inSeconds;
    if (timerLabel > 99) return 99;
    return timer!.tick * 100 ~/ totalDuration.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Consumer<BleProvider>(builder: (ctx, ble, _) {
          RemoteConnectModel stateData =
              remoteConnectStates.firstWhere((data) => data.state == ble.state);

          bool isSyncing = ble.state == QuranBoxConnectionState.prayerTimesSync;
          bool isDisconnected =
              ble.state == QuranBoxConnectionState.disconnected;
          bool isOfflineTimesSyncing =
              ble.state == QuranBoxConnectionState.OfflinePrayerTimesSync;
          bool isConnecting = ble.state == QuranBoxConnectionState.connecting;
          bool isConnected = ble.state == QuranBoxConnectionState.connected;
          bool isSyncComplete =
              ble.state == QuranBoxConnectionState.prayerTimesSyncComplete ||
                  ble.state ==
                      QuranBoxConnectionState.OfflinePrayerTimesSyncComplete;

          bool hideCloseButton = isSyncing ||
              isConnecting ||
              isSyncComplete ||
              isOfflineTimesSyncing ||
              isConnected;

          int timerLabel = 0;

          if (isSyncing)
            timerLabel = getTimerLabel(timer, totalTimeForPrayerTimesSync);
          if (isOfflineTimesSyncing)
            timerLabel =
                getTimerLabel(timer, totalTimeForOfflinePrayerTimesSync);

          final String updateText =
              isSyncing ? tr('updating') : tr('setting up');

          final _containerWidth = constraints.maxWidth * 0.90;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 30),
                width: _containerWidth,
                decoration: BoxDecoration(
                  color: CustomTheme.lightTheme.colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: shadowNeu,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!hideCloseButton)
                                IconButton(
                                  onPressed: () => onModalClose(ble.state),
                                  icon: Icon(
                                    CupertinoIcons.multiply,
                                    size: 30,
                                    color: CustomColors.blackPearl
                                        .withOpacity(0.4),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: isConnecting
                                    ? EdgeInsets.only(right: 120)
                                    : EdgeInsets.zero,
                                child: Icon(
                                  stateData.icon,
                                  size: 100.0,
                                  color: CustomColors.blackPearl,
                                ),
                              )
                            ],
                          ),
                          if (isConnecting)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: LinearProgressIndicator(
                                color: CustomColors.blackPearl,
                                backgroundColor: CustomColors.solitude,
                              ),
                            ),
                          if (isSyncing || isOfflineTimesSyncing)
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: LinearProgressIndicator(
                                backgroundColor: CustomColors.solitude,
                                value: timerLabel / 100,
                                minHeight: 7,
                                color: CustomColors.blackPearl,
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              isSyncing || isOfflineTimesSyncing
                                  ? '$updateText $timerLabel%'
                                  : stateData.title,
                              style: TextStyle(
                                color: CustomColors.blackPearl,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              stateData.subTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColors.blackPearl.withOpacity(0.7),
                                fontSize: 16,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isConnected)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: Text(
                          tr('update homemasjid'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.blackPearl.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),
                      ),
                    if (isConnected)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                          'timeItWillTake'.tr(args: [
                            '${totalTimeForPrayerTimesSync.inMinutes}'
                          ]),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.blackPearl.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),
                      ),
                    if (!isSyncing && !isConnecting && !isOfflineTimesSyncing)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: NeuButton(
                          isSelected: true,
                          onClick: () => onButtonClick(ble.state),
                          height: 65,
                          width: _containerWidth * 0.90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 12, right: 10),
                                child: Text(
                                  stateData.buttonText ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 1.3,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (isConnected)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: CustomFlatButton(
                          onPressed: () => onButtonClick(
                            ble.state,
                            offlinePrayerTimes: true,
                          ),
                          text: tr('update later'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
