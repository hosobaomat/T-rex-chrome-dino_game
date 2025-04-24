import 'dart:async';
import 'dart:math';

import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Obstacle extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Obstacle() : super() {
    debugMode = false;
  }
  List<Vector2> spriteSize = [
    Vector2(64, 60),
    Vector2(30, 60),
    Vector2(58, 60),
    Vector2(24, 50),
    Vector2(48, 50),
    Vector2(62, 50),
  ];
  @override
  FutureOr<void> onLoad() async {
    // Random index từ 0 đến 5
    final random = Random();
    int index = random.nextInt(6);
    // Load sprite tương ứng
    sprite = await Sprite.load('cacti_$index.png');
    size = spriteSize[index];
    position = Vector2(game.size.x, game.size.y / 2 - size.y + 13);
    add(RectangleHitbox.relative(
      Vector2(0.8, 0.9),
      parentSize: size,
      position: Vector2(0.15 * size.y, 0.05 * size.x),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= Constants.gamespeed * dt;
    if (position.x + size.x < 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
