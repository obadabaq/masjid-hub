import 'package:flutter/material.dart';

import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/quranRecitations.dart';
import 'package:masjidhub/models/radioListModel.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:provider/provider.dart';

class SubSettingsQuranReciter extends StatefulWidget {
  const SubSettingsQuranReciter({
    Key? key,
  }) : super(key: key);

  @override
  _QuranReciterState createState() => _QuranReciterState();
}

class _QuranReciterState extends State<SubSettingsQuranReciter> {
  @override
  Widget build(BuildContext context) {
    List<RadioListModel> list = [
      for (var i = 0; i < quranRecitations.length; i++)
        RadioListModel(title: quranRecitations[i].name, id: i)
    ];

    return Container(
      padding: EdgeInsets.only(left: 36, right: 36, bottom: 100),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Consumer<QuranProvider>(
                  builder: (ctx, quran, _) => RadioList(
                    list: list,
                    onItemPressed: (id) => quran.onQuranReciterChanged(id),
                    itemSelected: quran.quranReciter,
                    width: constraints.maxWidth,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
