import 'dart:async';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class NeuButton extends StatefulWidget {
  NeuButton({
    Key? key,
    this.onClick,
    required this.child,
    required this.height,
    required this.width,
    this.isSelected = false,
  }) : super(key: key);

  final Function? onClick;
  final Widget child;
  final double height;
  final double width;
  final bool isSelected;

  @override
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  List<BoxShadow> _buttonShadow = shadowNeuSecondary;
  Timer setTimeout(callback, [int duration = 1000]) {
    return Timer(Duration(milliseconds: duration), callback);
  }

  void clearTimeout(Timer t) {
    t.cancel();
  }

  Future<void> _setShadow(shadow) async {
    setState(() {
      _buttonShadow = shadow;
    });
  }

  Future<void>? _onButtonTap() async {
    if (widget.onClick == null) return null;
    _setShadow(shadowNeuPressed);
    widget.onClick!();
    return Future.delayed(
        Duration(milliseconds: 300), () => _setShadow(shadowNeuSecondary));
  }

  Future<void> _onButtonLongTap() async {
    _setShadow(shadowNeuPressed);
    widget.onClick!();
  }

  Future<void> _onButtonLongTapUp() async {
    _setShadow(shadowNeuSecondary);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          boxShadow: _buttonShadow,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          gradient: widget.isSelected ? CustomColors.primary180 : null),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: widget.child,
        onTap: () => _onButtonTap(),
        onLongPress: () => _onButtonLongTap(),
        onLongPressUp: () => _onButtonLongTapUp(),
      ),
    );
  }
}
