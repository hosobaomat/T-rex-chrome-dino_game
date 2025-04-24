import 'package:dino_game/main.dart';
import 'package:flutter/material.dart';

class StartGameOverlay extends StatelessWidget {
  StartGameOverlay({
    super.key,
    required this.game,
  });
  MyGame game;
  @override
  Widget build(BuildContext context) {
    game.pauseEngine;
    return GestureDetector(
      onTap: () {
        game.overlays.remove('start');
        game.resumeEngine();
      },
      // child: Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(image: image)
      //   ),
      // ),
    );
  }
}
