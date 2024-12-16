import 'package:flutter/material.dart';

class ScoresView extends StatelessWidget {
  const ScoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Meilleurs Scores',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
        Expanded(
          child: Center(
            child: Text('Scores à venir...'),
          ),
        ),
      ],
    );
  }
}
