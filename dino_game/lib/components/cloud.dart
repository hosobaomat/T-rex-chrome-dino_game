import 'dart:async';
import 'dart:math';

import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/components.dart';

class Cloud extends SpriteComponent with HasGameRef<MyGame> {
  Cloud();
  @override
  FutureOr<void> onLoad() async {
    final random = Random();
    double index = random.nextDouble();
    sprite = await Sprite.load('cloud.png');
    size = Vector2(62, 27);
    position = Vector2(game.size.x, 30 + index * 70);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= Constants.speedCloud * dt;
    if (position.x + size.x < 0) {
      removeFromParent();
    }
    super.update(dt);
  }
}
