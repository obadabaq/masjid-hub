import 'package:flutter/material.dart';
import 'package:masjidhub/provider/bottom_bar_provider.dart';
import 'package:provider/provider.dart';

class ScrollableMainScreen extends StatefulWidget {
  const ScrollableMainScreen({
    required this.child,
    this.scrollController,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final ScrollController? scrollController;
  @override
  State<ScrollableMainScreen> createState() => _ScrollableMainScreenState();
}

class _ScrollableMainScreenState extends State<ScrollableMainScreen> {
  late ScrollController scrollController;
  double _lastScrollOffset = 0;
  bool _isScrollingDown = false;
  final double _threshold = 50.0; // Minimum pixels to consider it a scroll

  void _scrollListener() {
    final currentOffset = scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;
    final state = Provider.of<BottomBarProvider>(context, listen: false);
    if (delta.abs() > _threshold) {
      if (delta > 0 && !_isScrollingDown) {
        print('Significant scroll DOWN detected');
        state.hideTheBottomNavBar();
      } else if (delta < 0 && _isScrollingDown) {
        print('Significant scroll UP detected');
        state.displayTheBottomNavBar();
      }

      _lastScrollOffset = currentOffset;
    }
  }

  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomState = Provider.of<BottomBarProvider>(context, listen: true);
    bottomState.addListener(() {
      if (bottomState.isNavBarVisible) {
        if (mounted)
          setState(() {
            _isScrollingDown = false;
          });
      } else {
        if (mounted)
          setState(() {
            _isScrollingDown = true;
          });
      }
    });
    return widget.child;
  }
}
