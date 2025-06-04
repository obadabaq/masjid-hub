import 'package:flutter/material.dart';
import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/constants/playListButtons.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/utils/enums/playlistMode.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PlaylistPopupButtons extends StatelessWidget {
  const PlaylistPopupButtons({Key? key}) : super(key: key);

  void handlePressed({
    required int id,
    required Function(PlayListMode) onChange,
  }) {
    final PlayListMode mode = playListButtons[id].mode;
    onChange(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<QuranProvider>(
        builder: (ctx, quran, _) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  id: 0,
                  text: tr(playListButtons[0].title),
                  width: 120,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  margin: EdgeInsets.only(right: 10),
                  onPressed: (id) =>
                      handlePressed(id: id, onChange: quran.setPlayListMode),
                  isSelected: playListButtons[0].mode == quran.playListMode,
                  isDisabled: false,
                ),
                PrimaryButton(
                  id: 1,
                  text: tr(playListButtons[1].title),
                  width: 120,
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  onPressed: (id) =>
                      handlePressed(id: id, onChange: quran.setPlayListMode),
                  isSelected: playListButtons[1].mode == quran.playListMode,
                  isDisabled: false,
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  id: 2,
                  text: tr(playListButtons[2].title),
                  width: 120,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  margin: EdgeInsets.only(right: 10),
                  onPressed: (id) =>
                      handlePressed(id: id, onChange: quran.setPlayListMode),
                  isSelected: playListButtons[2].mode == quran.playListMode,
                  isDisabled: false,
                ),
                PrimaryButton(
                  id: 3,
                  text: tr(playListButtons[3].title),
                  width: 120,
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  onPressed: (id) =>
                      handlePressed(id: id, onChange: quran.setPlayListMode),
                  isSelected: playListButtons[3].mode == quran.playListMode,
                  isDisabled: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
