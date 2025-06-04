import 'package:flutter/services.dart';

const _channel = MethodChannel('dfu_channel');
const _eventChannel = EventChannel('dfu_progress');

class OtaUtils {
  static Future<void> initializeDFU(bool isDebug) async {
    await _channel.invokeMethod('initialize', {'isDebug': isDebug});
  }

  static Future<void> startDFU(String filePath, String deviceAddress) async {
    await _channel.invokeMethod('startDfu', {
      'filePath': filePath,
      'deviceAddress': deviceAddress,
    });
  }

  static Stream<dynamic> get dfuStream => _eventChannel.receiveBroadcastStream();
}
