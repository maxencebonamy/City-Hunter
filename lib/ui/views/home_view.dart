import 'package:flutter/material.dart';
import 'package:project/models/levels.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Sélectionnez un niveau',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 0.4)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: Levels.values.length,
            itemBuilder: (context, index) {
              final level = Levels.values[index];
              return ListTile(
                title: Text(level.name),
                subtitle: Text(
                  level.description,
                  style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
