import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:provider/provider.dart';

const bool debug = true;

class SurahListItemActionButtonDownloading extends StatefulWidget
    with WidgetsBindingObserver {
  const SurahListItemActionButtonDownloading({
    Key? key,
    required this.onAudioButonPressed,
    required this.downloadProgress,
    required this.surahNumber,
  }) : super(key: key);

  final Function onAudioButonPressed;
  final double downloadProgress;
  final int surahNumber;

  @override
  State<SurahListItemActionButtonDownloading> createState() =>
      _SurahListItemActionButtonDownloadingState();
}

class _SurahListItemActionButtonDownloadingState
    extends State<SurahListItemActionButtonDownloading> {
  double downloadProgress = 0;

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send');

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final progress = data[2] as int;

      if (progress == 100) {
        if (mounted)
          Provider.of<AudioProvider>(context, listen: false).completeDownload();
      }

      if (mounted)
        setState(() {
          if (progress! > 0) {
            downloadProgress = (progress / 100).toDouble();
          } else {
            downloadProgress = 0;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onAudioButonPressed(),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: CustomTheme.lightTheme.colorScheme.background,
              borderRadius: BorderRadius.circular(50),
              boxShadow: secondaryShadow,
              gradient: CustomColors.grey90,
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: CustomColors.greyIconGradient,
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Icon(
                CupertinoIcons.stop_fill,
                size: 23,
                color: Colors.white,
              ),
            ),
          ),
          CircularPercentIndicator(
            radius: 29.0,
            lineWidth: 3.0,
            percent: downloadProgress,
            progressColor: CustomColors.irisBlue,
            animation: true,
            animateFromLastPercent: true,
          ),
        ],
      ),
    );
  }
}
