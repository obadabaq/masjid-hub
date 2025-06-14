import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier {
  bool isNavBarVisible = true;

  void hideTheBottomNavBar() {
    isNavBarVisible = false;
    notifyListeners();
  }

  void displayTheBottomNavBar() {
    isNavBarVisible = true;
    notifyListeners();
  }
}
