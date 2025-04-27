import 'dart:async';

import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/components.dart';

class GroundTile extends SpriteComponent with HasGameRef<MyGame> {
  GroundTile(Vector2 position)
      : super(size: Vector2(32, 12), position: position); //kich thuoc 1 manh
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('ground.png');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (Constants.startGame) {
      position.x -= Constants.currentSpeed * dt;
      if (position.x + size.x < 0) {
        removeFromParent();
      }
    }
    super.update(dt);
  }
}
