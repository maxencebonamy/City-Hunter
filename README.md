# City Hunter

A mobile game where you locate French cities on a blank map.

The player is given a city name and places a point on a map of France without labels. The closer the point is to the city, the more points the player earns. It is meant for anyone who wants to test their knowledge of French geography.

## Table of contents

- [City Hunter](#city-hunter)
	- [Table of contents](#table-of-contents)
	- [How it works](#how-it-works)
	- [Tech stack](#tech-stack)
	- [Repository structure](#repository-structure)
	- [Prerequisites](#prerequisites)
	- [Installation](#installation)
	- [Configuration](#configuration)
	- [Running locally](#running-locally)
	- [Useful scripts](#useful-scripts)
	- [API](#api)
	- [Tests and quality](#tests-and-quality)
	- [License](#license)

## How it works

1. **Level selection**: the player picks one of seven levels (Débutant, Intermédiaire, Avancé, Expert, Maître, Légendaire, Ultime). Each level corresponds to a range of city populations, from more than 100,000 inhabitants down to 20,000–23,000.
2. **City draw**: the app loads the list of metropolitan French communes, keeps those matching the level, and draws 10 at random. The outline of each drawn city is fetched from the government API.
3. **Guess**: the name of a city is displayed. The player taps the map, which uses tiles without labels, to place a point.
4. **Scoring**: a point inside the city outline earns 100 points. Otherwise the score is `(1000 - distance in km) / 10`, clamped between 0 and 100.
5. **Results**: after 10 rounds, the total score is shown and compared with the best score stored on the device for this level.
6. **Scores**: the best score of each level is kept locally and can be viewed from the scores screen.

## Tech stack

| Layer | Technologies |
| --- | --- |
| Application | Flutter 3.24.5, Dart 3.5.4 |
| State management | `flutter_bloc` (cubits) |
| Map | `flutter_map`, `latlong2` |
| UI | Material, `sliding_up_panel`, `linear_progress_bar` |
| Data | `http`, `shared_preferences`, `xrange` |
| Data sources | geo.api.gouv.fr (communes), CARTO (map tiles) |
| Tooling | `flutter_lints` |

## Repository structure

```
.
├── lib/
│   ├── blocs/          Cubits: city list and game state
│   ├── models/         City and level definitions
│   ├── repositories/   API access and local score storage
│   ├── ui/views/       Home, game, results and scores screens
│   ├── utils/          Polygon and random number helpers
│   └── main.dart       Application entry point
├── android/            Android project
├── ios/                iOS project
├── web/                Web project
├── linux/              Linux project
├── macos/              macOS project
└── windows/            Windows project
```

The code is split by responsibility: cubits hold the state, repositories talk to the API and to local storage, and views only render state.

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.24.5 (Dart 3.5.4)
- A device, emulator or simulator supported by Flutter
- An internet connection: cities and map tiles are fetched at runtime

## Installation

```bash
git clone git@github.com:maxencebonamy/City-Hunter.git
cd City-Hunter
flutter pub get
```

## Configuration

The project has no environment variable or configuration file. The API endpoints are defined in `lib/repositories/city_repository.dart` and `lib/ui/views/game_view.dart`.

## Running locally

```bash
flutter run
```

Use `flutter run -d <device-id>` to pick a target. The list of devices is given by `flutter devices`.

## Useful scripts

| Command | Effect |
| --- | --- |
| `flutter pub get` | Install dependencies |
| `flutter run` | Run the app on the selected device |
| `flutter analyze` | Run static analysis |
| `flutter build apk` | Build an Android APK |
| `flutter build ios` | Build an iOS app |

## API

The app consumes two external services and exposes none.

| Method | Route | Description |
| --- | --- | --- |
| `GET` | `https://geo.api.gouv.fr/communes?fields=code,nom,population,centre&zone=metro` | List of metropolitan communes |
| `GET` | `https://geo.api.gouv.fr/communes/{code}?fields=code,nom,population,centre,contour` | Details and outline of a commune |
| `GET` | `https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png` | Map tiles without labels |

## Tests and quality

The project has no tests yet. Static analysis uses the rules of `flutter_lints`.

```bash
flutter analyze
```

## License

This project is licensed under the [MIT License](LICENSE).
