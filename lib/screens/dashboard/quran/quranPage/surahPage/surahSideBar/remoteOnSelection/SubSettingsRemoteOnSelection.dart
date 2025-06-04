import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/buttons/neuButton.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/constants/surahsInQuran.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/bleUtils.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/remoteOnSelection/surahSelectionItem.dart';

class SubSettingsRemoteOnSelection extends StatefulWidget {
  const SubSettingsRemoteOnSelection({
    Key? key,
  }) : super(key: key);

  @override
  _SubSettingsRemoteOnSelection createState() =>
      _SubSettingsRemoteOnSelection();
}

class _SubSettingsRemoteOnSelection
    extends State<SubSettingsRemoteOnSelection> {
  @override
  Widget build(BuildContext context) {
    Future<void> onStartSurahClicked(
      BuildContext ctx,
      BleProvider ble,
      double width,
    ) async {
      await _showPicker(
        ctx,
        list: surahsInQuran,
        width: width,
        type: RemoteSelectionItem.startSurah,
        onChange: (val) {
          ble.setRemoteOnSelection(val, RemoteSelectionItem.startSurah);
        },
      );
    }

    Future<void> onStartAyahClicked(
      BuildContext ctx,
      BleProvider ble,
      double width,
    ) async {
      await _showPicker(
        ctx,
        width: width,
        list: ble.getAyahList,
        type: RemoteSelectionItem.startAyah,
        onChange: (val) {
          ble.setRemoteOnSelection(val, RemoteSelectionItem.startAyah);
        },
      );
    }

    Future<void> onEndAyahClicked(
      BuildContext ctx,
      BleProvider ble,
      double width,
    ) async {
      await _showPicker(
        ctx,
        width: width,
        list: ble.getAyahList,
        type: RemoteSelectionItem.endAyah,
        onChange: (val) {
          ble.setRemoteOnSelection(val, RemoteSelectionItem.endAyah);
        },
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerWidth = constraints.maxWidth * 0.90;
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Consumer<BleProvider>(builder: (ctx, ble, _) {
              List<String> labels =
                  BleUtils().getSelectionLabels(ble.remoteOnSelection);

              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 12),
                        child: Text(
                          tr('surah'),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: CustomColors.mischka,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SurahSelectionItem(
                    text: labels[0],
                    onClick: () =>
                        onStartSurahClicked(ctx, ble, _containerWidth),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 25, 0, 12),
                        child: Text(
                          tr('start ayah'),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: CustomColors.mischka,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SurahSelectionItem(
                    text: labels[1],
                    onClick: () =>
                        onStartAyahClicked(ctx, ble, _containerWidth),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 25, 0, 12),
                        child: Text(
                          tr('end ayah'),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: CustomColors.mischka,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SurahSelectionItem(
                    text: labels[2],
                    onClick: () => onEndAyahClicked(ctx, ble, _containerWidth),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: NeuButton(
                      isSelected: true,
                      onClick: () {
                        ble.setPlaySelection();
                        Navigator.popUntil(context,
                            ModalRoute.withName(Navigator.defaultRouteName));
                      },
                      height: 65,
                      width: _containerWidth * 0.90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 12, right: 10),
                            child: Text(
                              tr('start listening'),
                              style: TextStyle(
                                fontSize: 20,
                                height: 1.3,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

Future<void> _showPicker(
  BuildContext ctx, {
  required List list,
  required RemoteSelectionItem type,
  required Function(int) onChange,
  required double width,
}) async {
  await showCupertinoModalPopup(
    context: ctx,
    barrierColor: CustomColors.solitude.withOpacity(0.7),
    barrierDismissible: true,
    builder: (_) {
      int _selectedValue = 2;
      return Container(
        width: width,
        height: 450,
        padding: EdgeInsets.only(bottom: 40),
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          boxShadow: tertiaryShadow,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                backgroundColor: CustomTheme.lightTheme.colorScheme.background,
                itemExtent: 50,
                squeeze: 0.95,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  for (var i = 0; i < list.length; i++)
                    Text(
                      '${list[i]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: CustomColors.blackPearl,
                      ),
                    )
                ],
                onSelectedItemChanged: (value) {
                  _selectedValue = value + 1;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: NeuButton(
                isSelected: true,
                onClick: () {
                  onChange(_selectedValue);
                  Navigator.pop(ctx);
                },
                height: 50,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.3,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
