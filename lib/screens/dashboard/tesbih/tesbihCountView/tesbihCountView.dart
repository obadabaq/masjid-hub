import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/provider/tesbihProvider.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/theme/colors.dart';

class TesbihCountView extends StatelessWidget {
  const TesbihCountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TesbihProvider>(
      builder: (ctx, tesbih, _) {
        final int currentTesbihCount = tesbih.getTesbihCount;
        final int todaysTesbihCount = SharedPrefs().getTesbihCountToday;

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            children: [
              Text(
                '$currentTesbihCount / $todaysTesbihCount',
                style: TextStyle(
                  fontSize: 30,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.blackPearl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  tr('new / today'),
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    color: CustomColors.irisBlue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
