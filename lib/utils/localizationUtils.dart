import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:masjidhub/constants/languages.dart';

class LocalizationUtils {
  Widget initApp(Widget widget) => EasyLocalization(
        supportedLocales: languageList,
        path: 'assets/translations/trans.csv',
        fallbackLocale: Locale('en', 'US'),
        assetLoader: CsvAssetLoader(),
        child: widget,
      );

  List<Locale> languageList = [
    for (var i = 0; i < languages.length; i++) languages[i].locale
  ];

  int idFromLocale(Locale? locale) =>
      languages.firstWhere((lan) => lan.locale == locale).id;

  int getLocaleId(BuildContext context) {
    final Locale? locale = EasyLocalization.of(context)!.currentLocale;
    return idFromLocale(locale);
  }

  String getCurrentLocale(BuildContext context) {
    final int localeId = getLocaleId(context);
    return tr(languages[localeId].title);
  }

  void setLocale(BuildContext context, int id) =>
      context.setLocale(languages[id].locale);

  Future<void> init({bool debug = false}) async {
    await EasyLocalization.ensureInitialized();
    // if (!debug) EasyLocalization.logger.enableBuildModes = [];
  }
}

class CsvAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final csvString = await rootBundle.loadString(path);  // Load the CSV file
    final csvData = const CsvToListConverter().convert(csvString);

    // Convert the CSV data to a Map
    final Map<String, String> translations = {};
    for (var row in csvData) {
      translations[row[0]] = row[locale.languageCode == 'en' ? 1 : locale.languageCode == 'fr' ? 2 : locale.languageCode == 'de' ? 3 : 4];
    }

    return translations;
  }
}