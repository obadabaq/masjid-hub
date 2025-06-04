import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/counter/counter.dart';
import 'package:masjidhub/provider/tesbihProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class TesbihSubSettings extends StatefulWidget {
  const TesbihSubSettings({Key? key}) : super(key: key);

  @override
  _TesbihSubSettingsState createState() => _TesbihSubSettingsState();
}

class _TesbihSubSettingsState extends State<TesbihSubSettings> {
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 30),
          child: Text(
            tr('selectDhikrGoal').replaceAll('\\n', '\n'),
            style: TextStyle(
              fontSize: 16.0,
              height: 1.3,
              color: CustomColors.blackPearl.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Counter(
            count: tesbihGoal,
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            onIncrementPressed: () => _incrementTesbihGoal(),
            onDecrementPressed: () => _decrementTesbihGoal(),
            lowerLimit: 33,
            label: tr(
              'daily dhikrs',
            )),
      ],
    );
  }
}
