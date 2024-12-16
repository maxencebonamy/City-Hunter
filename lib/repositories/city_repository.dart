import 'dart:convert';

import 'package:http/http.dart';
import 'package:project/models/city.dart';

class CityRepository {
  Future<List<City>> fetchAllCities() async {
    final Response response = await get(Uri.parse('https://geo.api.gouv.fr/communes?fields=code,nom,population,centre&zone=metro'));
    if (response.statusCode == 200) {
      final List<City> cities = [];
      final List<dynamic> json = jsonDecode(response.body);
      for (Map<String, dynamic> cityJson in json) {
        final City city = City.fromApi(cityJson);
        if (city.population != null && city.population! > 10000) {
          cities.add(city);
        }
      }
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<CityWithBounds> fetchCityById(String id) async {
    final Response response = await get(Uri.parse('https://geo.api.gouv.fr/communes/$id?fields=code,nom,population,centre,contour'));
    if (response.statusCode == 200) {
      final dynamic json = jsonDecode(response.body);
      return CityWithBounds.fromApi(json);
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
