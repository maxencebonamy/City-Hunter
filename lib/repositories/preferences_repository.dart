import 'package:city_hunter/models/levels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  Future<int?> getHighScore(Levels level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? highScore = prefs.getInt('HS-${level.name.toLowerCase()}');
    return highScore;
  }

  Future<void> setHighScore(Levels level, int score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('HS-${level.name.toLowerCase()}', score);
  }
}
