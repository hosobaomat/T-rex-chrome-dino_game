import 'dart:async';

import 'package:dino_game/components/obstacle.dart';
import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Dino extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  Dino() : super() {
    debugMode = true;
  }
  double velocity = 0;
  double gravity = 2000;
  double jumpForce = 600;
  bool isOnGround = true;
  bool isJumping = false;
  double groundY = 314;
  late final Sprite standingSprite;
  late final SpriteAnimation runAnimation;
  late final Sprite jumpAnimation;
  @override
  FutureOr<void> onLoad() async {
    List<Sprite> spriteList = [
      await Sprite.load('dino_3.png'),
      await Sprite.load('dino_4.png'),
    ];
    runAnimation = SpriteAnimation.spriteList(spriteList, stepTime: 0.09);
    jumpAnimation = await Sprite.load('dino_1.png');
    standingSprite = await Sprite.load('DinoStart.png');
    size = Vector2(48, 54);
    position = Vector2(50, game.size.y / 2 - 40);
    animation = SpriteAnimation.spriteList([standingSprite], stepTime: 1);
    add(
      RectangleHitbox.relative(
        //tuy chinh hitbox
        Vector2(0.7, 0.9),
        parentSize: size,
        position: Vector2(0.15 * size.x, 0.05 * size.y),
      ),
    );
    return super.onLoad();
  }

  void StartGame() {//neu nhan man hinh thi mac dinh nhay
    if (!Constants.startGame) {
      Constants.startGame = true;
      jump();
      animation = runAnimation;
    }
  }

  void jump() {
    if (isOnGround) {
      velocity = -jumpForce;
      isOnGround = false;
      isJumping = true;
      animation = SpriteAnimation.spriteList([jumpAnimation], stepTime: 1);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (Constants.startGame && !isOnGround) {
      velocity += gravity * dt;
      position.y += velocity * dt;
      if (position.y >= groundY) {
        position.y = groundY;
        velocity = 0;
        isOnGround = true;
        if (isJumping) {
          isJumping = false;
          animation = runAnimation;
        }
      }
    }
  }

  void gameOver() {
    game.pauseEngine();
    game.overlays.add('end');
  }

  void resetGame() {
    Constants.startGame = false;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      gameOver();
    }
  }
}
