import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget child;

  const Layout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: true,
          child: child,
        ),
      ),
    );
  }
}
