import 'package:flutter/material.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:masjidhub/utils/enums/tesbihAnalyticsEnums.dart';
import 'package:masjidhub/models/tesbih/tesbihAnalyticsColumnModel.dart';
import 'package:masjidhub/models/tesbih/tesbihDataModel.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/utils/tesbihUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TesbihProvider extends ChangeNotifier {
  final WatchProvider watchProvider;
  int _initialTesbihCount = 0;
  int _totalinitialTesbihCount = 0;
  int oldFromWatch = 0;
  int newFromWatch = 0;
  final _maxTesbihCount = 100000;

  TesbihProvider({required this.watchProvider}) {
    // Listen to the Bluetooth connection status and tasbeeh count updates
    _listenToWatchProvider();
  }

  int get getTesbihCount => _initialTesbihCount;

  int get getTotalTesbihCount => _totalinitialTesbihCount;

  void incrementTesbih() {
    if (watchProvider.isConnected) {
      watchProvider.sendCommand(
          "1A02D3${(getTesbihCount + 1).toRadixString(16).padLeft(4, '0').toUpperCase()}");
    }
    if (_initialTesbihCount != _maxTesbihCount) {
      _initialTesbihCount += 1;
    } else {
      _initialTesbihCount = 1;
    }
    SharedPrefs().incrementTesbihCountToday();
    notifyListeners();
  }

  void resetTesbih() {
    _initialTesbihCount = 0;
    notifyListeners();
  }

  // Listen to the WatchProvider for tasbeeh count updates and Bluetooth connection status

  void _listenToWatchProvider() {
    // watchProvider.sendCommand("1A01D100");

    // Listen to tasbeeh count updates from WatchProvider
    watchProvider.eventStream.listen((newTasbeehCount) async {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final lastExecutionDateString = prefs.getString('lastExecutionDateD1');

      // Parse the stored date, if it exists
      final lastExecutionDate = lastExecutionDateString != null
          ? DateTime.parse(lastExecutionDateString)
          : null;

      if (newTasbeehCount.contains("D1")) {
        // Check if the last execution date is today
        if (lastExecutionDate != null &&
            lastExecutionDate.year == today.year &&
            lastExecutionDate.month == today.month &&
            lastExecutionDate.day == today.day) {
          // Skip execution as it has already run today
          return;
        }

        // If it's a new day, execute the code
        newTasbeehCount = newTasbeehCount.replaceAll("D1", "");
        int count = int.tryParse(newTasbeehCount) ?? 0;
        _initialTesbihCount +=
            count; // Update the tasbeeh count in TesbihProvider
        newFromWatch = count;
        notifyListeners(); // Notify listeners of the update
        // Save the current date as the last execution date
        await prefs.setString('lastExecutionDateD1', today.toIso8601String());
      } else if (newTasbeehCount.contains("D2")) {
        newTasbeehCount = newTasbeehCount.replaceAll("D2", "");
        int count = int.tryParse(newTasbeehCount) ?? 0;
        newFromWatch = count;

        SharedPrefs().incrementTesbihCountToday();
        if (newFromWatch != oldFromWatch) {
          if (count == 0) {
            resetTesbih();
          } else {
            if (_initialTesbihCount != _maxTesbihCount) {
              _initialTesbihCount += 1;
            } else {
              _initialTesbihCount = 1;
            }
            notifyListeners(); // Notify listeners of the update
          }
          oldFromWatch = newFromWatch;
        }
      }
    });

    // Listen for Bluetooth connection status
    watchProvider.addListener(() {
      if (!watchProvider.isConnected) {
        // Reset or handle disconnect case for Bluetooth
        _initialTesbihCount = 0; // Reset tasbeeh count if disconnected
        notifyListeners();
      }
    });
  }

  // Tesbih Analytics
  TesbihAnalyticsState _analyticsState = TesbihAnalyticsState.daily;

  TesbihAnalyticsState get analyticsState => _analyticsState;

  void setAnalyticsState(TesbihAnalyticsState newState) {
    _analyticsState = newState;
    notifyListeners();
  }

  void updateAnalytics() => notifyListeners();

  List<TesbihAnalyticsColumnModel> getAnalyticsData(
      TesbihAnalyticsState state) {
    switch (state) {
      case TesbihAnalyticsState.daily:
        return getDailyTesbihData();
      case TesbihAnalyticsState.weekly:
        return getWeeklyTesbihData();
      case TesbihAnalyticsState.monthly:
        return getMonthlyTesbihData();
      case TesbihAnalyticsState.yearly:
        return getYearlyTesbihData();
    }
  }

  List<TesbihAnalyticsColumnModel> getDailyTesbihData() {
    final List<TesbihDataModel> savedData =
        SharedPrefs().getTesbihAnalyticsDailyList;
    final int tesbihGoal = SharedPrefs().getTesbihGoal;
    return TesbihUtils().getDailyAnalyticsData(savedData, tesbihGoal);
  }

  List<TesbihAnalyticsColumnModel> getWeeklyTesbihData() {
    final List<TesbihDataModel> savedData =
        SharedPrefs().getTesbihAnalyticsWeeklyList;
    final int tesbihGoal = SharedPrefs().getTesbihGoal;

    return TesbihUtils().getWeeklyAnalyticsData(savedData, tesbihGoal);
  }

  List<TesbihAnalyticsColumnModel> getMonthlyTesbihData() {
    final List<TesbihDataModel> savedData =
        SharedPrefs().getTesbihAnalyticsMonthlyList;
    final int tesbihGoal = SharedPrefs().getTesbihGoal;

    return TesbihUtils().getMonthlyAnalyticsData(savedData, tesbihGoal);
  }

  List<TesbihAnalyticsColumnModel> getYearlyTesbihData() {
    final List<TesbihDataModel> savedData =
        SharedPrefs().getTesbihAnalyticsYearlyList;
    final int tesbihGoal = SharedPrefs().getTesbihGoal;

    return TesbihUtils().getYearlyAnalyticsData(savedData, tesbihGoal);
  }
}
