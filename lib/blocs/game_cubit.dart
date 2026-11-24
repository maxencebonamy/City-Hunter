import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_hunter/blocs/cities_cubit.dart';
import 'package:city_hunter/models/city.dart';
import 'package:city_hunter/models/levels.dart';
import 'package:city_hunter/repositories/city_repository.dart';
import 'package:city_hunter/utils/random.dart';

class GameCubit extends Cubit<List<CityWithBounds>> {
  final CityRepository cityRepository;
  final CitiesCubit citiesCubit;

  GameCubit(this.cityRepository, this.citiesCubit) : super([]);

  Future<void> reset(Levels level) async {
    final filteredCities = citiesCubit.state.where((city) => city.population != null && level.range.contains(city.population!)).toList();
    final randomNumbers = RandomUtils.generateRandomNumbers(10, filteredCities.length);
    final randomCityIds = randomNumbers.map((index) => filteredCities[index].id).toList();
    final List<CityWithBounds> randomCities = [];

    int count = 0;
    for (String id in randomCityIds) {
      cityRepository.fetchCityById(id).then((CityWithBounds city) {
        randomCities.add(city);
        if (++count == randomCityIds.length) {
          emit(randomCities);
        }
      });
    }
  }
}
