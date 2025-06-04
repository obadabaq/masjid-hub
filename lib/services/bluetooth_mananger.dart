import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothManager with ChangeNotifier {
  BluetoothDevice? _connectedDevice;
  List<ScanResult> _devices = [];
  Stream<List<ScanResult>> get devices => FlutterBluePlus.scanResults;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  bool get isScanning => FlutterBluePlus.isScanningNow;

  Future<void> connectToNearbyDevice(String deviceId) async {
    FlutterBluePlus.scanResults.listen((results) {
      _devices = results;
      notifyListeners();
    });

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    Future.delayed(Duration(seconds: 12),() async {
      log("message");
      await FlutterBluePlus.stopScan();
      // Find the device with the specified ID
      _devices.forEach((element) {
        log(element.device.toString());
      });
      try {
        ScanResult? result = _devices.firstWhere(
              (result) => result.device.remoteId.toString() == deviceId,
        );
        await result.device.connect(autoConnect: false);
        _connectedDevice = result.device;
        notifyListeners();

      }catch (e){
        log(e.toString());
      }

    });
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    notifyListeners();
  }

  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      notifyListeners();
    }
  }

  Future<void> sendCommand(String command) async {
    _connectedDevice?.discoverServices().then((value) {
      value.forEach((element1) {
        element1.characteristics.forEach((element) {
          if (element.uuid.toString() == "FF01".toLowerCase()){
            log(element.uuid.toString());
            log(element.remoteId.toString());
            log(element1.serviceUuid.toString());
            element.write(utf8.encode('1A01A1173B061F0C17'),withoutResponse: true,allowLongWrite: true);
          }
        });
      });
    });
  }

}
