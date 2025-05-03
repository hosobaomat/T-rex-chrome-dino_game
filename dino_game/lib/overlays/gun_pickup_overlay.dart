import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GunPickupOverlay extends StatelessWidget {
  final FlameGame game;
  const GunPickupOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🔫 You picked up an AK-47!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Text(
              '🔫 You have 8 seconds to use it!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
