import 'package:flutter/material.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class SetupHeaderImage extends StatelessWidget {
  final String image;

  const SetupHeaderImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  final double imageHeight = 150;
  final double imageWidth = 150;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: imageHeight,
        width: imageWidth,
        color: CustomTheme.lightTheme.colorScheme.background,
        child: Container(
          height: imageHeight,
          width: imageWidth,
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.spindle),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.fill,
            ),
            boxShadow: shadowNeu,
            shape: BoxShape.circle,
          ),
          child: Container(
            height: imageHeight,
            width: imageWidth,
            decoration: ConcaveDecoration(
              depth: 20,
              shape: CircleBorder(),
              colors: [Colors.white, CustomColors.spindle],
              size: Size(imageWidth, imageHeight),
            ),
          ),
        ),
      ),
    );
  }
}
