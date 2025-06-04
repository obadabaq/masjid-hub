import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupContent/PlaylistSearchContent.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupContent/playlistAdhanContent.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupContent/playlistRecentSurahList.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupContent/playlistSurahList.dart';
import 'package:masjidhub/utils/enums/playlistMode.dart';

class PlaylistPopupContent extends StatelessWidget {
  const PlaylistPopupContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<QuranProvider>(builder: (ctx, quran, _) {
        Widget getPlaylistContent() {
          switch (quran.playListMode) {
            case PlayListMode.quran:
              return PlaylistSurahList();
            case PlayListMode.recent:
              return PlaylistRecentSurahList();
            case PlayListMode.adhan:
              return PlaylistAdhanContent();
            case PlayListMode.search:
              return PlaylistSearchContent();
          }
        }

        return getPlaylistContent();
      }),
    );
  }
}
