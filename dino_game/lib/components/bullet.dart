import 'dart:async';

import 'package:dino_game/components/bird.dart';
import 'package:dino_game/components/obstacle.dart';
import 'package:dino_game/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bullet extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Bullet(Vector2 startPosition) : super() {
    debugMode = true;
    position = startPosition;
  }
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('bullet_1-2.png');
    size = Vector2(640, 512);
    add(RectangleHitbox.relative(
      Vector2(0.02, 0.02),
      parentSize: size,
      anchor: Anchor.center,
    ));
    //position = Vector2(100 - size.x / 2, game.size.y / 2 - size.y / 2 - 5);
    print(position.x);
    print(position.y);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x += 400 * dt;
    if (position.x > game.size.x) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle || other is Bird) {
      other.removeFromParent();
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
