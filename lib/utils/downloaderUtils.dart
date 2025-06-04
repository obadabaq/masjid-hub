import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:masjidhub/constants/quran.dart';

class DownloadNotificationClass {
  @pragma('vm:entry-point')
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName('downloader_send');
    sendPort?.send([id, status.value, progress]);
  }
}

class DownloaderUtils {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
      debug: true,
    );
   // FlutterDownloader.registerCallback(DownloadNotificationClass.callback);
  }

  String getAudioUrl(int surah) => quranAudioApiBaseUrl + "$surah" + ".mp3";

  Future<void> cancelDownloads() async {
    await FlutterDownloader.cancelAll();
  }

  void downloadSurah(int surah) async {
    final bool isAndroid = Platform.isAndroid;
    final url = getAudioUrl(surah);
    final status = await Permission.storage.request();
    final downloadDir = isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (status.isGranted) {
      await cancelDownloads();
      await FlutterDownloader.enqueue(
        fileName: "$surah.mp3",
        url: url,
        savedDir: downloadDir!.path,
        showNotification: false,

      );
    } else {
      Future.error('Download permission not granted');
    }
  }
}
