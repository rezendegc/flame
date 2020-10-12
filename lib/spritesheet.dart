import 'dart:ui';

import 'package:meta/meta.dart';

import 'sprite.dart';
import 'sprite_animation.dart';
import 'extensions/vector2.dart';

/// Utility class to help extract animations and sprites from a spritesheet image
class SpriteSheet {
  int textureWidth;
  int textureHeight;
  int columns;
  int rows;

  List<List<Sprite>> _sprites;

  SpriteSheet({
    @required Image image,
    @required this.textureWidth,
    @required this.textureHeight,
    @required this.columns,
    @required this.rows,
  }) {
    _sprites = List.generate(
      rows,
      (y) => List.generate(
        columns,
        (x) => _mapImagePath(image, textureWidth, textureHeight, x, y),
      ),
    );
  }

  Sprite _mapImagePath(
    Image image,
    int textureWidth,
    int textureHeight,
    int x,
    int y,
  ) {
    final size = Vector2(textureWidth.toDouble(), textureHeight.toDouble());
    return Sprite(
      image,
      srcPosition: Vector2(x.toDouble(), y.toDouble())..multiply(size),
      size: size,
    );
  }

  Sprite getSprite(int row, int column) {
    final Sprite s = _sprites[row][column];

    assert(s != null, 'No sprite found for row $row and column $column');

    return s;
  }

  /// Creates a sprite animation from this SpriteSheet
  ///
  /// An [from] and a [to]  parameter can be specified to create an animation from a subset of the columns on the row
  SpriteAnimation createAnimation(int row,
      {double stepTime, bool loop = true, int from = 0, int to}) {
    final spriteRow = _sprites[row];

    assert(spriteRow != null, 'There is no row for $row index');

    to ??= spriteRow.length;

    final spriteList = spriteRow.sublist(from, to);

    return SpriteAnimation.spriteList(
      spriteList,
      stepTime: stepTime,
      loop: loop,
    );
  }
}
