import 'package:latlong2/latlong.dart';
import 'package:project/utils/polygon.dart';

LatLng parseLatLng(dynamic coordinates) {
  return LatLng(double.parse(coordinates[1].toString()), double.parse(coordinates[0].toString()));
}

class City {
  final String id;
  final String name;
  final int? population;
  final LatLng center;

  const City(this.id, this.name, this.population, this.center);

  @override
  String toString() {
    return '$name, population: ${population ?? 0},  center: (lat=${center.latitude}, long=${center.longitude})';
  }

  factory City.fromApi(Map<String, dynamic> json) {
    final String id = json['code'];
    final String name = json['nom'];
    final int? population = json['population'];
    final List<dynamic> center = json['centre']['coordinates'];
    return City(id, name, population, parseLatLng(center));
  }
}

class CityWithBounds extends City {
  final List<List<LatLng>> bounds;

  const CityWithBounds(super.id, super.name, super.population, super.center, this.bounds);

  factory CityWithBounds.fromApi(Map<String, dynamic> json) {
    final City city = City.fromApi(json);
    final dynamic geoJson = json['contour'];
    final List<List<LatLng>> bounds = [];

    if (geoJson['type'] == 'Polygon') {
      final List<dynamic> coordinates = geoJson['coordinates'][0];
      bounds.add(coordinates.map((dynamic coord) => parseLatLng(coord)).toList().cast<LatLng>());
    } else if (geoJson['type'] == 'MultiPolygon') {
      final List<dynamic> polygons = geoJson['coordinates'];
      for (List<dynamic> polygon in polygons) {
        bounds.add(polygon[0].map((dynamic coord) => parseLatLng(coord)).toList().cast<LatLng>());
      }
    } else {
      throw Exception('Unsupported GeoJSON type: ${geoJson['type']}');
    }

    return CityWithBounds(city.id, city.name, city.population, city.center, bounds);
  }

  List<List<LatLng>> getBoundsAsLatLng() {
    return bounds;
  }

  bool isInside(LatLng point) {
    for (List<LatLng> polygon in bounds) {
      if (isInsidePolygon(point, polygon)) {
        return true;
      }
    }
    return false;
  }
}
