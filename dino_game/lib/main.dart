import 'dart:async';
import 'dart:math';

import 'package:dino_game/components/bird.dart';
import 'package:dino_game/components/bullet.dart';
import 'package:dino_game/components/cloud.dart';
import 'package:dino_game/components/dino.dart';
import 'package:dino_game/components/ground.dart';
import 'package:dino_game/components/groundtile.dart';
import 'package:dino_game/components/gun.dart';
import 'package:dino_game/components/obstacle.dart';
import 'package:dino_game/overlays/game_over_overlay.dart';
import 'package:dino_game/overlays/guide.dart';
import 'package:dino_game/overlays/gun_pickup_overlay.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final appDocDir = await getApplicationDocumentsDirectory();
  //Hive.initFlutter(appDocDir.path);
  Hive.initFlutter();
  await Hive.openBox('gameBox');
  //dat huong man hinh la landscape(nam ngang)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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
      'GunPickupOverlay': (context, MyGame game) {
        return GunPickupOverlay(game: game);
      },
      'game content': (context, MyGame game) {
        return Guide(game: game,);
      }
    },
  ));
}

class MyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Dino dino;
  double nextSpawnTime = 0;
  double scoreTime = 0;
  bool hasSpawnGun = false;
  final double minGap = 250; // Khoảng cách ngang tối thiểu (pixel)
  final double birdSpawnInterval = 1.5; // giây giữa các lần spawn Bird
  late TextComponent scoreText;
  @override
  FutureOr<void> onLoad() async {
    final box = Hive.box('gameBox');
    Constants.highscore = box.get('highscore', defaultValue: 0);
    dino = Dino();
    await add(dino);
    scoreText = TextComponent(
        text: 'HI ${Constants.highscore} ${Constants.score}',
        position: Vector2(10, 10),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        )));
    await add(scoreText);
    overlays.add('game content');
    nextSpawnTime = Random().nextDouble() * 1.5 + 1.0;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapPos = info.eventPosition.global;
    if (!Constants.startGame) {
      overlays.remove('game content');
      dino.StartGame();
      StartGame();
    } else {
      if (tapPos.x > size.x * 0.7) {
        if (dino.hasGun) {
          dino.shoot();
        } else {
          dino.jump();
        }
      } else {
        dino.jump();
      }
    }
    super.onTapDown(info);
  }

  @override
  void update(double dt) {
    if (Constants.startGame) {
      scoreTime += dt;
      if (scoreTime >= 0.1) {
        //xu ly su kien va cham score bang 0 o overlay game_over
        Constants.score += 1;
        scoreText.text = 'HI ${Constants.highscore} ${Constants.score}';
        scoreTime = 0;
      }
      Constants.spawnTime += dt;
      Constants.spawnCloud += dt;
      Constants.spawnBird += dt;
      if (Constants.spawnTime > nextSpawnTime) {
        final spawnX = size.x;
        final tooClose = children
            .whereType<Bird>()
            .any((bird) => spawnX - bird.position.x < minGap);
        if (!tooClose) {
          //kiem tra xem gan do co bird chua neu chua thi spawn
          add(Obstacle());
          Constants.spawnTime = 0;
          nextSpawnTime = Random().nextDouble() * 1.5 + 1.0;
        }
      }
      if (Constants.spawnCloud > Constants.spawnTime) {
        add(Cloud());
        Constants.spawnCloud = 0;
      }
      if (Constants.score >= 0 && Constants.spawnBird > 2.5) {
        final spawnX = size.x;
        final tooClose = children
            .whereType<Obstacle>()
            .any((obs) => spawnX - obs.position.x < minGap);
        if (!tooClose) {
          //tuong tu ktra xem co obs gan day chua chua thi spawn
          add(Bird());
          Constants.spawnBird = 0;
        }
      }
      if (Constants.score % 200 == 0 && !hasSpawnGun) {
        // neu score chia het 200 va ko co gun thi se spawn tranh bi loi ko xoa dc gun khi
        //va cham do khi va cham chua xoa ma phai sang frame sau moi xoa ma cap nhat diem bi cham nen se ko xoa duoc gun
        add(Gun());
        hasSpawnGun = true;
      }
      if (Constants.score % 200 != 0) {
        hasSpawnGun = false;
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

  void showpickupGun() {
    overlays.add('GunPickupOverlay');
    Future.delayed(const Duration(seconds: 2), () {
      overlays.remove('GunPickupOverlay');
    });
  }

  void restartGame() {
    children.whereType<Gun>().forEach((g) => g.removeFromParent());
    children.whereType<Bird>().forEach((a) => a.removeFromParent());
    children.whereType<GroundTile>().forEach((tile) => tile.removeFromParent());
    children.whereType<Obstacle>().forEach((obs) => obs.removeFromParent());
    children.whereType<Ground>().forEach((g) => g.removeFromParent());
    children.whereType<Cloud>().forEach((b) => b.removeFromParent());
    children.whereType<Bullet>().forEach((B) => B.removeFromParent());
    dino.removeFromParent();
    Constants.spawnTime = 0;
    Constants.startGame = false;
    dino = Dino();
    add(dino);
    //add(Ground());
    resumeEngine();
  }
}
