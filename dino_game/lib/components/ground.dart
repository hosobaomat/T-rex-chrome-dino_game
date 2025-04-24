import 'dart:async';

import 'package:dino_game/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';

class Ground extends ParallaxComponent {
  Ground():super(){
    debugMode = true;
  }
  @override
  FutureOr<void> onLoad() async {
    parallax = await game.loadParallax([ParallaxImageData('ground.png')],
        baseVelocity: Vector2(Constants.gamespeed, 0),
        alignment: Alignment.center,
        fill: LayerFill.none);
    return super.onLoad();
  }
}
