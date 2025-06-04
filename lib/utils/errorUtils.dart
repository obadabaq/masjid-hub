import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:masjidhub/utils/notificationUtils.dart';

class ErrorUtils {
  Future<bool> onNetworkConnectRetry() async {
    return false;
  }

  Future<bool> onBluetoothRetry() async {
    return true;
  }

  Future<bool> onNoSurahFound() async {
    return true;
  }

  Future<bool> onGPSConnectRetry() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return serviceEnabled;
  }

  Future<bool> onNotificationsRetry() async {
    try {
      await NotificationUtils().requestPermission();
      return true;
    } catch (e) {
      return false;
    }
  }
}
