import 'package:flutter/material.dart';
import 'package:masjidhub/theme/colors.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final EdgeInsetsGeometry? padding;

  final Color color, textColor;
  const CustomFlatButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = CustomColors.solitude,
    this.textColor = CustomColors.mischka,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: padding,
      child: SizedBox(
        width: size.width * 0.8,
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () => onPressed(),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProText',
            ),
          ),
        ),
      ),
    );
  }
}
