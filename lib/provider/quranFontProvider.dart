import 'package:flutter/material.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class QuranFontProvider extends ChangeNotifier {
  FontSize surahFontSize = SharedPrefs().getSurahFontSize;
  Future<void> onSurahFontSizeChange(FontSize size) async {
    surahFontSize = size;
    SharedPrefs().setSurahFontSize(size);
    notifyListeners();
  }

  FontSize translationFontSize = SharedPrefs().getTranslationFontSize;
  Future<void> onTranslationFontSizeChange(FontSize size) async {
    translationFontSize = size;
    SharedPrefs().setTranslationFontSize(size);
    notifyListeners();
  }
}
