import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/screens/dashboard/remoteQuran/surahSwiper/swipeItem.dart';
import 'package:masjidhub/provider/bleProvider.dart';

class SurahSwiper extends StatelessWidget {
  const SurahSwiper({
    Key? key,
    required this.maxWidth,
  }) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Consumer<BleProvider>(
      builder: (ctx, ble, _) => Container(
        margin: EdgeInsets.only(top: 50),
        width: maxWidth,
        height: 300,
        child: Swiper(
          itemBuilder: (BuildContext context, int i) => SwipeItem(index: i),
          itemCount: 114,
          viewportFraction: 0.8,
          controller: ble.remoteSwiperController,
          onIndexChanged: (index) => ble.setRemoteSurahInView(index + 1),
          scale: 0.9,
        ),
      ),
    );
  }
}
