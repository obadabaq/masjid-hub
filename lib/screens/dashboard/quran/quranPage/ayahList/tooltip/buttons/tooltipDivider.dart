import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

class TooltipDivider extends StatelessWidget {
  const TooltipDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(thickness: 1, color: CustomColors.gunPowder);
  }
}
