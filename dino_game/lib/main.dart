import 'dart:async';
import 'dart:math';

import 'package:dino_game/components/dino.dart';
import 'package:dino_game/components/ground.dart';
import 'package:dino_game/components/groundtile.dart';
import 'package:dino_game/components/obstacle.dart';
import 'package:dino_game/overlays/game_over_overlay.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(
    game: MyGame(),
    overlayBuilderMap: {
      // 'start': (context, MyGame game) {
      //   return StartGameOverlay(game: game);
      // },
      'end': (context, MyGame game) {
        return GameOverOverlay(game: game);
      },
      // 'setting': (context, MyGame game) {
      //   return SettingOverlay(game: game);
      // }
    },
  ));
}

class MyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Dino dino;
  double nextSpawnTime = 0;
  @override
  FutureOr<void> onLoad() {
    dino = Dino();
    add(dino);
    nextSpawnTime = Random().nextDouble() * 1.5 + 1.0;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!Constants.startGame) {
      dino.StartGame();
      StartGame();
    } else {
      dino.jump();
    }
    super.onTapDown(info);
  }

  @override
  void update(double dt) {
    if (Constants.startGame) {
      Constants.spawnTime += dt;
      if (Constants.spawnTime > nextSpawnTime) {
        add(Obstacle());
        Constants.spawnTime = 0;
        nextSpawnTime = Random().nextDouble() * 1.5 + 1.0;
      }
    }
    super.update(dt);
  }

  void StartGame() {
    final tileWidth = 32.0;
    final groundY = dino.groundY + dino.size.y - 10;

    final dinoCenterX = dino.position.x + dino.size.x / 2;
    final numTiles = (size.x / tileWidth).ceil(); // Số lượng mảnh đất cần

    for (int i = 0; i <= numTiles ~/ 2; i++) {
      Future.delayed(Duration(milliseconds: 40 * i), () {
        // Mảnh bên phải
        final posRight = Vector2(dinoCenterX + i * tileWidth, groundY);
        add(GroundTile(posRight));

        // Mảnh bên trái (nếu còn trong màn hình)
        final posLeft = Vector2(dinoCenterX - (i + 1) * tileWidth, groundY);
        if (posLeft.x >= 0) {
          add(GroundTile(posLeft));
        }
      });
    }
    //
    add(Ground());
  }

  void restartGame() {
    children.whereType<GroundTile>().forEach((tile) => tile.removeFromParent());
    children.whereType<Obstacle>().forEach((obs) => obs.removeFromParent());
    children.whereType<Ground>().forEach((g) => g.removeFromParent());
    dino.removeFromParent();
    Constants.spawnTime = 0;
    Constants.startGame = false;
    dino = Dino();
    add(dino);
    //add(Ground());
    resumeEngine();
  }
}
