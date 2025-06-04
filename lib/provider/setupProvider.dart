import 'package:flutter/material.dart';
import 'package:masjidhub/constants/coordinates.dart';
import 'package:masjidhub/models/coordinateModel.dart';

import 'package:masjidhub/utils/sharedPrefs.dart';

class SetupProvider extends ChangeNotifier {
  bool _isSetupCompleted = SharedPrefs().isSetupCompleted;
  Cords? userCords;

  // Shared Preferenses
  bool get isSetupCompleted => _isSetupCompleted;

  void setIsSetupCompleted(bool isSetupCompleted) {
    _isSetupCompleted = isSetupCompleted;
    SharedPrefs().setIsSetupCompleted(isSetupCompleted);
    notifyListeners();
  }

  // Location
  bool get isLocationSetupComplete => userCords != null;

  Cords get getUserCords => userCords ?? kaabaCords;

  set setCords(Cords cords) => this.userCords = cords;

  void setUserCords(Cords cords) {
    setCords = cords;
    notifyListeners();
  }

  // Qibla
  bool _qiblaHelperTextViewed = SharedPrefs().getQiblaHelperTextViewed;

  bool get getQiblaHelperTextViewed => _qiblaHelperTextViewed;

  Future<void> setQiblaHelperTextViewed(bool bool) async {
    _qiblaHelperTextViewed = bool;
    SharedPrefs().setQiblaHelperTextViewed(bool);
    notifyListeners();
  }
}
