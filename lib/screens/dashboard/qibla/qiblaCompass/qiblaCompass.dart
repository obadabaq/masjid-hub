import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjidhub/helper_qibla.dart';
import 'package:provider/provider.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/utils/locationUtils.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/screens/dashboard/qibla/qiblaCompass/compassPainter.dart';
import 'package:masjidhub/screens/dashboard/qibla/qiblaCompass/QiblaDirectionHelperText.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';
import 'package:vibration/vibration.dart';

import '../../../../provider/wathc_provider.dart';
import '../../../../utils/sharedPrefs.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({
    Key? key,
  }) : super(key: key);

  @override
  _QiblaCompassState createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with WidgetsBindingObserver {
  double _heading = 0;
  bool _isInForeground = true;

  // The package is buggy and is emiting heading -180 to 180, this is a hacky way to fix it
  double sanitizeHeading(double? hd) {
    if (hd == null) return 0;
    if (hd < 0) return 360 + hd;
    if (hd > 0) return hd;
    return hd;
  }

  @override
  void initState() {
    super.initState();
    FlutterCompass.flutterCompass()!
        .listen((e) => _onData(sanitizeHeading(e.heading)));
    _getLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isInForeground = state == AppLifecycleState.resumed;
    });
  }

  void _onData(double heading) {
    if (mounted && _isInForeground)
      setState(() {
        double bearing =
            Provider.of<LocationProvider>(context, listen: false).getBearing;
        double adjustedHeading =
            LocationUtils().adjustHeading(heading, bearing);
        bool _timeToVibrate = (adjustedHeading > -5 && adjustedHeading < 5) ||
            (adjustedHeading > 355 && adjustedHeading < 358);
        if (_timeToVibrate) Vibration.vibrate();
        _heading = heading;
      });
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (Provider.of<WatchProvider>(context, listen: false).isConnected) {
      QiblaHelper.sendQiblaCommand(
          position.latitude, position.longitude, WatchProvider());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 110),
      child: SingleChildScrollView(
        child: Column(
          children: [
            QiblaDirectionHelperText(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Consumer<LocationProvider>(
                builder: (ctx, provider, _) {
                  // log(provider.getBearing.toString());
                  double bearing = provider.getBearing;
                  double adjustedHeading =
                      LocationUtils().adjustHeading(_heading, bearing);
                  bool _headingLessThan180 = adjustedHeading < 180;
                  double _readout = _headingLessThan180
                      ? adjustedHeading
                      : 360 - adjustedHeading;
                  bool _almostAccurate = _readout < 5 && _readout > -5;
                  String _readouText = tr(
                      _headingLessThan180 ? 'to your left' : 'to your right');
                  // BACKLOG REFACTOR size should be controlled by one number
                  return SizedBox(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      foregroundPainter: CompassPainter(
                        angle: adjustedHeading,
                        squareLength: 300,
                        almostAccurate: _almostAccurate,
                      ),
                      child: Container(
                        decoration: ConcaveDecoration(
                          depth: 9,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(150)),
                          colors: innerConcaveShadow,
                          size: Size(300, 300),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: ConcaveDecoration(
                                depth: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                colors: innerConcaveShadow,
                                size: Size(20, 20),
                              ),
                            ),
                            Container(
                              width: 220,
                              height: 220,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: CustomTheme
                                    .lightTheme.colorScheme.background,
                                borderRadius: BorderRadius.circular(110),
                                boxShadow: shadowNeu,
                              ),
                              child: DottedBorder(
                                color: CustomColors.spindle,
                                dashPattern: [2, 20],
                                strokeWidth: 3,
                                borderType: BorderType.Circle,
                                child: Container(
                                  width: 200,
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Icon(
                                          AppIcons.kaabaIcon,
                                          size: 32,
                                          color: _almostAccurate
                                              ? CustomColors.irisBlue
                                              : CustomColors.blackPearl,
                                        ),
                                      ),
                                      Text(
                                        _readout.toStringAsFixed(0) + '°',
                                        style: TextStyle(
                                          color: CustomColors.blackPearl,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                      Text(
                                        _almostAccurate
                                            ? 'THATS It!'
                                            : _readouText,
                                        style: TextStyle(
                                          color: CustomColors.mischka,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
