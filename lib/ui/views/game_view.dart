import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:project/blocs/game_cubit.dart';
import 'package:project/models/city.dart';
import 'package:project/models/levels.dart';
import 'package:project/ui/views/results_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum GameStatus { playing, paused, finished }

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final _mapController = MapController();
  GameStatus status = GameStatus.playing;
  LatLng currentPosition = const LatLng(46.603354, 1.888334);
  List<Marker> markers = [];
  List<LatLng> polylinePoints = [];
  List<Polygon> polygons = [];
  int currentCityIndex = 0;
  int score = 0;

  void _onMapTap(LatLng point) {
    setState(() {
      if (status == GameStatus.playing) {
        currentPosition = point;
        markers = [
          Marker(
            width: 40.0,
            height: 40.0,
            point: point,
            alignment: Alignment.topCenter,
            child: const Icon(
              Icons.location_on,
              size: 40.0,
              color: Colors.orange,
            ),
          ),
        ];
      }
    });
  }

  void _displayCityOnMap(CityWithBounds city) {
    setState(() {
      markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: city.center,
          alignment: Alignment.topCenter,
          child: const Icon(
            Icons.location_on,
            size: 40.0,
            color: Colors.green,
          ),
        ),
      );
      polylinePoints = [currentPosition, city.center];
      polygons = city.bounds.map((List<LatLng> bounds) {
        return Polygon(
          points: bounds,
          borderColor: Colors.blue,
          borderStrokeWidth: 2.0,
          color: Colors.blue.withOpacity(0.2),
        );
      }).toList();
    });
  }

  void _updateScore(CityWithBounds city) {
    final distance = const Distance().as(LengthUnit.Kilometer, currentPosition, city.center);
    setState(() {
      if (city.isInside(currentPosition)) {
        score += 100;
      } else {
        score += ((1000 - distance) / 10).clamp(0, 100).round();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, List<CityWithBounds>>(builder: (context, cities) {
      if (cities.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        body: SlidingUpPanel(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          maxHeight: 280.0,
          minHeight: 120.0,
          panel: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Container(
                          width: 40.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Trouvez", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.orange)),
                            Text(currentCityIndex >= 0 ? cities[currentCityIndex].name : "",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (status == GameStatus.paused) {
                              if (currentCityIndex < cities.length - 1) {
                                setState(() {
                                  currentCityIndex++;
                                  markers.clear();
                                  polylinePoints.clear();
                                  polygons.clear();
                                });
                                status = GameStatus.playing;
                              } else {
                                status = GameStatus.finished;
                                final level = ModalRoute.of(context)!.settings.arguments as Levels;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ResultsView(score: score, level: level),
                                  ),
                                );
                              }
                            } else if (status == GameStatus.playing && markers.isNotEmpty) {
                              _displayCityOnMap(cities[currentCityIndex]);
                              _updateScore(cities[currentCityIndex]);
                              status = GameStatus.paused;
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.orange),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: Text(
                          status == GameStatus.playing
                              ? "Valider"
                              : currentCityIndex == cities.length - 1
                                  ? "Terminer"
                                  : "Suivant",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Round ${currentCityIndex + 1}/10"),
                            const SizedBox(height: 8),
                            LinearProgressBar(
                              maxSteps: 10,
                              progressType: LinearProgressBar.progressTypeLinear,
                              currentStep: currentCityIndex + 1,
                              progressColor: Colors.orange,
                              backgroundColor: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("SCORE", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(score.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: const Text("Quitter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          body: Center(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPosition,
                initialZoom: 5.2,
                minZoom: 5.0,
                maxZoom: 18.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onTap: (_, point) {
                  _onMapTap(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      strokeWidth: 2.0,
                      pattern: StrokePattern.dashed(segments: const [10, 10]),
                      color: Colors.green,
                    ),
                  ],
                ),
                PolygonLayer(
                  polygons: polygons,
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
