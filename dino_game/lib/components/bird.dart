import 'dart:async';
import 'dart:math';

import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bird extends SpriteAnimationComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Bird() : super() {
    debugMode = false;
  }
  List heigh = [70, 40];
  @override
  FutureOr<void> onLoad() async {
    final random = Random();
    int index = random.nextInt(2);
    List<Sprite> sprites = [
      await Sprite.load('ptera_1.png'),
      await Sprite.load('ptera_2.png'),
    ];
    SpriteAnimation sprite = SpriteAnimation.spriteList(sprites, stepTime: 0.3);
    size = Vector2(42, 30);
    position = Vector2(game.size.x, game.size.y / 2 - heigh[index]);
    animation = sprite;
    add(
      RectangleHitbox.relative(Vector2(0.8, 0.6),
          parentSize: size, anchor: Anchor.center),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= dt * (Constants.currentSpeed);
    if (position.x + size.x < 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
