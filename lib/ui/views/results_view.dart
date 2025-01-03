import 'package:flutter/material.dart';
import 'package:project/models/levels.dart';
import 'package:project/repositories/preferences_repository.dart';

class ResultsView extends StatelessWidget {
  final int score;
  final Levels level;
  const ResultsView({super.key, required this.score, required this.level});

  @override
  Widget build(BuildContext context) {
    final PreferencesRepository preferencesRepository = PreferencesRepository();
    preferencesRepository.setHighScore(level, score);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Votre score :', style: TextStyle(fontSize: 20.0)),
            Text(score.toString(), style: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            // Two buttons: one to play again, one to go back to the home screen. content is text and icon
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/game', arguments: level);
              },
              icon: const Icon(Icons.replay),
              label: const Text('Rejouer'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.orange),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Accueil'),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.orange),
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: const BorderSide(color: Colors.orange, width: 1.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
