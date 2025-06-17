import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/provider/quranProvider.dart';

class TooltipShare extends StatelessWidget {
  const TooltipShare({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void shareAyah() async {
      Provider.of<QuranProvider>(context, listen: false);
    }

    return Consumer<QuranProvider>(
      builder: (ctx, quran, _) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => shareAyah(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${tr('share')}...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
