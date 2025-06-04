import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/provider/tesbihProvider.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihAnalytics/tesbihAnalyticsChart.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihAnalytics/tesbihButtons.dart';
import 'package:masjidhub/theme/colors.dart';

class TesbihAnalytics extends StatelessWidget {
  const TesbihAnalytics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TesbihProvider>(
      builder: (ctx, tesbih, _) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              tr('progress tracker'),
              style: TextStyle(
                fontSize: 20,
                height: 1.3,
                color: CustomColors.blackPearl,
              ),
            ),
            SizedBox(height: 20),
            TesbihAnalyticsChart(
              analyticsData: tesbih.getAnalyticsData(tesbih.analyticsState),
            ),
            SizedBox(height: 20),
            TesbihButtons(
              state: tesbih.analyticsState,
              setStateChange: tesbih.setAnalyticsState,
            )
          ],
        ),
      ),
    );
  }
}
