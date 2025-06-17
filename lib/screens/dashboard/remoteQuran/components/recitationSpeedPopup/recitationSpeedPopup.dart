import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/components/recitationSpeedPopup/recitationControlSlider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class RecitationSpeedPopup extends StatelessWidget {
  const RecitationSpeedPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerWidth = constraints.maxWidth * 0.90;
        final _containerTopPadding = constraints.maxHeight * 0.20;
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(top: _containerTopPadding),
              padding: EdgeInsets.only(bottom: 30),
              width: _containerWidth,
              decoration: BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: shadowNeu,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    tr('recitation speed'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: CustomColors.blackPearl
                                          .withValues(alpha: 0.7),
                                      fontSize: 20,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                CupertinoIcons.multiply,
                                size: 30,
                                color: CustomColors.blackPearl
                                    .withValues(alpha: 0.4),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: RecitationControlSlider(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
