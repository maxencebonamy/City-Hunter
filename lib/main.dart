import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/blocs/cities_cubit.dart';
import 'package:project/blocs/game_cubit.dart';
import 'package:project/models/city.dart';
import 'package:project/repositories/city_repository.dart';
import 'package:project/ui/views/game_view.dart';
import 'package:project/ui/views/home_view.dart';
import 'package:project/ui/views/scores_view.dart';

void main() {
  final citiesCubit = CitiesCubit(CityRepository());
  citiesCubit.loadCities();

  final gameCubit = GameCubit(CityRepository(), citiesCubit);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => citiesCubit),
      BlocProvider(create: (_) => gameCubit),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routes: {
        '/game': (context) => const GameView(),
        '/scores': (context) => const ScoresView(),
      },
      home: MyHomePage(title: 'Villes de France'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final List<CityWithBounds> cities = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const ScoresView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Scores',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
