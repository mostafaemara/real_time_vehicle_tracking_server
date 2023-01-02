import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:gpx/gpx.dart';

import '../location.dart';
import '../route.dart';

late List<Route> routes;
Timer? timer;
Future<Response> onRequest(RequestContext context) async {
  await initRoutes();
  final handler = webSocketHandler((channel, protocol) async {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      final currentLocations = updateRoutes();
      final encodedLocations = encodeLocations(currentLocations);
      channel.sink.add(
        encodedLocations,
      );
    });
  });

  return handler(context);
}

Future<List<Location>> readLocationsFromGpxFile(String name) async {
  final stringGPx = await File('gpx/$name.gpx').readAsString();

  final gpxFile = GpxReader().fromString(stringGPx);
  return gpxFile.wpts.map((e) => Location(e.lat!, e.lon!)).toList();
}

Future<void> initRoutes() async {
  routes = <Route>[];
  for (var i = 1; i < 6; i++) {
    final locations = await readLocationsFromGpxFile('route$i');
    routes.add(Route(locations));
  }
}

List<Location> updateRoutes() {
  final locations = <Location>[];

  for (final route in routes) {
    final location = route.moveNext();
    locations.add(location);
  }
  return locations;
}

String encodeLocations(List<Location> locations) {
  final locationsWithId = List.generate(
    locations.length,
    (index) => {
      'id': index,
      'lat': locations[index].lat,
      'lon': locations[index].lon,
    },
  );

  return jsonEncode(locationsWithId);
}
