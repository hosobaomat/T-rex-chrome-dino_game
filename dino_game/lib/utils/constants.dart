class Constants {
  static double gamespeed = 400;
  static double spawnTime = 0;
  static double spawnCloud = 0;
  static double spawnBird = 0;
  static bool startGame = false;
  static final double speedCloud = 200;
  static double score = 0;
  static double highscore = 0;
  static double increaseRate = 0.1;
  static double get currentSpeed {
    return gamespeed * (1 + (score ~/ 100) * increaseRate);
  }
}
