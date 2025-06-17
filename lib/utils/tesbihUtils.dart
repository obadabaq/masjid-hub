import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:masjidhub/models/tesbih/tesbihDataModel.dart';
import 'package:masjidhub/models/tesbih/tesbihAnalyticsColumnModel.dart';
import 'package:masjidhub/utils/enums/tesbihAnalyticsEnums.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

enum TesbihSection { dial, analytics }

class TesbihUtils {
  Future<void> init() async {
    await cleanupTodaysDate();
    await sanitizeOldDailyAnaliticsList();
    await sanitizeOldWeeklyAnaliticsList();
    await sanitizeOldMonthlyAnaliticsList();
  }

  // Make cummulative todays tesbih count 0 if not today
  Future<void> cleanupTodaysDate() async {
    final TesbihDataModel? todaysCummulativeTesbihCount =
        SharedPrefs().todaysCummulativeTesbihCount;
    if (todaysCummulativeTesbihCount != null) {
      final DateTime dateOfTesbihData = DateTime.fromMillisecondsSinceEpoch(
          todaysCummulativeTesbihCount.unixDate);
      final bool isToday = PrayerUtils().selectedDateIsToday(dateOfTesbihData);

      if (!isToday) SharedPrefs().resetTodaysCummulativeTesbihCount();
    }
  }

  int getTesbihBeads(int tesbihCount) {
    int thresholdCount = (tesbihCount / 33).floor();
    int count = tesbihCount - (thresholdCount > 0 ? (thresholdCount) * 33 : 0);
    return count;
  }

  Future<void> scrollToTesbihSection(
    ScrollController controller,
    TesbihSection section,
  ) async {
    bool toAnalytics = section == TesbihSection.analytics;
    controller.animateTo(
      toAnalytics
          ? controller.position.maxScrollExtent - 100
          : controller.position.minScrollExtent,
      duration: Duration(milliseconds: 350),
      curve: Curves.linear,
    );
  }

  // Daily
  List<String> getDailyColumnLabel = [
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat',
    'Sun'
  ];

  // Weekly
  List<String> getWeeklyColumnLabel(int firstIndexDate) {
    List<String> weeklyColumnsList = List.filled(7, '');
    final DateFormat formatter = DateFormat('MMM');

    final DateTime today = DateTime.fromMillisecondsSinceEpoch(firstIndexDate);

    for (var i = 0; i < 7; i++) {
      final DateTime date = today.add(Duration(days: i * 7));
      final int day = date.day;
      final String dateLabel = "${formatter.format(date)} $day"; // Jul 17
      weeklyColumnsList[i] = dateLabel;
    }

    return weeklyColumnsList;
  }

  TesbihAnalyticsColumnModel emptyColumn =
      TesbihAnalyticsColumnModel(count: 0, label: '', progress: 0);

  List<TesbihAnalyticsColumnModel> getDailyAnalyticsData(
    List<TesbihDataModel> savedData,
    int tesbihGoal,
  ) {
    List<TesbihAnalyticsColumnModel> dailyColumnsList = [
      for (var i = 0; i < 7; i++)
        TesbihAnalyticsColumnModel(
          count: 0,
          label: getDailyColumnLabel[i],
          progress: 0,
        )
    ];

    if (savedData.length == 0) return dailyColumnsList; // When no Data

    savedData.forEach((el) {
      final int dayOfWeek =
          DateTime.fromMillisecondsSinceEpoch(el.unixDate).weekday;
      final double progressFactor = el.count / tesbihGoal;
      final bool fullProgress = progressFactor > 1;

      dailyColumnsList[dayOfWeek - 1] = TesbihAnalyticsColumnModel(
        count: el.count,
        label: getDailyColumnLabel[dayOfWeek - 1],
        progress: fullProgress ? 1 : el.count / tesbihGoal,
      );
    });

    return dailyColumnsList;
  }

