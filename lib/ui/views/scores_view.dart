import 'package:flutter/material.dart';
import 'package:project/models/levels.dart';
import 'package:project/repositories/preferences_repository.dart';

class ScoresView extends StatelessWidget {
  const ScoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Meilleurs Scores',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: Levels.values.length,
            itemBuilder: (context, index) {
              final level = Levels.values[index];
              final PreferencesRepository preferencesRepository = PreferencesRepository();
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: FutureBuilder<int?>(
                    future: preferencesRepository.getHighScore(level),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        final int? highScore = snapshot.data;
                        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(
                            level.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            highScore?.toString() ?? '--',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.orange),
                          )
                        ]);
                      }
                    },
                  ));
            },
          ),
        ),
      ],
    );
  }
}
