import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ConcaveDecoration extends Decoration {
  final ShapeBorder shape;
  final double depth;
  final List<Color> colors;
  final double opacity;
  final Size size;
  final bool inverse;

  ConcaveDecoration({
    required this.shape,
    required this.depth,
    required this.size,
    this.colors = const [Colors.black87, Colors.white],
    this.opacity = 1.0,
    this.inverse = false,
  }) : assert(colors.length == 2);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _ConcaveDecorationPainter(shape, depth, colors, opacity, size, inverse);

  @override
  EdgeInsetsGeometry get padding => shape.dimensions;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is ConcaveDecoration) {
      t = Curves.easeInOut.transform(t);
      return ConcaveDecoration(
          shape: ShapeBorder.lerp(a.shape, shape, t) ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
          depth: ui.lerpDouble(a.depth, depth, t) ?? 10,
          colors: [
            Color.lerp(a.colors[0], colors[0], t) ?? Colors.black,
            Color.lerp(a.colors[1], colors[1], t) ?? Colors.black,
          ],
          opacity: ui.lerpDouble(a.opacity, opacity, t) ?? 1,
          size: this.size);
    }
    return null;
  }
}

class _ConcaveDecorationPainter extends BoxPainter {
  ShapeBorder shape;
  double depth;
  Size size;
  List<Color> colors;
  double opacity;
  bool inverse;

  _ConcaveDecorationPainter(this.shape, this.depth, this.colors, this.opacity,
      this.size, this.inverse) {
    if (depth > 0) {
      colors = [
        colors[1],
        colors[0],
      ];
    } else {
      depth = -depth;
    }
    colors = [
      colors[0].withValues(alpha: opacity),
      colors[1].withValues(alpha: opacity),
    ];
  }

  @override
  void paint(
      ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final shapePath = shape.getOuterPath(offset & size);
    final rect = shapePath.getBounds();

    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depth * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth);
    final clipSize = rect.size.aspectRatio > 1
        ? Size(rect.width, rect.height / 2)
        : Size(rect.width / 2, rect.height);
    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect =
          alignment.inscribe(Size.square(rect.longestSide), rect);
      paint
        ..shader = inverse
            ? ui.Gradient.linear(
                shaderRect.bottomLeft, shaderRect.topRight, colors, stops)
            : ui.Gradient.linear(
                shaderRect.topLeft, shaderRect.bottomRight, colors, stops);

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }
}
