import 'dart:async';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/utils/layoutUtils.dart';
import 'package:masjidhub/utils/enums/deviceScale.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerDial/prayerDialNeedle.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerDial/prayerDialProgress.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/models/prayerDialModel.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';

class PrayerDial extends StatefulWidget {
  const PrayerDial({
    Key? key,
    this.scale = DeviceScale.normal,
  }) : super(key: key);

  final DeviceScale scale;

  @override
  _PrayerDialState createState() => _PrayerDialState();
}

class _PrayerDialState extends State<PrayerDial> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int angleFromDuration(Duration dur) {
    Angle angle = Angle.degrees(dur.inMinutes * 6);
    int angleInturns = angle.turns.floor();
    int refrenceAngle = angle.degrees.round() - (360 * angleInturns);
    return refrenceAngle;
  }

  final double normalPrayerDialHeight = 250;

  @override
  Widget build(BuildContext context) {
    final double lengthOfSideOfSquareDialWrapper =
        LayoutUtils().getPrayerDialHeight(widget.scale, normalPrayerDialHeight);
    final double prayerDialTitleFontSize =
        LayoutUtils().getPrayerDialFontSize(widget.scale, 22);
    final double prayerDialSubTitleFontSize =
        LayoutUtils().getPrayerDialFontSize(widget.scale, 14);

    return Consumer<PrayerTimingsProvider>(
      builder: (ctx, nextPrayer, _) => SizedBox(
        width: lengthOfSideOfSquareDialWrapper,
        height: lengthOfSideOfSquareDialWrapper,
        child: FutureBuilder(
          future: nextPrayer.getPrayerDialDataList(),
          initialData: PrayerDialModel(
              prayerTitle: '',
              timeToPrayer: Duration.zero,
              progressAngle: 0,
              alertTimeInMins: nextPrayer.defaultAlertTimeInMins),
          builder:
              (BuildContext context, AsyncSnapshot<PrayerDialModel> snapshot) {
            final progressAngle = snapshot.data?.progressAngle ?? 0;
            return CustomPaint(
              painter: PrayerdialProgress(
                squareLength: lengthOfSideOfSquareDialWrapper,
                angle: progressAngle,
                alertTimeInMins: snapshot.data?.alertTimeInMins,
                timeLeft: snapshot.data?.timeToPrayer ?? Duration.zero,
              ),
              foregroundPainter: PrayerdialNeedle(
                squareLength: lengthOfSideOfSquareDialWrapper,
                angle: progressAngle,
                alertTimeInMins: snapshot.data?.alertTimeInMins,
                timeLeft: snapshot.data?.timeToPrayer ?? Duration.zero,
              ),
              child: Container(
                decoration: ConcaveDecoration(
                  depth: 9,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150)),
                  colors: innerConcaveShadow,
                  size: Size(lengthOfSideOfSquareDialWrapper,
                      lengthOfSideOfSquareDialWrapper),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: lengthOfSideOfSquareDialWrapper * 0.733,
                      height: lengthOfSideOfSquareDialWrapper * 0.733,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CustomTheme.lightTheme.colorScheme.background,
                        borderRadius: BorderRadius.circular(110),
                        boxShadow: shadowNeuPressed,
                      ),
                      child: DottedBorder(
                        color: CustomColors.spindle,
                        dashPattern: [2, 17],
                        strokeWidth: 6,
                        borderType: BorderType.Circle,
                        child: Center(
                          child: Container(
                            width: lengthOfSideOfSquareDialWrapper * 0.533,
                            height: lengthOfSideOfSquareDialWrapper * 0.533,
                            decoration: ConcaveDecoration(
                              depth: 9,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(150)),
                              colors: innerConcaveShadow,
                              size: Size(
                                  lengthOfSideOfSquareDialWrapper * 0.533,
                                  lengthOfSideOfSquareDialWrapper * 0.533),
                            ),
                            padding: EdgeInsets.only(bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  PrayerUtils().prayerDurationFormat(
                                      snapshot.data?.timeToPrayer ??
                                          Duration(minutes: 1)),
                                  style: TextStyle(
                                    color: CustomColors.blackPearl,
                                    fontSize: prayerDialTitleFontSize,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Text(
                                  'to'.toLowerCase().tr(args: [tr('${snapshot.data?.prayerTitle}')]).toUpperCase(),
                                  style: TextStyle(
                                    color: CustomColors.mischka,
                                    fontSize: prayerDialSubTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
