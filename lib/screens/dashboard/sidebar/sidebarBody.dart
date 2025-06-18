import 'package:masjidhub/services/csv_file_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/constants/settingsList/adhanSettingsListData.dart';
import 'package:masjidhub/constants/settingsList/languageSettingsListData.dart';
import 'package:masjidhub/constants/settingsList/locationSettingsListData.dart';
import 'package:masjidhub/constants/settingsList/quranSettingsListData.dart';
import 'package:masjidhub/constants/settingsList/shareLogger.dart';
import 'package:masjidhub/constants/settingsList/tesbihSettingsList.dart';
import 'package:masjidhub/constants/settingsList/updateSettingsListData.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:masjidhub/screens/dashboard/sidebar/settingsListBuilder.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/otaUtils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

final GlobalKey<_ProgressDialogState> dialogKey =
    GlobalKey<_ProgressDialogState>();

class Sidebarbody extends StatefulWidget {
  const Sidebarbody({
    Key? key,
  }) : super(key: key);

  @override
  State<Sidebarbody> createState() => _SidebarbodyState();
}

class _SidebarbodyState extends State<Sidebarbody> {
  FilePickerResult? result;
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    Future.microtask(() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = Provider.of<WatchProvider>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SettingsListBuidler(list: locationSettingsList),
            SettingsListBuidler(list: adhanSettingsList),
            SettingsListBuidler(list: quranSettingsList),
            SettingsListBuidler(list: languageSettingsList),
            SettingsListBuidler(list: tesbihSettings),
            watchProvider.isUpdateNeeded
                ? SettingsListBuidler(
                    list: updateSettingsListData,
                    onClick: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: result != null ? false : true,
                        builder: (BuildContext context) {
                          return ProgressDialog(key: dialogKey);
                        },
                      );

                      await OtaUtils.initializeDFU(true);
                      await Permission.bluetoothScan.request();
                      await Permission.bluetoothConnect.request();
                      await Permission.location.request();

                      result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['bin', 'zip'],
                      );
                      if (result == null) Navigator.pop(context);
                      String filePath = result!.files.single.path!;

                      OtaUtils.startDFU(
                          filePath, watchProvider.connectedDevice!.id.id);

                      OtaUtils.dfuStream.listen((event) {
                        if (event.containsKey('progress')) {
                          String progressValue = event['progress'].toString();

                          dialogKey.currentState?.updateProgress(progressValue);

                          if (event['progress'] == 100) {
                            Navigator.of(context).pop();
                            _showCompletionDialog(
                                'OTA Update Completed Successfully!');
                          }
                        }
                      }, onError: (error) {
                        Navigator.of(context).pop();
                        _showCompletionDialog('OTA Update Failed: $error');
                      });
                    },
                  )
                : Container(),
            watchProvider.isLoggerActivated()
                ? SettingsListBuidler(
                    list: shareLogger,
                    onClick: () async {
                      CsvFileService.showCsvFilePicker(context);
                    },
                  )
                : Container(),
            // SettingsListBuidler(list: remoteSettings),
            Text("version: $version ($buildNumber)"),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(String message) {
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
}

class ProgressDialog extends StatefulWidget {
  ProgressDialog({Key? key}) : super(key: key);

  @override
  _ProgressDialogState createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  String _progress = '0.0';

  void updateProgress(String progress) {
    setState(() {
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Firmware Update in Progress'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: double.parse(_progress).floor() / 100.0,
            color: CustomColors.irisBlue,
            backgroundColor: CustomColors.blackPearl,
          ),
          SizedBox(height: 20),
          Text('${double.parse(_progress).floor()}%'),
        ],
      ),
    );
  }
}
