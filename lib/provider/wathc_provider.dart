import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:android_intent_plus/android_intent.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:masjidhub/constants/errors.dart';
import 'package:masjidhub/main.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/dashboard/sidebar/sidebarBody.dart';
import 'package:masjidhub/utils/otaUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../common/errorPopups/errorPopup.dart';
import '../common/popup/popup.dart';

const MethodChannel _channel =
    MethodChannel('co.takva.masjidhub/notifications');

class WatchProvider with ChangeNotifier {
  static final WatchProvider _instance = WatchProvider._internal();

  factory WatchProvider() => _instance;

  WatchProvider._internal() {
    openNotificationAccessSettings();
    initNotificationListener();
    initializeBluetooth();
  }

  static const String _targetDeviceName = "W570";
  static const List<String> _characteristicUuids = ["ff01", "ff02", "2a28"];

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;
  BluetoothCharacteristic? _versionCharacteristic;

  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<bool>? _scanStateSubscription;

  bool isUpdateNeeded = false;
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isConnected = false;
  String? _errorMessage;
  final StreamController<String> _eventStreamController =
      StreamController<String>.broadcast();

  Stream<String> get eventStream => _eventStreamController.stream;

  bool get isScanning => _isScanning;

  bool get isConnecting => _isConnecting;

  bool get isConnected => _isConnected;

  String? get errorMessage => _errorMessage;

  bool _isUpdateDialogShown = false;

