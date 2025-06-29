import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/quranRecitations.dart';
import 'package:masjidhub/models/radioListModel.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:provider/provider.dart';

import '../../../../../common/buttons/primaryButton.dart';
import '../../../../../common/dropdown/dropdown.dart';

class SubSettingsQuranReciter extends StatefulWidget {
  const SubSettingsQuranReciter({
    Key? key,
  }) : super(key: key);

  @override
  _QuranReciterState createState() => _QuranReciterState();
}

class _QuranReciterState extends State<SubSettingsQuranReciter> {
  late String id;
  late String title;
  late List<RadioListModel> list;
  void onSelectedItem(id, title) async {
    setState(() {
      this.id = id;
      this.title = title;
    });
  }

  void onSaveSelection(id, title) async {
    final provider = Provider.of<QuranProvider>(context, listen: false);
    provider.onQuranReciterChanged(id, title);
    Navigator.of(context).pop();
  }

  void setData() {
    final provider = Provider.of<QuranProvider>(context, listen: false);
    list = [
      for (var i = 0; i < quranRecitations.length; i++)
        RadioListModel(title: quranRecitations[i].name, id: i)
    ];
    id = provider.quranReciter.toString();
    title = list.firstWhere((item) => item.id.toString() == id).title;
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 36, right: 36, bottom: 100),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .45,
                  ),
                  child: Consumer<QuranProvider>(builder: (context, quran, _) {
                    return Dropdown.button(
                      width: MediaQuery.of(context).size.width * .9,
                      list: list,
                      onItemPressed: onSelectedItem,
                      selectedValue: RadioListModel(
                        id: int.parse(id),
                        title: title,
                      ),
                    );
                  }),
                ),
                PrimaryButton(
                  margin: EdgeInsets.only(top: 60),
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  text: tr('save selection'),
                  width: 300,
                  upperCase: true,
                  isSelected: true,
                  isDisabled: false,
                  onPressed: () => onSaveSelection(id, title),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
