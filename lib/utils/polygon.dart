import 'package:latlong2/latlong.dart';

bool isInsidePolygon(LatLng point, List<LatLng> polygon) {
  int intersectCount = 0;
  for (int j = 0; j < polygon.length - 1; j++) {
    if (rayIntersectsSegment(point, polygon[j], polygon[j + 1])) {
      intersectCount++;
    }
  }
  return (intersectCount % 2) == 1;
}

bool rayIntersectsSegment(LatLng point, LatLng vertex1, LatLng vertex2) {
  double px = point.latitude;
  double py = point.longitude;
  double v1x = vertex1.latitude;
  double v1y = vertex1.longitude;
  double v2x = vertex2.latitude;
  double v2y = vertex2.longitude;

  if ((v1y > py && v2y > py) || (v1y < py && v2y < py) || (v1x < px && v2x < px)) {
    return false;
  }

  double m = (v2y - v1y) / (v2x - v1x);
  double bee = v1y - m * v1x;
  double x = (py - bee) / m;

  return x > px;
}
