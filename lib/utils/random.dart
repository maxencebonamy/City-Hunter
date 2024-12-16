import 'dart:math';

class RandomUtils {
  static List<int> generateRandomNumbers(int n, int max) {
    List<int> randomNumbers = [];
    while (randomNumbers.length < n) {
      int randomNumber = Random().nextInt(max);
      if (!randomNumbers.contains(randomNumber)) {
        randomNumbers.add(randomNumber);
      }
    }
    return randomNumbers;
  }
}
