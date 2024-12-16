import 'dart:ffi';

import 'package:xrange/xrange.dart';

enum Levels { beginner, intermediate, advanced, expert, master, legendary, ultime }

extension LevelsExtension on Levels {
  String get name {
    switch (this) {
      case Levels.beginner:
        return 'Débutant';
      case Levels.intermediate:
        return 'Intermédiaire';
      case Levels.advanced:
        return 'Avancé';
      case Levels.expert:
        return 'Expert';
      case Levels.master:
        return 'Maître';
      case Levels.legendary:
        return 'Légendaire';
      case Levels.ultime:
        return 'Ultime';
    }
  }

  NumRange get range {
    switch (this) {
      case Levels.beginner:
        return NumRange.atLeast(100000);
      case Levels.intermediate:
        return NumRange.closed(60000, 100000);
      case Levels.advanced:
        return NumRange.closed(45000, 60000);
      case Levels.expert:
        return NumRange.closed(35000, 45000);
      case Levels.master:
        return NumRange.closed(28000, 35000);
      case Levels.legendary:
        return NumRange.closed(23000, 28000);
      case Levels.ultime:
        return NumRange.closed(20000, 23000);
    }
  }

  String get description {
    if (range.lastValue == null) {
      return 'Plus de ${range.firstValue} habitants';
    } else {
      return 'Entre ${range.firstValue} et ${range.lastValue} habitants';
    }
  }
}
