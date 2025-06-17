import 'package:flutter/material.dart';

import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';

class FontSizeSwitch extends StatelessWidget {
  const FontSizeSwitch({
    Key? key,
    required this.label,
    required this.selectedSize,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final FontSize selectedSize;
  final Function(FontSize) onChange;

  static List<FontSize> fontSizes = FontSize.values;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 45, bottom: 10),
                child: Text(
                  label,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: CustomColors.blackPearl.withOpacity(0.7),
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              for (var i = 0; i < fontSizes.length; i++)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return PrimaryButton(
                          text: fontSizes[i].text,
                          width: constraints.maxWidth,
                          fontSize: fontSizes[i].btnSize,
                          fontWeight: FontWeight.w600,
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                          isSelected: selectedSize == fontSizes[i],
                          isDisabled: false,
                          onPressed: () => onChange(fontSizes[i]),
                        );
                      },
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
