import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/blocs/cities_cubit.dart';
import 'package:project/models/city.dart';
import 'package:project/repositories/city_repository.dart';
import 'package:project/ui/views/game_view.dart';
import 'package:project/utils/random.dart';

void main() {
  final CitiesCubit citiesCubit = CitiesCubit(CityRepository());
  citiesCubit.loadCities();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => citiesCubit),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  void fetchRandomCities(List<City> cities) {
    final List<int> randomNumbers = RandomUtils.generateRandomNumbers(10, cities.length);
    final List<String> randomCityIds = randomNumbers.map((index) => cities[index].id).toList();
    final CityRepository cityRepository = CityRepository();
    final List<CityWithBounds> randomCities = [];
    for (String id in randomCityIds) {
      cityRepository.fetchCityById(id).then((CityWithBounds city) {
        randomCities.add(city);
        if (randomCities.length == randomCityIds.length) {
          setState(() {
            widget.cities.clear();
            widget.cities.addAll(randomCities);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameView();
    return BlocBuilder<CitiesCubit, List<City>>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final CityWithBounds city = widget.cities[index];
                    return ListTile(
                      title: Text(city.name),
                      subtitle: Text('Population: ${city.population}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            fetchRandomCities(context.read<CitiesCubit>().state);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