  Future<void> sanitizeOldDailyAnaliticsList() async {
    final List<TesbihDataModel> oldList =
        SharedPrefs().getTesbihAnalyticsDailyList;

    final DateTime today = DateTime.now();
    final int todaysWeekDay = today.weekday;

    final List<TesbihDataModel> newList = oldList
        .where((el) =>
            DateTime.fromMillisecondsSinceEpoch(el.unixDate).weekday <=
            todaysWeekDay)
        .toList();

    SharedPrefs().setTesbihAnalyticsDailyList(newList);
  }

  TesbihDataModel getTesbihData(
      int dailyCountIncrement, TesbihAnalyticsState state) {
    final int unixDate = DateTime.now().millisecondsSinceEpoch;

    return TesbihDataModel(count: dailyCountIncrement, unixDate: unixDate);
  }

  List<TesbihAnalyticsColumnModel> getWeeklyAnalyticsData(
    List<TesbihDataModel> savedData,
    int tesbihGoal,
  ) {
    final int weeklyTesbihGoal =
        tesbihGoal * TesbihAnalyticsState.weekly.multiples;

    bool noSavedData = savedData.length == 0;

    int firstUnixDate = noSavedData
        ? DateTime.now().millisecondsSinceEpoch
        : savedData[0].unixDate;

    final List<String> columnsList = getWeeklyColumnLabel(firstUnixDate);

    List<TesbihAnalyticsColumnModel> weeklyColumnsList = [
      for (var i = 0; i < 7; i++)
        TesbihAnalyticsColumnModel(
          count: 0,
          label: columnsList[i],
          progress: 0,
        )
    ];

    if (savedData.length == 0) return weeklyColumnsList; // When no Data

    for (var i = 0; i < savedData.length; i++) {
      final int count = savedData[i].count;

      final double progressFactor = count / weeklyTesbihGoal;
      final bool fullProgress = progressFactor > 1;

      final TesbihAnalyticsColumnModel columnData = TesbihAnalyticsColumnModel(
        count: count,
        label: columnsList[i],
        progress: fullProgress ? 1 : progressFactor,
      );
      weeklyColumnsList[i] = columnData;
    }

    return weeklyColumnsList;
  }

  // Remove weekly data if more than 7 weeks old
  Future<void> sanitizeOldWeeklyAnaliticsList() async {
    final List<TesbihDataModel> oldList =
        SharedPrefs().getTesbihAnalyticsWeeklyList;

    final DateTime today = DateTime.now();

    final List<TesbihDataModel> newList = oldList
        .where((el) =>
            today
                .difference(DateTime.fromMillisecondsSinceEpoch(el.unixDate))
                .inDays <
            48)
        .toList();

    SharedPrefs().setTesbihAnalyticsWeeklyList(newList);
  }

  // Monthly
  List<String> getMonthlyColumnLabel(int firstIndexDate) {
    List<String> monthlyColumnsList = List.filled(7, '');
    final DateFormat formatter = DateFormat('MMM');

    final DateTime today = DateTime.fromMillisecondsSinceEpoch(firstIndexDate);

    for (var i = 0; i < 7; i++) {
      final DateTime date =
          today.add(Duration(days: i * 30)); // Assuming 30 days in one month

      final String dateLabel = "${formatter.format(date)}"; // Jul
      monthlyColumnsList[i] = dateLabel;
    }

    return monthlyColumnsList;
  }

