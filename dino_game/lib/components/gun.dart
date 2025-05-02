import 'dart:async';

import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Gun extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  Gun() : super() {
    debugMode = true;
  }
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('AK47.png');
    size = Vector2(60, 50);
    position = Vector2(game.size.x, game.size.y / 2 - size.y);
    add(RectangleHitbox.relative(
      Vector2(0.8, 0.6),
      parentSize: size,
      anchor: Anchor.center,
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= dt * Constants.currentSpeed;
    if (position.x + size.x < 0) {
      removeFromParent();
    }
    super.update(dt);
  }

}
