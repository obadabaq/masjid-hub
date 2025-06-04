import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahPageMediaPlayer/surahPageMediaPlayerButtons.dart';
import 'package:masjidhub/theme/customTheme.dart';

class SurahPageMediaPlayer extends StatelessWidget {
  const SurahPageMediaPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double _width =
            constraints.maxWidth > 500 ? 300 : constraints.maxWidth * 0.90;

        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                boxShadow: shadowNeuSecondary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 85,
              width: _width,
              child: SurahPageMediaPlayerButtons(),
            ),
          ),
        );
      },
    );
  }
}
