import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/common/buttons/mediaButton/MediaButtonContent.dart';
import 'package:masjidhub/common/icons/app_icons.dart';

enum MediaButtonType { next, previous, pause, play, scroll }

enum MediaButtonState { normal, active, pressed }

class MediaButton extends StatelessWidget {
  const MediaButton({
    Key? key,
    required this.type,
    this.margin = EdgeInsets.zero,
    required this.onPressed,
    this.state = MediaButtonState.normal,
    this.isDisabled = false,
  }) : super(key: key);

  final EdgeInsets margin;
  final MediaButtonType type;
  final Function onPressed;
  final MediaButtonState state;
  final bool isDisabled;

  Widget switchLocationWidget() {
    switch (type) {
      case MediaButtonType.next:
        return MediaButtonContent(
          icon: CupertinoIcons.forward_end_fill,
          margin: margin,
          onPressed: onPressed,
          state: state,
          isDisabled: isDisabled,
        );
      case MediaButtonType.previous:
        return MediaButtonContent(
          icon: CupertinoIcons.backward_end_fill,
          margin: margin,
          onPressed: onPressed,
          state: state,
          isDisabled: isDisabled,
        );
      case MediaButtonType.pause:
        return MediaButtonContent(
          icon: Icons.pause,
          margin: margin,
          onPressed: onPressed,
          state: state,
          isDisabled: isDisabled,
        );
      case MediaButtonType.play:
        return MediaButtonContent(
          icon: CupertinoIcons.play_fill,
          margin: margin,
          onPressed: onPressed,
          state: state,
          isDisabled: isDisabled,
        );
      case MediaButtonType.scroll:
        return MediaButtonContent(
          icon: AppIcons.track,
          margin: margin,
          state: state,
          onPressed: onPressed,
          isDisabled: isDisabled,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return switchLocationWidget();
  }
}
