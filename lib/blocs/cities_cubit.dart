import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/models/city.dart';
import 'package:project/repositories/city_repository.dart';

class CitiesCubit extends Cubit<List<City>> {
  final CityRepository cityRepository;

  CitiesCubit(this.cityRepository) : super([]);

  Future<void> loadCities() async {
    final cities = await cityRepository.fetchAllCities();
    emit(cities);
  }
}
