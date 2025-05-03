import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Guide extends StatelessWidget {
  final FlameGame game;
  const Guide({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tap the right side of the screen to shoot if you are holding a weapon (e.g., AK-47).',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'Tap the left side of the screen to jump.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'If you are not holding any weapon, tapping the screen will make you jump automatically.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'Each weapon has a limited duration.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'Obstacles appear randomly (currently birds and cacti).',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'Sometimes two obstacles can spawn at the same position.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'The game speed increases as your score gets higher.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Text(
                'This game was created by Tran Manh Hung using Flutter and Dart during his free time.',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
                  Text(
                    'Tap anywhere to start!',
                    style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
