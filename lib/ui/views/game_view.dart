import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        maxHeight: 270.0,
        minHeight: 115.0,
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
                    const Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Trouvez", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.orange)),
                        Text("Argenteuil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    )),
                    ElevatedButton(
                      onPressed: () {},
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
                )),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Round 1/10"),
                        LinearProgressBar(
                          maxSteps: 6,
                          progressType: LinearProgressBar.progressTypeLinear,
                          currentStep: 1,
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
            ElevatedButton(
              onPressed: () => {},
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
        )),
        body: Center(
          child: FlutterMap(
            mapController: MapController(),
            options: const MapOptions(
              initialCenter: LatLng(46.603354, 1.888334),
              initialZoom: 5.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'fr.maximeduby.project',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
