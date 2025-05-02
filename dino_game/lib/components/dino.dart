import 'dart:async';

import 'package:dino_game/components/bird.dart';
import 'package:dino_game/components/bullet.dart';
import 'package:dino_game/components/gun.dart';
import 'package:dino_game/components/obstacle.dart';
import 'package:dino_game/main.dart';
import 'package:dino_game/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/timer.dart';

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
  double groundY = 0;
  bool hasGun = false;
  Timer? guntimer;
  late final SpriteAnimation gunSprite;
  late final Sprite standingSprite;
  late final SpriteAnimation runAnimation;
  late final Sprite jumpAnimation;
  @override
  FutureOr<void> onLoad() async {
    groundY = game.size.y / 2 - 40;
    List<Sprite> spriteList = [
      await Sprite.load('dino_3.png'),
      await Sprite.load('dino_4.png'),
    ];
    List<Sprite> GunSpriteList = [
      await Sprite.load('dino_3_camAK.png'),
      await Sprite.load('dino_4_camAK.png'),
    ];
    runAnimation = SpriteAnimation.spriteList(spriteList, stepTime: 0.09);
    jumpAnimation = await Sprite.load('dino_1.png');
    standingSprite = await Sprite.load('DinoStart.png');
    gunSprite = SpriteAnimation.spriteList(GunSpriteList, stepTime: 0.09);
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

  void StartGame() {
    //neu nhan man hinh thi mac dinh nhay
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
    guntimer?.update(dt);
    if (Constants.startGame && !isOnGround) {
      velocity += gravity * dt;
      position.y += velocity * dt;
      if (position.y >= groundY) {
        // print(game.size.y / 2);
        position.y = groundY;
        velocity = 0;
        isOnGround = true;
        if (isJumping) {
          isJumping = false;
          animation = hasGun ? gunSprite : runAnimation;
        }
      }
    }
  }

  void gameOver() {
    game.pauseEngine();
    game.overlays.add('end');
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle || other is Bird) {
      gameOver();
    }
    if (other is Gun && !hasGun) {
      hasGun = true;
      animation = gunSprite;
      other.removeFromParent();
      guntimer = Timer(8.0, onTick: () {
        hasGun = false;
        animation = runAnimation;
      });
      guntimer?.start();
    }
  }

  void shoot() {
    if (hasGun) {
      final BulletPos = Vector2(position.x - 270, position.y -221);
      final bullet = Bullet(BulletPos);
      game.add(bullet);
    }
  }
}
