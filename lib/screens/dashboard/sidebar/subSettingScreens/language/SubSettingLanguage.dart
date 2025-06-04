import 'package:flutter/material.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/languages.dart';
import 'package:masjidhub/models/radioListModel.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/utils/localizationUtils.dart';

class SubSettingLanguage extends StatefulWidget {
  const SubSettingLanguage({
    Key? key,
  }) : super(key: key);

  @override
  _SubSettingLanguageState createState() => _SubSettingLanguageState();
}

class _SubSettingLanguageState extends State<SubSettingLanguage> {
  @override
  Widget build(BuildContext context) {
    List<RadioListModel> list = [
      for (var i = 0; i < languages.length; i++)
        RadioListModel(id: languages[i].id, title: languages[i].title)
    ];

    void onItemPressed(int id) {
      LocalizationUtils().setLocale(context, id);

      final QuranProvider quranProvider =
          Provider.of<QuranProvider>(context, listen: false);

      final String langaugeCode = languages.elementAt(id).locale.countryCode!;
      quranProvider.setSurahTranslationLanguage(langaugeCode);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Consumer<SetupProvider>(
        builder: (ctx, setupProvider, _) =>
            LayoutBuilder(builder: (context, constraints) {
          return RadioList(
            list: list,
            onItemPressed: onItemPressed,
            itemSelected: LocalizationUtils().getLocaleId(context),
            width: constraints.maxWidth,
          );
        }),
      ),
    );
  }
}
