import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'selector.dart';
import 'utils.dart';
import 'package:flutter/foundation.dart';

import 'plant.dart';

class IsometricTileMapExample extends FlameGame
    with MouseMovementDetector, HasTappables {
  static const String description = '''
    Shows an example of how to use the `IsometricTileMapComponent`.\n\n
    Move the mouse over the board to see a selector appearing on the tiles.
  ''';

  late Vector2 topLeft;
  late Vector2 oldCanvasSize;

  static const scale = 2.0;
  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;

  static const halfSize = true;
  static const tileHeight = scale * (halfSize ? 8.0 : 16.0);
  static const suffix = halfSize ? '-short' : '';

  late IsometricTileMapComponent base;
  late Selector selector;
  late Plant plant;
  late SpriteSheet plantSpriteSheet;

  var rng = Random();

  IsometricTileMapExample();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    topLeft = (canvasSize / 2.0)..y = 50;
    oldCanvasSize = canvasSize;
    final tilesetImage = await images.load('tile_maps/tiles$suffix.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2.all(srcTileSize),
    );

    plantSpriteSheet = SpriteSheet(
      image: await images.load('plants.png'),
      srcSize: Vector2(16.0, 32.0),
    );

    final matrix = await readBitMap();
    add(
      base = IsometricTileMapComponent(
        tileset,
        matrix,
        destTileSize: Vector2.all(destTileSize),
        tileHeight: tileHeight,
        position: topLeft,
      ),
    );

    final selectorImage = await images.load('tile_maps/selector$suffix.png');
    add(selector = Selector(destTileSize, selectorImage));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (canvasSize != oldCanvasSize) {
      topLeft = (canvasSize / 2.0)..y = 50;
      base.position = topLeft;
    }
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.game;
    final block = base.getBlock(screenPosition);
    selector.show = base.containsBlock(block);
    selector.position.setFrom(topLeft + base.getBlockRenderPosition(block));
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    final block = base.getBlock(info.eventPosition.game);
    if (base.containsBlock(block)) {
      if (base.matrix[block.y][block.x] == 2) {
        if (kDebugMode) {
          print("already has a plant");
        }
      } else {
        base.matrix[block.y][block.x] = 2;
        add(Plant(destTileSize, rng.nextInt(17))
          ..position.setFrom(
              topLeft + base.getBlockRenderPosition(block) + Vector2(20, -8))
          ..scale = Vector2(1.5, 1.5));
      }
    }

    super.onTapDown(pointerId, info);
  }
}
