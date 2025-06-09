import 'package:flutter/material.dart';

class SetupPageViewTemplate extends StatelessWidget {
  const SetupPageViewTemplate({
    this.minimum = const EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 16,
    ),
    required this.body,
    required this.footer,
    Key? key,
  }) : super(key: key);
  final EdgeInsets minimum;
  final Widget body;
  final Widget footer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          minimum: minimum,
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand,
            children: [
              body,
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  footer,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
