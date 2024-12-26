import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:project/blocs/game_cubit.dart';
import 'package:project/models/city.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final _mapController = MapController();
  LatLng currentPosition = const LatLng(46.603354, 1.888334);
  List<Marker> markers = [];
  int currentCityIndex = 0;

  void _onMapTap(LatLng point) {
    setState(() {
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
                            if (currentCityIndex < cities.length - 1) {
                              currentCityIndex++;
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
                        child: const Text(
                          "Valider",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SCORE", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text("0", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
