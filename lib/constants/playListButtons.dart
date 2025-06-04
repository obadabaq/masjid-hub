import 'package:masjidhub/models/playListButtonModel.dart';
import 'package:masjidhub/utils/enums/playlistMode.dart';

final List<PlayListButtonModel> playListButtons = [
  PlayListButtonModel(
    title: 'quran',
    mode: PlayListMode.quran,
  ),
  PlayListButtonModel(
    title: 'recent',
    mode: PlayListMode.recent,
  ),
  PlayListButtonModel(
    title: 'adhan',
    mode: PlayListMode.adhan,
  ),
  PlayListButtonModel(
    title: 'search',
    mode: PlayListMode.search,
  ),
];