  void initNotificationListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onNotification") {
        if (SharedPrefs().getSyncWhatsapp == true) {
          final title = call.arguments['title'];
          final body = call.arguments['body'];
          print("🔔 Notification intercepted: $title - $body");

          final hexedTitle = stringToHexUtf8(title);
          final titleDataLength = ((hexedTitle.length / 4) * 2)
              .toInt()
              .toRadixString(16)
              .toUpperCase();

          final hexedBody = stringToHexUtf8(body);
          final bodyDataLength = ((hexedBody.length / 4) * 2)
              .toInt()
              .toRadixString(16)
              .toUpperCase();

          sendCommand(
              "1A01F4$titleDataLength$hexedTitle$bodyDataLength${hexedBody}02");
        } else {
          print("🔕 SyncWhatsapp is OFF, ignoring notification.");
        }
      }
    });
  }

  String stringToHexUtf8(String input) {
    List<int> bytes = utf8.encode(input);
    return bytes.map((byte) => byte.toRadixString(16).padLeft(4, '0')).join();
  }

  Future<void> connectDevice(BuildContext? context) async {
    if (_isConnected) {
      // _updateError("Already connected to $_targetDeviceName");
      return;
    }

    await startConnectionProcess(context);
  }

  Future<void> disconnectDevice() async {
    try {
      _isConnecting = true;
      notifyListeners();
      await connectedDevice?.disconnect();
      _resetConnectionState();
      notifyListeners();
    } catch (e) {
      _updateError("Disconnection failed: ${e.toString()}");
    }
  }

  void sendCommand(String hexCommand) {
    if (_writeCharacteristic == null || !_isConnected) {
      _updateError("Device not connected");
      return;
    }

    try {
      final command = _validateAndConvertHex(hexCommand);
      log("sending command: $hexCommand");
      _writeCharacteristic?.write(command);
      _logCommand(hexCommand, true);
    } catch (e) {
      _updateError("Command failed: ${e.toString()}");
    }
  }

  void updateDateTime() {
    sendCommand(_getHexCommandForCurrentDateTime());
  }

  void updateLocation(String location) {
    List<int> locationBytes = utf8.encode(location);
    String hexLocation = locationBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    String commandPrefix = "1A01B2";
    String command = "$commandPrefix$hexLocation";
    sendCommand(command);
  }

  void updatePrayerTimes(List<Map<String, dynamic>> prayerTimes) {
    for (var day in prayerTimes) {
      DateTime date = day['date'];
      List<DateTime> prayers = day['prayers'];
      String dayHex = date.day.toRadixString(16).padLeft(2, '0');
      String monthHex = date.month.toRadixString(16).padLeft(2, '0');
      String yearHex = (date.year % 100).toRadixString(16).padLeft(2, '0');
      String prayersHex = prayers.map((prayer) {
        String hourHex = prayer.hour.toRadixString(16).padLeft(2, '0');
        String minuteHex = prayer.minute.toRadixString(16).padLeft(2, '0');
        return '$hourHex$minuteHex';
      }).join();
      String hexCommand = '1A01A3$prayersHex$dayHex$monthHex$yearHex';
      sendCommand(hexCommand);
    }
  }

  void updateWeatherForNext7Days(List<Map<String, dynamic>> weatherData) {
    assert(weatherData.length == 7);

    for (var day in weatherData) {
      DateTime date = day['date'];
      int chanceOfRain = day['chanceOfRain'];
      int windSpeed = day['windSpeed'];
      int uvIndex = day['uvIndex'];
      int humidity = day['humidity'];

      String chanceOfRainHex = chanceOfRain.toRadixString(16).padLeft(2, '0');
      String windSpeedHex = windSpeed.toRadixString(16).padLeft(2, '0');
      String uvIndexHex = uvIndex.toRadixString(16).padLeft(2, '0');
      String humidityHex = humidity.toRadixString(16).padLeft(2, '0');

      String dayHex = date.day.toRadixString(16).padLeft(2, '0');
      String monthHex = date.month.toRadixString(16).padLeft(2, '0');
      String yearHex = (date.year % 100).toRadixString(16).padLeft(2, '0');

      String hexCommand =
          '1A01F1$chanceOfRainHex$windSpeedHex$uvIndexHex$humidityHex$dayHex$monthHex$yearHex';
      sendCommand(hexCommand);
    }
  }

  Future<void> checkFirmwareUpdate() async {
    const functionUrl = 'https://checkversion-oh4ulapdmq-uc.a.run.app';

    try {
      final response = await http.get(Uri.parse(functionUrl));
      final data = jsonDecode(response.body);

      await _discoverDeviceServices(connectedDevice!);
      final latestVersionStr = data['version'];
      String? softwareRevision = await _readSoftwareRevision();
      log("latest version: $latestVersionStr, current version: $softwareRevision");

      isUpdateNeeded =
          compareVersions(softwareRevision ?? "", latestVersionStr);

      if (isUpdateNeeded) {
        _showUpdateDialog(
            data['downloadUrl'], latestVersionStr, softwareRevision ?? "");
      } else {
        log("No update needed. Current version $softwareRevision is newer than or equal to $latestVersionStr");
      }
    } catch (e) {
      log('Version check failed: $e');
    }
  }

  bool compareVersions(String currentVersion, String latestVersion) {
    List<String> currentParts = currentVersion.split('.');
    List<String> latestParts = latestVersion.split('.');

    int partsToCompare = currentParts.length > latestParts.length
        ? currentParts.length
        : latestParts.length;

    for (int i = 0; i < partsToCompare; i++) {
      int currentVal = i < currentParts.length
          ? int.parse(currentParts[i].replaceFirst(RegExp('^0+'), '').isEmpty
              ? '0'
              : currentParts[i].replaceFirst(RegExp('^0+'), ''))
          : 0;
      int latestVal = i < latestParts.length
          ? int.parse(latestParts[i].replaceFirst(RegExp('^0+'), '').isEmpty
              ? '0'
              : latestParts[i].replaceFirst(RegExp('^0+'), ''))
          : 0;

      if (currentVal < latestVal) {
        return true;
      } else if (currentVal > latestVal) {
        return false;
      }
    }
    return false;
  }

  Future<String?> _readSoftwareRevision() async {
    if (_versionCharacteristic == null || !_isConnected) {
      log("Characteristic not found or device disconnected");
      return null;
    }
    try {
      List<int> value = await _versionCharacteristic!.read();
      if (value.last == 0) value.removeLast();
      log("watch version: ${String.fromCharCodes(value)} $value");
      return String.fromCharCodes(value);
    } catch (e) {
      log("Error reading 2A28: $e");
      return null;
    }
  }

  void _showUpdateDialog(
      String downloadLink, String latestVersion, String currentVersion) {
    final context = navigatorKey.currentContext;
    if (context == null || _isUpdateDialogShown) return;
    _isUpdateDialogShown = true;

    bool _downloading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (_, setState) {
            if (_downloading) {
              return CupertinoAlertDialog(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Downloading Image"),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
            return CupertinoAlertDialog(
              title: Text(
                  "There is a new update for the watch from version $currentVersion to version $latestVersion. Do you wish to continue with it?"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _downloading = true;
                    });
                    _startUpdate(downloadLink);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _startUpdate(String downloadLink) async {
    final downloadUrl = downloadLink;
    final response = await http.get(Uri.parse(downloadUrl));

    final directory = await getTemporaryDirectory();

    String filePath = '${directory.path}/update.bin';

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    log('download successful ${file.path}');
    log("file downloaded at: $filePath");

    final context = navigatorKey.currentContext;
    if (context == null) return;

    await OtaUtils.initializeDFU(true);
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(key: dialogKey);
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      OtaUtils.startDFU(filePath, connectedDevice!.id.id);

      OtaUtils.dfuStream.listen((event) {
        if (event.containsKey('progress')) {
          String progressValue = event['progress'].toString();

          dialogKey.currentState?.updateProgress(progressValue);

          if (event['progress'] == 100) {
            Navigator.of(context).pop();
            _showCompletionDialog('OTA Update Completed Successfully!');
          }
        }
      }, onError: (error) {
        Navigator.of(context).pop();
        _showCompletionDialog('OTA Update Failed: $error');
      });
    });
  }

  void _showCompletionDialog(String message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OTA Update Status'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getHexCommandForCurrentDateTime() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday == 7 ? 0x06 : now.weekday - 1;
    String dayOfWeekHex = dayOfWeek.toRadixString(16).padLeft(2, '0');

    int day = now.day;
    String dayHex = day.toRadixString(16).padLeft(2, '0');

    int month = now.month;
    String monthHex = month.toRadixString(16).padLeft(2, '0');

    int year = now.year % 100;
    String yearHex = year.toRadixString(16).padLeft(2, '0');

    int hour = now.hour;
    String hourHex = hour.toRadixString(16).padLeft(2, '0');
    int minute = now.minute;
    String minuteHex = minute.toRadixString(16).padLeft(2, '0');
    int seconds = now.second;
    String secondHex = seconds.toRadixString(16).padLeft(2, '0');

    String hexCommand =
        "1A01A1$hourHex$minuteHex$secondHex$dayOfWeekHex$dayHex$monthHex$yearHex";
    log(hexCommand);
    return hexCommand.toUpperCase();
  }

  void setLogger(bool value) {
    SharedPrefs().setLogger(value);
  }

  bool isLoggerActivated() {
    return SharedPrefs().getLogger;
  }

  Future<void> _logCommand(String command, bool isWrite) async {
    if (SharedPrefs().getLogger == true) {
      await _writeCsvLog(command, DateTime.now().toIso8601String(), isWrite);
    }
  }

  Future<void> _writeCsvLog(
      String command, String timeStamp, bool isWrite) async {
    try {
      final hasPermissions = await _requestStoragePermissions();
      if (!hasPermissions) {
        openAppSettings();
      }

      Directory directory;

      if (Platform.isAndroid) {
        if (await _isScopedStorageRequired()) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory() ??
                await getApplicationDocumentsDirectory();
          }
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String filePath = '${directory.path}/logger_$dateString.csv';
      File file = File(filePath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      List<int> firmwareVersion = await _versionCharacteristic!.read();

      List<List<dynamic>> rows = [];

      if (await file.exists()) {
        String existingData = await file.readAsString();
        rows = CsvToListConverter().convert(existingData);
      } else {
        rows.add([
          "Type",
          "Command",
          "Timestamp",
          "Firmware Version",
          "App Version",
        ]);
      }

      // Add new data row
      rows.add([
        isWrite ? "wr" : "rd",
        command,
        timeStamp,
        String.fromCharCodes(firmwareVersion),
        "${packageInfo.version} (${packageInfo.buildNumber})",
      ]);

      // Write the file
      String csvData = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csvData);

      // debugPrint("File successfully written to: $filePath");
    } catch (e) {
      debugPrint("Error writing CSV file: $e");
      // Consider showing an error message to the user
    }
  }

  Future<bool> _isScopedStorageRequired() async {
    if (!Platform.isAndroid) return false;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt >= 29;
  }

  Future<bool> _requestStoragePermissions() async {
    if (!Platform.isAndroid) return true;

    // Check if we're on Android 13+
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13+ uses photos/videos/audio permissions
      final status = await Permission.photos.status;
      if (!status.isGranted) {
        final result = await Permission.photos.request();
        return result.isGranted;
      }
      return true;
    } else if (sdkInt >= 30) {
      // Android 11+ may need MANAGE_EXTERNAL_STORAGE
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      final result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    } else {
      // Android 10 and below uses standard storage permissions
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }

  void syncWatch(bool value, bool turnAll) {
    SharedPrefs().setSyncAllApps(value, turnAll);
  }

  void syncCalls(bool value) {
    SharedPrefs().setSyncCalls(value);
  }

  void syncMessages(bool value) {
    SharedPrefs().setSyncMessages(value);
  }

  void syncWhatsApp(bool value) {
    SharedPrefs().setSyncWhatsapp(value);
  }

  void syncTime(bool value) {
    SharedPrefs().setSyncTime(value);
  }

  void syncCalender(bool value) {
    SharedPrefs().setSyncCalender(value);
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _scanStateSubscription?.cancel();
    _connectionSubscription?.cancel();
    _eventStreamController.close();
    super.dispose();
  }

  Future<void> initializeBluetooth() async {
    await _checkExistingConnections();
    await checkFirmwareUpdate();

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      _handleScanResults(results);
    });
    _scanStateSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      notifyListeners();
    });
  }

  Future<void> saveDevice(BluetoothDevice device) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/remoteId.txt');
    await file.writeAsString(device.remoteId.toString());
  }

  void _handleScanResults(List<ScanResult> results) async {
    for (ScanResult result in results) {
      if (result.device.name == _targetDeviceName) {
        log("Target device found: ${result.device.name}");
        log("Device ID: ${result.device.id.id}");

        connectedDevice = result.device;
        await _establishConnection(result.device);
        saveDevice(result.device);

        FlutterBluePlus.stopScan();
        _isScanning = false;

        _errorMessage = null;

        checkFirmwareUpdate();

        return;
      }
    }

    if (_isScanning) {
      _errorMessage = 'Searching for device...';
      notifyListeners();
    }
  }

  Future<void> _checkExistingConnections() async {
    final device = await loadDevice();
    if (device != null) {
      await device.connect(autoConnect: false);
      connectedDevice = device;
      _isConnected = true;
      Future.delayed(Duration(milliseconds: 1500), () async {
        await _discoverDeviceServices(device);
        _enableNotifications();
        _setupConnectionMonitoring(device);
        updateLocation(SharedPrefs().getAddress);
      });
    } else {
      final connectedDevices = await FlutterBluePlus.connectedDevices;
      if (connectedDevices.isNotEmpty) {
        final target = connectedDevices.firstWhere(
          (d) => d.name == _targetDeviceName,
        );
        await _establishConnection(target);
      }
    }
  }

  Future<BluetoothDevice?> loadDevice() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/remoteId.txt');

    if (await file.exists()) {
      final remoteId = await file.readAsString();
      return BluetoothDevice.fromId(remoteId);
    }
    return null;
  }

  Future<void> startConnectionProcess(BuildContext? context) async {
    if (_isConnected) {
      // _updateError("Already connected to $_targetDeviceName");
      return;
    }

    try {
      _errorMessage = null;
      _isScanning = true;
      notifyListeners();

      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        _handleScanResults(results);
      });

      Future.delayed(const Duration(seconds: 10), () {
        if (!_isConnected) {
          FlutterBluePlus.stopScan();
          _isScanning = false;
          _updateError("Device not found within the timeout period.");
          if (context != null) {
            Navigator.push(
              context,
              PopupLayout(child: ErrorPopup(errorType: AppError.bluetooth)),
            );
          }
        }
      });
    } catch (e) {
      _updateError("Start Scan Error: $e");
    }
  }

  Future<void> _establishConnection(BluetoothDevice device) async {
    try {
      _isConnecting = true;
      notifyListeners();

      await device.connect(
          autoConnect: false, timeout: const Duration(seconds: 15));

      await _discoverDeviceServices(device);

      _isConnected = true;
      _isConnecting = false;
      _setupConnectionMonitoring(device);
      _enableNotifications();
      updateDateTime();
      _getNext300DaysPrayerTimes();

      notifyListeners();
    } catch (e) {
      _isConnecting = false;
      _updateError("Connection failed: ${e.toString()}");
    }
  }

  _getNext300DaysPrayerTimes() async {
    PrayerTimingsProvider prayerTimingsProvider = PrayerTimingsProvider();
    try {
      List<Map<String, dynamic>> next30DaysPrayerTimes =
          await prayerTimingsProvider.getNext30DaysPrayerTimes();
      next30DaysPrayerTimes.forEach((element) {
        DateTime date = element['date'];
        List<DateTime> prayers =
            (element['prayers'] as List).map((p) => p as DateTime).toList();
        print('Date: $date, Prayers: $prayers');
      });

      updatePrayerTimes(next30DaysPrayerTimes);
    } catch (e) {
      print('Error fetching or sending prayer times: $e');
    }
  }

  Future<void> _discoverDeviceServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          log("Characteristic UUID: ${characteristic.uuid.toString()}");

          if (characteristic.uuid.toString() == _characteristicUuids[0]) {
            _writeCharacteristic = characteristic;
          } else if (characteristic.uuid.toString() ==
              _characteristicUuids[1]) {
            _notifyCharacteristic = characteristic;
          } else if (characteristic.uuid.toString() ==
              _characteristicUuids[2]) {
            _versionCharacteristic = characteristic;
          }
        }
      }

      if (_writeCharacteristic == null || _notifyCharacteristic == null) {
        throw Exception("Required characteristics not found");
      }
    } catch (e) {
      throw Exception("Failed to discover services: $e");
    }
  }

  void _setupConnectionMonitoring(BluetoothDevice device) {
    _connectionSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _logCommand("disconnected", true);
        _resetConnectionState();
        // attemptReconnect(device);
        _updateError("Device disconnected");
      }

      if (state == BluetoothConnectionState.connected) {
        _logCommand("connected", true);
      }
    });
  }

  void attemptReconnect(BluetoothDevice device) async {
    while (!_isConnected) {
      try {
        await _checkExistingConnections();
      } catch (e) {
        print("Reconnection failed, retrying...");
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void _enableNotifications() {
    if (_notifyCharacteristic == null || !_isConnected) {
      _updateError("Notify characteristic not found or device not connected");
      return;
    }

    _notifyCharacteristic?.setNotifyValue(true);

    _notifyCharacteristic?.value.listen((data) {
      String receivedHex = _bytesToHex(data);
      log("Notification received: $receivedHex");
      _logCommand(receivedHex, false);

      if (receivedHex.contains('1A02D1') || receivedHex.contains('1A02D2')) {
        _handleTasbeehEvent(receivedHex);
      } else {
        _eventStreamController.add("sport");
      }
    });
  }

  void _processIncomingData(String hexData) {
    if (hexData.contains('1A02D1') || hexData.contains('1A02D2')) {
      _handleTasbeehEvent(hexData);
    } else {
      _eventStreamController.add("sport");
    }
  }

  void _handleTasbeehEvent(String hexData) {
    final countHex = hexData.contains('1A02D1')
        ? hexData.substring(6, 10)
        : hexData.substring(hexData.length - 4);

    final count = int.parse(countHex, radix: 16);
    final eventType = hexData.contains('1A02D1') ? "D1" : "D2";

    _eventStreamController.add("$count$eventType");
  }

  Uint8List _validateAndConvertHex(String input) {
    if (input.isEmpty) throw FormatException("Empty hex string");

    final normalized = input.length % 2 == 0 ? input : '0$input';
    final bytes = <int>[];

    for (int i = 0; i < normalized.length; i += 2) {
      final byte = int.parse(normalized.substring(i, i + 2), radix: 16);
      bytes.add(byte);
    }

    return Uint8List.fromList(bytes);
  }

  String _bytesToHex(List<int> bytes) => bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join()
      .toUpperCase();

  void _resetConnectionState() {
    _isConnected = false;
    _isConnecting = false;
    connectedDevice = null;
    _writeCharacteristic = null;
    _notifyCharacteristic = null;
    _connectionSubscription?.cancel();
  }

  void _updateError(String message) {
    _errorMessage = message;
    log(message);
    notifyListeners();
  }
}
