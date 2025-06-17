import 'package:flutter/material.dart';
import 'package:masjidhub/screens/setupScreens/utils/setup_pageview_template.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/counter/counter.dart';

import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/provider/tesbihProvider.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class ChooseTesbih extends StatefulWidget {
  final PageController pageController;

  ChooseTesbih({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _ChooseTesbihState createState() => _ChooseTesbihState();
}

class _ChooseTesbihState extends State<ChooseTesbih> {
  static int tesbihGoal = SharedPrefs().getTesbihGoal;
  static int tesbihGoalChangeInterval = 33;

  Future<void> _incrementTesbihGoal() async {
    setState(() => tesbihGoal = tesbihGoal + tesbihGoalChangeInterval);
    await SharedPrefs().setTesbihGoal(tesbihGoal);
    Provider.of<TesbihProvider>(context, listen: false).updateAnalytics();
  }

  Future<void> _decrementTesbihGoal() async {
    setState(() => tesbihGoal = tesbihGoal - tesbihGoalChangeInterval);
    await SharedPrefs().setTesbihGoal(tesbihGoal);
    Provider.of<TesbihProvider>(context, listen: false).updateAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return SetupPageViewTemplate(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final _topPadding = constraints.maxHeight * 0.05;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _topPadding),
                  child: SetupHeaderImage(image: tesbihSetupImage),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    tr('daily dhikr goal'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: CustomColors.blackPearl,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                  child: Text(
                    tr('selectDhikrGoal').replaceAll('\\n', '\n'),
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                      color: CustomColors.blackPearl.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Counter(
                  count: tesbihGoal,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  onIncrementPressed: () => _incrementTesbihGoal(),
                  onDecrementPressed: () => _decrementTesbihGoal(),
                  lowerLimit: 34,
                  label: tr('daily dhikrs'),
                ),
              ],
            ),
          );
        },
      ),
      footer: SetupFooter(
        currentPage: 4,
        margin: EdgeInsets.only(bottom: 30),
        buttonText: tr('next'),
        controller: widget.pageController,
      ),
    );
  }
}
