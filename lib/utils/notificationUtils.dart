import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/adhans.dart';
import 'package:masjidhub/constants/prayerNames.dart';
import 'package:masjidhub/constants/timerAudio.dart';
import 'package:masjidhub/models/adhanNotificationModel.dart';
import 'package:masjidhub/models/adhanTimeModel.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class NotificationUtils {
  final String azanChannel = 'azan';
  final String muteChannel = 'azan_mute';
  final String countDownChannel = 'azan_countdown';

  init({required Function onFailure}) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) onFailure();
    });

    int selectedTimerAudioId = SharedPrefs().getSelectedCountdownAudioId;
    int selectedAzanAudioId = SharedPrefs().getSelectedAdhanId;

    AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
      NotificationChannel(
        channelKey: azanChannel,
        channelName: 'Azan Notifications',
        channelDescription:
            'Notification channel for scheduled Azan notifications',
        defaultColor: CustomColors.irisBlue,
        locked: false,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        soundSource:
            PrayerUtils().slugToSource(adhanList[selectedAzanAudioId].urlSlug),
        playSound: true,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
      ),
      NotificationChannel(
        channelKey: countDownChannel,
        channelName: 'Countdown Notifications',
        channelDescription:
            'Notification channel for scheduled Azan countdowns notifications',
        defaultColor: CustomColors.irisBlue,

        locked: false,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        soundSource: PrayerUtils()
            .slugToSource(timerAudioList[selectedTimerAudioId].urlSlug),
        playSound: true,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
      ),
      NotificationChannel(
        channelKey: muteChannel,
        channelName: 'Azan Notifications Muted',
        channelDescription:
            'Notification channel for scheduled Azan muted notifications',
        defaultColor: CustomColors.irisBlue,
        locked: false,
        ledColor: Colors.white,
        playSound: false,
        importance: NotificationImportance.Default,
      )
    ]);
  }

  Future<void> requestPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed)
        AwesomeNotifications().requestPermissionToSendNotifications();
    });
  }

  int createUniqueId() {
    return new Random().nextInt(100000000);
  }

  Future<void> registerNotification({
    required AdhanNotificationModel notification,
    required String timeZone,
  }) async {
    final String azanNotificationChannel =
        notification.playSound ? azanChannel : muteChannel;

    final String countdownNotificationChannel =
        notification.playSound ? countDownChannel : muteChannel;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: notification.isCountdown
            ? countdownNotificationChannel
            : azanNotificationChannel,
        title: notification.title,
        body: notification.text,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Lets Pray',
        )
      ],
      schedule: NotificationCalendar(
        hour: notification.hour,
        minute: notification.minute,
        weekday: notification.weekday,
        second: 0,
        millisecond: 0,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: timeZone,
      ),
    );
  }

  dispose() {
    AwesomeNotifications().cancelAll();
  }

  Future<List<AdhanNotificationModel>> createNotificationList(
    List<AdhanTimeModel> prayerTimes,
  ) async {
    List<AdhanNotificationModel> notificationList = [];
    final int alertTime = SharedPrefs().getCountdownTimer;

    final List<int> dayOfWeek = [1, 2, 3, 4, 5, 6, 7];

    prayerTimes.asMap().forEach(
      (i, prayerTim) async {
        final AdhanTimeModel azan = prayerTim;
        final String formattedTime = azan.time;
        final DateTime time = DateFormat('jm').parse(formattedTime);
        final hour = time.hour;
        final minute = time.minute;
        final playSound = !azan.isAlarmDisabled;
        final bool isDhuhrPrayer = i == 2; // TODO test this change

        final DateTime countDownTime =
            time.subtract(Duration(minutes: alertTime));
        final countDownTimeHour = countDownTime.hour;
        final countDownTimeMinute = countDownTime.minute;

        final String prayer = prayerNames.elementAt(prayerTimes[i].id);

        final String letsPray = 'Lets\'s Pray';
        final String letsGetReady = 'Lets\'s get ready!';

        if (!isDhuhrPrayer) {
          notificationList.add(
            AdhanNotificationModel(
              hour: hour,
              minute: minute,
              title:i != 1 ? 'time for prayer'.tr(args: ['$prayer']):'Sun is rising!',
              text: i != 1 ?letsPray:'Alhamdulillah for today!',
              playSound: playSound,
              isCountdown: false,
            ),
          );
          notificationList.add(
            AdhanNotificationModel(
              hour: countDownTimeHour,
              minute: countDownTimeMinute,
              title: i != 1 ?  'mins left'.tr(args: ['$alertTime', '$prayer']):'$alertTime mins left to Sunrise',
              text:i != 1 ? letsGetReady : 'Have you prayed Fajr?',
              playSound: playSound,
              isCountdown: true,
            ),
          );
        } else {
          dayOfWeek.forEach(
            (dayOfWeek) async {
              final bool isFriday = dayOfWeek == 5;
              final String prayerTitle = isFriday ? 'Jummah' : 'Dhuhr';

              final String prayerNotificationTitle =
                  'time for prayer'.tr(args: ['$prayerTitle']);
              final String countDownNotificationTitle =
                  'mins left'.tr(args: ['$alertTime', '$prayer']);

              notificationList.add(
                AdhanNotificationModel(
                  hour: hour,
                  minute: minute,
                  title: prayerNotificationTitle,
                  text: letsPray,
                  playSound: playSound,
                  isCountdown: false,
                  weekday: dayOfWeek,
                ),
              );

              notificationList.add(
                AdhanNotificationModel(
                  hour: countDownTimeHour,
                  minute: countDownTimeMinute,
                  title: countDownNotificationTitle,
                  text: letsGetReady,
                  playSound: playSound,
                  isCountdown: true,
                  weekday: dayOfWeek,
                ),
              );
            },
          );
        }
      },
    );

    notificationList.add(
      AdhanNotificationModel(
        hour: 0,
        minute: 0,
        title: tr('prayer notifications on'),
        text: tr('due to device limitations'),
        playSound: false,
        isCountdown: false,
        weekday: 2, // Remind every Tuesday
      ),
    );

    return notificationList;
  }

  Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  Future<void> createNotification(List<AdhanTimeModel>? prayerTimes) async {
    if (prayerTimes != null) {
      await cancelScheduledNotifications();

      await requestPermission();

      final String localTimeZone =
          await AwesomeNotifications().getLocalTimeZoneIdentifier();

      final List<AdhanNotificationModel> list =
          await createNotificationList(prayerTimes);

      for (var i = 0; i < list.length; i++)
        registerNotification(notification: list[i], timeZone: localTimeZone);
    }

  }
}
