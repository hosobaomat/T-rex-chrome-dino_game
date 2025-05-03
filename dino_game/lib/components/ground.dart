import 'dart:async';

import 'package:dino_game/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';

class Ground extends ParallaxComponent {
  Ground() : super() {
    debugMode = false;
  }
  @override
  FutureOr<void> onLoad() async {
    parallax = await game.loadParallax([ParallaxImageData('ground.png')],
        baseVelocity: Vector2(Constants.currentSpeed, 0),
        alignment: Alignment.center,
        fill: LayerFill.none);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    parallax?.baseVelocity = Vector2(Constants.currentSpeed, 0);
    super.update(dt);
  }
}
