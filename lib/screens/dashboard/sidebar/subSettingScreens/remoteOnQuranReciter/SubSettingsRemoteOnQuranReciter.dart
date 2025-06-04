import 'package:flutter/material.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/remoteOnRecitors.dart';
import 'package:masjidhub/models/radioListModel.dart';

class SubSettingsRemoteOnQuranReciter extends StatefulWidget {
  const SubSettingsRemoteOnQuranReciter({
    Key? key,
  }) : super(key: key);

  @override
  _QuranReciterState createState() => _QuranReciterState();
}

class _QuranReciterState extends State<SubSettingsRemoteOnQuranReciter> {
  @override
  Widget build(BuildContext context) {
    List<RadioListModel> list = [
      for (var i = 0; i < remoteOnRecitors.length; i++)
        RadioListModel(title: remoteOnRecitors[i].name, id: i)
    ];

    return Container(
      padding: EdgeInsets.only(left: 36, right: 36, bottom: 100),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Consumer<BleProvider>(
                  builder: (ctx, ble, _) => RadioList(
                    list: list,
                    onItemPressed: (id) => ble.onRemoteRecitorChange(id),
                    itemSelected: remoteOnRecitors.indexWhere(
                      (el) => el.prefix == ble.remoteRecitorPrefix,
                    ),
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