  List<TesbihAnalyticsColumnModel> getMonthlyAnalyticsData(
    List<TesbihDataModel> savedData,
    int tesbihGoal,
  ) {
    final int monthlyTesbihGoal =
        tesbihGoal * TesbihAnalyticsState.monthly.multiples;

    bool noSavedData = savedData.length == 0;

    int firstUnixDate = noSavedData
        ? DateTime.now().millisecondsSinceEpoch
        : savedData[0].unixDate;

    final List<String> columnsList = getMonthlyColumnLabel(firstUnixDate);

    List<TesbihAnalyticsColumnModel> monthlyColumnsList = [
      for (var i = 0; i < 7; i++)
        TesbihAnalyticsColumnModel(
          count: 0,
          label: columnsList[i],
          progress: 0,
        )
    ];

    if (savedData.length == 0) return monthlyColumnsList; // When no Data

    for (var i = 0; i < savedData.length; i++) {
      final int count = savedData[i].count;

      final double progressFactor = count / monthlyTesbihGoal;
      final bool fullProgress = progressFactor > 1;

      final TesbihAnalyticsColumnModel columnData = TesbihAnalyticsColumnModel(
        count: count,
        label: columnsList[i],
        progress: fullProgress ? 1 : progressFactor,
      );
      monthlyColumnsList[i] = columnData;
    }

    return monthlyColumnsList;
  }

  // Remove weekly data if more than 7 months old
  Future<void> sanitizeOldMonthlyAnaliticsList() async {
    final List<TesbihDataModel> oldList =
        SharedPrefs().getTesbihAnalyticsMonthlyList;

    final DateTime today = DateTime.now();

    final List<TesbihDataModel> newList = oldList
        .where((el) =>
            today
                .difference(DateTime.fromMillisecondsSinceEpoch(el.unixDate))
                .inDays <
            210)
        .toList();

    SharedPrefs().setTesbihAnalyticsMonthlyList(newList);
  }

  // Yearly
  List<String> getYearlyColumnLabel(int firstIndexDate) {
    List<String> yearlyColumnsList = List.filled(7, '');
    final DateFormat formatter = DateFormat('y');

    final DateTime today = DateTime.fromMillisecondsSinceEpoch(firstIndexDate);

    for (var i = 0; i < 7; i++) {
      final DateTime date =
          today.add(Duration(days: i * 365)); // Assuming 365 days in one year

      final String dateLabel = "${formatter.format(date)}"; // 2022
      yearlyColumnsList[i] = dateLabel;
    }

    return yearlyColumnsList;
  }

  List<TesbihAnalyticsColumnModel> getYearlyAnalyticsData(
    List<TesbihDataModel> savedData,
    int tesbihGoal,
  ) {
    final int yearlyTesbihGoal =
        tesbihGoal * TesbihAnalyticsState.yearly.multiples;

    bool noSavedData = savedData.length == 0;

    int firstUnixDate = noSavedData
        ? DateTime.now().millisecondsSinceEpoch
        : savedData[0].unixDate;

    final List<String> columnsList = getYearlyColumnLabel(firstUnixDate);

    List<TesbihAnalyticsColumnModel> yearlyColumnsList = [
      for (var i = 0; i < 7; i++)
        TesbihAnalyticsColumnModel(
          count: 0,
          label: columnsList[i],
          progress: 0,
        )
    ];

    if (savedData.length == 0) return yearlyColumnsList; // When no Data

    for (var i = 0; i < savedData.length; i++) {
      final int count = savedData[i].count;

      final double progressFactor = count / yearlyTesbihGoal;
      final bool fullProgress = progressFactor > 1;

      final TesbihAnalyticsColumnModel columnData = TesbihAnalyticsColumnModel(
        count: count,
        label: columnsList[i],
        progress: fullProgress ? 1 : progressFactor,
      );
      yearlyColumnsList[i] = columnData;
    }

    return yearlyColumnsList;
  }

  // Remove weekly data if more than 7 years old
  Future<void> sanitizeOldYearlyAnaliticsList() async {
    final int daysInSevenYears = 365 * 7;
    final List<TesbihDataModel> oldList =
        SharedPrefs().getTesbihAnalyticsYearlyList;

    final DateTime today = DateTime.now();

    final List<TesbihDataModel> newList = oldList
        .where((el) =>
            today
                .difference(DateTime.fromMillisecondsSinceEpoch(el.unixDate))
                .inDays <
            daysInSevenYears)
        .toList();

    SharedPrefs().setTesbihAnalyticsYearlyList(newList);
  }
}
