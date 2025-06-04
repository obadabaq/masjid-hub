import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/constants/tesbih/tesbihButtonsList.dart';
import 'package:masjidhub/utils/enums/tesbihAnalyticsEnums.dart';

class TesbihButtons extends StatelessWidget {
  final TesbihAnalyticsState state;
  final Function(TesbihAnalyticsState) setStateChange;

  const TesbihButtons({
    required this.state,
    required this.setStateChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxW = constraints.maxWidth;
        final double buttonWidth = maxW > 300 ? 300 : maxW;
        return Container(
          width: buttonWidth,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 25.0,
              mainAxisExtent: 50,
            ),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
            shrinkWrap: true,
            itemCount: tesbihButtonsList.length,
            itemBuilder: (BuildContext context, int index) {
              return PrimaryButton(
                id: index,
                text: tr(tesbihButtonsList[index].label),
                width: 150,
                padding: EdgeInsets.zero,
                onPressed: (id) => setStateChange(tesbihButtonsList[id].state),
                isSelected: state == tesbihButtonsList[index].state,
                isDisabled: false,
                fontSize: 15,
              );
            },
          ),
        );
      },
    );
  }
}
