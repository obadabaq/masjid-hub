import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/languages.dart';
import 'package:masjidhub/models/radioListModel.dart';

class SubSettingsSurahTranslation extends StatefulWidget {
  const SubSettingsSurahTranslation({
    Key? key,
  }) : super(key: key);

  @override
  _SubSettingsSurahTranslationState createState() =>
      _SubSettingsSurahTranslationState();
}

class _SubSettingsSurahTranslationState
    extends State<SubSettingsSurahTranslation> {
  @override
  Widget build(BuildContext context) {
    List<RadioListModel> list = [
      for (var i = 0; i < languages.length; i++)
        RadioListModel(id: languages[i].id, title: languages[i].title)
    ];

    void onItemPressed(int id) {
      final QuranProvider quranProvider =
          Provider.of<QuranProvider>(context, listen: false);

      final String langaugeCode = languages.elementAt(id).locale.countryCode!;
      quranProvider.setSurahTranslationLanguage(langaugeCode);
      quranProvider.getQuranDefaultTranslationFuture(context);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Consumer<QuranProvider>(
        builder: (ctx, quranProvider, _) =>
            LayoutBuilder(builder: (context, constraints) {
          return RadioList(
            list: list,
            onItemPressed: onItemPressed,
            itemSelected: languages.indexWhere((el) =>
                el.locale.countryCode ==
                quranProvider.surahTranslationLanguage),
            width: constraints.maxWidth,
          );
        }),
      ),
    );
  }
}
