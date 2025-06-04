import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/common/errorPopups/errorPopup.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/constants/errors.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/utils/audioUtils.dart';
import 'package:provider/provider.dart';

class TooltipPlay extends StatelessWidget {
  const TooltipPlay({
    Key? key,
    required this.surahNumber,
    required this.ayah,
  }) : super(key: key);

  final int surahNumber;
  final int ayah;

  @override
  Widget build(BuildContext context) {
    //..
    void playAyah() async {
      bool isSurahDownloaded =
          await AudioUtils().isSurahDownloaded(surahNumber);

      if (isSurahDownloaded) {
        AudioProvider audio =
            Provider.of<AudioProvider>(context, listen: false);
        Future.delayed(const Duration(milliseconds: 1000), () {
          audio.playAyah(surahNumber, ayah);
        });
      } else {
        _showAllowNotificationsPopup(context);
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: playAyah,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.play_fill,
              size: 25,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  _showAllowNotificationsPopup(BuildContext context) => Navigator.push(
      context,
      PopupLayout(
          child: ErrorPopup(
        errorType: AppError.noSurah,
        showSubButton: true,
      )));
}
