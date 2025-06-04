import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/errorPopups/errorPopup.dart';
import 'package:masjidhub/screens/dashboard/qibla/qiblaMap/mapWidget.dart';

class QiblaMap extends StatefulWidget {
  const QiblaMap({
    Key? key,
  }) : super(key: key);

  @override
  _QiblaMapState createState() => _QiblaMapState();
}

class _QiblaMapState extends State<QiblaMap> {
  bool _isTextOverMapVisible = true;

  @override
  Widget build(BuildContext context) {
    Function onCameraMoved = () => {
          if (_isTextOverMapVisible)
            setState(() {
              _isTextOverMapVisible = false;
            })
        };

    return FutureBuilder(
      future: InternetConnectionChecker().connectionStatus,
      builder: (BuildContext context,
          AsyncSnapshot<InternetConnectionStatus> snapshot) {
        if (snapshot.data == InternetConnectionStatus.disconnected) {
          return ErrorPopup(showBackButton: false);
        } else {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: MapWidget(onCameraMoved: onCameraMoved),
                      ),
                      Visibility(
                        visible: _isTextOverMapVisible,
                        child: Container(
                          padding: const EdgeInsets.only(top: 110),
                          margin: EdgeInsets.only(bottom: 30),
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              tr('use map for location'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                height: 1.3,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
