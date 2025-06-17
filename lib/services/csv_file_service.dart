import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CsvFileService {
  static Future<List<File>> getLoggerCsvFiles() async {
    Directory? directory;
    if (Platform.isAndroid) {
      if (await isScopedStorageRequired()) {
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

    try {
      return directory
          .listSync()
          .where((file) =>
              file is File &&
              path.basename(file.path).startsWith('logger_') &&
              file.path.endsWith('.csv'))
          .map((file) => file as File)
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> showCsvFilePicker(BuildContext context) async {
    final csvFiles = await getLoggerCsvFiles();

    if (csvFiles.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Log Files'),
          content: const Text('No log files found".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Log File to Share'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: csvFiles.length,
            itemBuilder: (context, index) {
              final file = csvFiles[index];
              return ListTile(
                title: Text(path.basename(file.path)),
                onTap: () {
                  Navigator.pop(context);
                  _shareCsvFile(file);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static Future<void> _shareCsvFile(File file) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Log File Export',
          text:
              'Here is the log file you requested: ${path.basename(file.path)}',
        ),
      );
    } catch (e) {
      debugPrint('Error sharing file: $e');
    }
  }

  static Future<bool> isScopedStorageRequired() async {
    if (!Platform.isAndroid) return false;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt >= 29;
  }
}
