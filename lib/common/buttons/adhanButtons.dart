import 'dart:async';
import 'package:flutter/material.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class AdhanButton extends StatefulWidget {
  AdhanButton({
    Key? key,
    required this.onClick,
    required this.text,
    required this.icon,
    required this.height,
    required this.width,
    required this.id,
    required this.isSelected,
  }) : super(key: key);

  final Function onClick;
  final String text;
  final double height;
  final double width;
  final IconData icon;
  final int id;
  final bool isSelected;

  @override
  _AdhanButtonState createState() => _AdhanButtonState();
}

class _AdhanButtonState extends State<AdhanButton> {
  @override
  Widget build(BuildContext context) {
    bool _buttonSelected = widget.isSelected;
    List<BoxShadow> _buttonShadow =
        _buttonSelected ? shadowNeuPressed : shadowNeu;

    Future<void> _setShadow(shadow) async {
      setState(() {
        _buttonShadow = shadow;
      });
    }

    Future<void> _toggleButton() async {
      setState(() {
        _buttonSelected = !_buttonSelected;
      });
      if (_buttonSelected) {
        _setShadow(shadowNeuPressed);
      } else {
        _setShadow(shadowNeu);
      }
    }

    Future<void> _onButtonTap(int id) async {
      _toggleButton();
      widget.onClick(id);
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      width: widget.width,
      decoration: BoxDecoration(
        color: CustomTheme.lightTheme.colorScheme.background,
        boxShadow: _buttonShadow,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        gradient: _buttonSelected ? CustomColors.primary180 : null,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onButtonTap(widget.id),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      widget.icon,
                      size: 25,
                      color: _buttonSelected
                          ? Colors.white
                          : CustomColors.blackPearl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: _buttonSelected
                            ? Colors.white
                            : CustomColors.blackPearl,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
