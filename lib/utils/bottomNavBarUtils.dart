import 'package:flutter/material.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class BottomNavBarUtils {
  Future<void> scrollToNewFeature(
    ScrollController bottomNavScrollController,
  ) async {
    bool isNewFeatureViewed = SharedPrefs().getNewFeatureViewed;
    final bool isScrollContainerAttached = bottomNavScrollController.hasClients;
    if (!isNewFeatureViewed && isScrollContainerAttached)
      bottomNavScrollController.animateTo(
        bottomNavScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
  }
}
