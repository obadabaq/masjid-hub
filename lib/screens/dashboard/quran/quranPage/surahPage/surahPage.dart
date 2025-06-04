import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/quran/surah/surahAppBar.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahPageContent.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahPageMediaPlayer/surahPageMediaPlayer.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/surahSideBar.dart';

class SurahPage extends StatefulWidget {
  final BuildContext contxt;

  const SurahPage({
    Key? key,
    required this.contxt,
    this.scrollPosition = 0,
    this.scrollToAyah = 0,
    this.showSurahPageMediaPlayer = false,
  }) : super(key: key);

  final double scrollPosition;
  final int scrollToAyah;
  final bool showSurahPageMediaPlayer;

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  GlobalKey<ScaffoldState> _dashboardScaffoldKey = GlobalKey();
  void openDrawer() => _dashboardScaffoldKey.currentState!.openDrawer();

  bool hideBottomNav = false; // Also for hiding text highlighting

  void setHideBottomNav() {
    setState(
      () => hideBottomNav = true,
    ); // When you go left or right on surah page header to change surah, it hides the bottom media player and stops text highlighting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _dashboardScaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        // BACKLOG REFACTOR maybe we should use only one appbar
        child: SurahAppBar(contxt: widget.contxt, onSettingsPress: openDrawer),
      ),
      body: Stack(
        children: [
          SurahPageContent(
            scrollPosition: widget.scrollPosition,
            scrollToAyah: widget.scrollToAyah,
            onSurahChanged: setHideBottomNav,
          ),
          Selector<AudioProvider, int>(
            selector: (_, select) => select.currentlyPlayingSurah,
            builder: (ctx, currentlyPlayingSurah, _) =>
                Selector<QuranProvider, int>(
              selector: (_, select) => select.getSelectedSurah,
              builder: (ctx, surahBeingRead, _) {
                bool shouldShowMediaPlayer =
                    surahBeingRead == currentlyPlayingSurah;

                if (shouldShowMediaPlayer) {
                  return SurahPageMediaPlayer();
                }

                return SizedBox();
              },
            ),
          ),
        ],
      ),
      drawer: SurahSideBar(),
    );
  }
}
