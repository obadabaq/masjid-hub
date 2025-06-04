import 'package:flutter/material.dart';

import 'package:masjidhub/common/audio/audioListItem.dart';
import 'package:masjidhub/constants/adhans.dart';

class PlaylistAdhanContent extends StatelessWidget {
  const PlaylistAdhanContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: adhanList.length,
      itemBuilder: (BuildContext context, int index) {
        return AudioListItem(
          id: adhanList[index].id,
          title: adhanList[index].title,
          subTitle: adhanList[index].subTitle,
          isSelected: 999 == adhanList[index].id,
          onPressed: (id) => print(id),
          onAudioPressed: (id) => print(id),
          isAudioSelected: 999 == adhanList[index].id,
        );
      },
    );
  }
}
