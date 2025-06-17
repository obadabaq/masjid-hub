import 'package:flutter/cupertino.dart';

import 'package:masjidhub/common/quran/surah/chapterIconWithNumber.dart';
import 'package:masjidhub/constants/quran.dart';
import 'package:masjidhub/models/quranChapterModel.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:provider/provider.dart';

class SurahPageHeader extends StatelessWidget {
  const SurahPageHeader({
    this.chapter,
    required this.onSurahChanged,
    Key? key,
  }) : super(key: key);

  final QuranChapterModel? chapter;
  final Function onSurahChanged;

  @override
  Widget build(BuildContext context) {
    // left chevron is next
    Future<void> onSurahToggle(
      ToggleAction action, {
      bool isDisabled = false,
    }) async {
      // if (isDisabled) return;
      int upcomingSurahId =
          QuranUtils().getUpcomingSurahId(action, chapter!.id);
      await Provider.of<QuranProvider>(context, listen: false)
          .setSelectedSurah(upcomingSurahId);

      onSurahChanged();
    }

    final Color enabledToggle = CustomColors.blackPearl;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 10),
      child: Consumer<AudioProvider>(
        builder: (ctx, audioProvider, _) {
          // final bool isSurahToggleDisabled =
          //     audioProvider.audioPlayer.state == PlayerState.PLAYING;

          final bool isSurahToggleDisabled =
              false; // allow toggle while playing audio

          final Color toggleColor = enabledToggle;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onSurahToggle(ToggleAction.next,
                    isDisabled: isSurahToggleDisabled),
                child: Icon(
                  CupertinoIcons.chevron_left,
                  size: 40,
                  color: toggleColor,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: ChapterIconWithNumber(
                          text: chapter!.id.toString(),
                          size: 38,
                        ),
                      ),
                      Text(
                        '${chapter?.chapterName}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.blackPearl,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${chapter?.chapterNameMeaning}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: CustomColors.blackPearl.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onSurahToggle(ToggleAction.previous,
                    isDisabled: isSurahToggleDisabled),
                child: Icon(
                  CupertinoIcons.chevron_right,
                  size: 40,
                  color: toggleColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
