import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/provider/quranFontProvider.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/common/quran/surah/surahSettings/fontSize/fontSizeSwitch.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class FontSizeChange extends StatelessWidget {
  const FontSizeChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerTopPadding = constraints.maxHeight * 0.30;
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer<QuranProvider>(
              builder: (ctx, quran, _) => Container(
                margin: EdgeInsets.only(top: _containerTopPadding),
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
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 40, left: 30),
                                        child: Icon(
                                          AppIcons.fontSize,
                                          size: 20,
                                          color: CustomColors.blackPearl
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      Text(
                                        'Font Size',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: CustomColors.blackPearl
                                              .withValues(alpha: 0.7),
                                          fontSize: 20,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
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
                        ],
                      ),
                    ),
                    Consumer<QuranFontProvider>(
                      builder: (ctx, font, _) => Column(
                        children: [
                          FontSizeSwitch(
                            label: 'Arabic Font',
                            selectedSize: font.surahFontSize,
                            onChange: (size) =>
                                font.onSurahFontSizeChange(size),
                          ),
                          FontSizeSwitch(
                            label: 'Translation Font',
                            selectedSize: font.translationFontSize,
                            onChange: (size) =>
                                font.onTranslationFontSizeChange(size),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
