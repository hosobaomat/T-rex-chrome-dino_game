import 'package:dino_game/main.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  GameOverOverlay({super.key, required this.game});
  MyGame game;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GameOver.png'),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                game.overlays.remove('end');
                game.restartGame();
              },
              child: Image.asset(
                'assets/images/Reset.png',
                width: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
