import 'dart:ui';

import 'extensions/offset.dart';
import 'extensions/vector2.dart';
import 'palette.dart';

class Sprite {
  Paint paint = BasicPalette.white.paint;
  Image image;
  Rect bounds;

  Sprite(
    this.image, {
    Vector2 position,
    Vector2 size,
  }) : assert(image != null, "image can't be null") {
    size ??= Vector2(image.width.toDouble(), image.height.toDouble());
    this.position = position;
  }

  double get _imageWidth => image.width.toDouble();

  double get _imageHeight => image.height.toDouble();

  Vector2 get originalSize => Vector2(_imageWidth, _imageHeight);

  Vector2 get size => Vector2(bounds.width, bounds.height);

  Vector2 get position => bounds.topLeft.toVector2();

  set position(Vector2 position) {
    bounds = (position ?? Vector2.zero()).toPositionedRect(size);
  }

  /// Renders this Sprite on the position [p], scaled by the [scale] factor provided.
  ///
  /// It renders with src size multiplied by [scale] in both directions.
  /// Anchor is on top left as default.
  /// If not loaded, does nothing.
  void renderScaled(
    Canvas canvas,
    Vector2 p, {
    double scale = 1.0,
    Paint overridePaint,
  }) {
    renderPosition(canvas, p, size: size * scale, overridePaint: overridePaint);
  }

  void renderPosition(
    Canvas canvas,
    Vector2 p, {
    Vector2 size,
    Paint overridePaint,
  }) {
    size ??= this.size;
    renderRect(canvas, p.toPositionedRect(size), overridePaint: overridePaint);
  }

  void render(
    Canvas canvas, {
    Vector2 size,
    Paint overridePaint,
  }) {
    size ??= this.size;
    renderRect(canvas, size.toRect(), overridePaint: overridePaint);
  }

  /// Renders this sprite centered in the position [p], i.e., on [p] - [size] / 2.
  ///
  /// If [size] is not provided, the original size of the src image is used.
  /// If the asset is not yet loaded, it does nothing.
  void renderCentered(
    Canvas canvas,
    Vector2 p, {
    Vector2 size,
    Paint overridePaint,
  }) {
    size ??= this.size;
    renderRect(
      canvas,
      (p - size / 2).toPositionedRect(size),
      overridePaint: overridePaint,
    );
  }

  void renderRect(
    Canvas canvas,
    Rect dst, {
    Paint overridePaint,
  }) {
    canvas.drawImageRect(image, bounds, dst, overridePaint ?? paint);
  }
}
